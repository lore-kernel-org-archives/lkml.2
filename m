Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab1FRLDB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 07:03:01 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:43750 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab1FRLDA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 07:03:00 -0400
X-Greylist: delayed 332 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Jun 2011 07:02:59 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tyM1t8AuXrVeZymqqSwVc9U2RyRpe5AQ6siDa1mbVWvNgByHCBocRPdz9PJT0jlZdP
         hiNr0jJZbrQQ3gjNf9w2a4W5z0w9yi9EoftEi0PlfsJ7xMJwqDYhqb/Efrlhrf3ne3p2
         p+8Syyv/twVBSvbtnnMa8BMxfMTJcdKNjuFWw=
MIME-Version: 1.0
In-Reply-To: <20110618133957.378b5266@farn.lan>
References: <BANLkTi=o06eHLtFvmmz7c4TEjahy=EOrJQ@mail.gmail.com>
	<20110618133957.378b5266@farn.lan>
Date: Sat, 18 Jun 2011 12:57:26 +0200
Message-ID: <BANLkTikT3qoZhTrd0uF-JNehNhTCRjF6kw@mail.gmail.com>
Subject: Re: Lock up when faking MMIO read[bwl] on some machines [WAS: Faking
 MMIO ops? Fooling a driver]
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Pekka Paalanen <pq@iki.fi>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 18 czerwca 2011 12:39 użytkownik Pekka Paalanen <pq@iki.fi> napisał:
> On Sat, 18 Jun 2011 00:31:32 +0200
> Rafał Miłecki <zajec5@gmail.com> wrote:
>
>> I use attached patch to fake result of read[bwl] performed by
>> closed source driver (ndiswrapper+bcmwl and wl).
>>
>> 1) It works great on my Sony VAIO with Intel(R) Core(TM)2 Duo CPU
>> P8400 2) It locks up Macbook Pro 8,1 with some 8-cores Intel
>>
>> Do you have any idea why it causes the lockup? Function causing
>> problem is "set_ins_reg_val". I've created it as copy of
>> get_ins_reg_val, it just sets values in struct pt_regs, instead of
>> reading them).
>
> Sorry, I have no insight to that... does unmodified mmiotrace
> work properly? Are you tracing the exact same kernel binary blob
> on both machines? Maybe it's using some rare instruction
> mmiotrace does not decode properly? Maybe with a rep prefix?
> Do those CPUs have any differences in their registers or
> struct pt_regs?
>
> I'm not even sure how "legal" it is to poke pt_regs there. :-/

Not modified MMIO tracing works great on this machine, I've grabbed
dumps 10-20 times without a lock up or anything.

I'm using different drivers on both machines, because Macbook Pro 8,1
has unique BCM4331 card that I can not buy and that is not available
with PCI(e) slot. Is uses some vendor specific, PCIe compatible slot.
Simple commenting out "set_ins_reg_val" work fine on this Macbook, PHY
reads are tracked correctly.

As for differences in struct pt_regs... yeah, I think that happens.
I'm using x86 kernel, while on Macbook we use x86_64 as it's required
to use 64bit driver in ndiswrapper.

I can try to find out, which register we try to overwrite on Macbook.

-- 
Rafał
