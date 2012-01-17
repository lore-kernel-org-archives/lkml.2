Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab2AQCrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 21:47:39 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39993 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab2AQCrg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 21:47:36 -0500
MIME-Version: 1.0
In-Reply-To: <1326744932.16150.9.camel@sbsiddha-desk.sc.intel.com>
References: <1326744932.16150.9.camel@sbsiddha-desk.sc.intel.com>
Date: Mon, 16 Jan 2012 18:47:36 -0800
X-Google-Sender-Auth: AcO7lmvotPWJI4EyHIH2KkrcvVU
Message-ID: <CAE9FiQU9uja8JU0CyzU2wDxTqo41ZY45aTLiT6y2538Yt7PhiA@mail.gmail.com>
Subject: Re: [patch] x86, tsc: fix SMI induced variation in quick_pit_calibrate()
From: Yinghai Lu <yinghai@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, asit.k.mallick@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 12:15 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> Linus, We are seeing NTP failures on a big cluster as a result of big
> variation in calibrated TSC values. Our debug showed that it is indeed
> because of the SMI and its effect on quick pit calibration. Appended
> patch helps fix it. It ran over the weekend boot tests with out any
> failures.
>
>
>  [ As far as the SMI source is concerned, this is a periodic SMI that gets
>    disabled after ACPI is enabled by the OS. But the TSC calibration happens
>    before the ACPI is enabled. ]
>

Hi, Suresh

Do you know what is SMI doing at that time ? with USB legacy emulating?

I have some patches that will do USB hand off early.
Wonder if that would help.
please check those patches at

git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
usb_smi_disable_early

Thanks

Yinghai Lu
