Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab1A0UDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 15:03:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63355 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab1A0UDQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 15:03:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sFgdmJTOIS5eYSoR3r45+Q3VLaZeIjMosJHza5Bp4xzCxu8L4DvFCpkE7gNSth9ojB
         DHdyRlAwh7nI2eESF5Zv/3MFTty9a1a83um+mEx80NYp0do3fAJXn6Jq2IAZsgQlRmo+
         iLXoGFK+VJFjOSY1OCo6d0ToLh5kZUD0Tf4Pc=
MIME-Version: 1.0
In-Reply-To: <20110114134345.712e2e29@queued.net>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>
	<1292600033-12271-2-git-send-email-bigeasy@linutronix.de>
	<20101230083745.GC11721@angua.secretlab.ca>
	<20110104130839.GA21359@www.tglx.de>
	<20110114081446.GC21832@angua.secretlab.ca>
	<20110114105709.GA7562@www.tglx.de>
	<20110114134345.712e2e29@queued.net>
Date: Thu, 27 Jan 2011 19:54:41 +0000
X-Google-Sender-Auth: QMmti26d0dCKYqCxatEqdr5T9Ns
Message-ID: <AANLkTimyrGkqtjo99+aV+N4KcrC2_3PprpRD2tRo_NtC@mail.gmail.com>
Subject: Re: [PATCH v2 01/15] x86/e820: remove conditional early mapping in parse_e820_ext
From: Daniel Drake <dsd@laptop.org>
To: Andres Salomon <dilinger@queued.net>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        sodaville@linutronix.de, x86@kernel.org, dirk.brandewie@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,



On 14 January 2011 21:43, Andres Salomon <dilinger@queued.net> wrote:
>> In case "[v2,13/15] x86/rtc: don't register rtc if we the DT blob" [0]
>> goes into the category "lost track" and not "had no time to reply"
>> could please take a look? The important part is where it could change
>> behavior for OLPC and it migh end up without a RTC. I Cc Andres
>> Salomon as might know where the RTC on OLPC is comming from.
>
> The RTC that OLPC uses for XO-1 was interspersed w/ the power management
> stuff, so it hasn't gone upstream yet (dsd is still working on the pm
> stuff). Thus, for Linus kernels the XO-1 uses rtc_cmos; so yes, this
> could break things.
>
> On OLPC kernels on the XO-1, we read RTC information from the
> CS5536's MSRs (note that there's nothing there that's OLPC-specific, so
> this should probably become a generic geode RTC driver).  I'm unfamiliar
> with the XO-1.5, but it appears we use the VX855 RTC (at least for
> wakeups). I don't see a specific RTC driver for it, so I suspect it
> relies on rtc_cmos.

Context: https://patchwork.kernel.org/patch/450681/

This patch will indeed cause problems for OLPC. Thanks for bringing it
to our attention.

On OLPC, the device tree is not used as a source of devices like on
other platforms, it is simply used to present information to the
kernel and userspace (in read-only fashion).

If I understand it correctly, the above patch is saying: if we have a
device tree, don't add the standard x86 RTC device.

However, what we need it to say is: if we have a device tree *and* the
device tree is being used as a source of devices, don't add the
standard x86 RTC device.

Therefore in the OLPC case, this particular bail-out condition will
never be met, because the device tree is not being used as a source of
devices.

Does that make sense?

Thanks,
Daniel
