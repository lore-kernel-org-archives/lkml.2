Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab1AFVIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 16:08:48 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44750 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab1AFVIr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 16:08:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=a2ERK9CIL5g+A/RP3AIbwYUlfSDyfkTUs1vWa8QljeMjB3OjYr4CEqNteyniX4muAY
         d9FZ9ERJzEKD9Y4zWBJP4gPsp336BRs3xPjtgMDIUEbTiLP4BmNRqTvcIqSmCQ9P7xp/
         t2N7cgucjPOf9GpPubf9ii2KLpI7aKCjVuTTg=
MIME-Version: 1.0
In-Reply-To: <AANLkTinY5XysANA9Qd-h=U8wzDNjF4n0sSxMsXH4P+99@mail.gmail.com>
References: <AANLkTikKA-nStyNjkdsVa8hd=PFQR3tYTJh3MnfpNkD8@mail.gmail.com>
	<20110106104816.GA4026@tiehlicka.suse.cz>
	<AANLkTi=aTKFVO8Lx=fDUGrxVaQL73XrsxoOP7-qYKksb@mail.gmail.com>
	<1bdc18$j6a1ns@fmsmga002.fm.intel.com>
	<AANLkTinY5XysANA9Qd-h=U8wzDNjF4n0sSxMsXH4P+99@mail.gmail.com>
Date: Thu, 6 Jan 2011 22:08:46 +0100
Message-ID: <AANLkTinhiAfhnTsHwR48Gq5NLApy5iAAMwv830+SJDZU@mail.gmail.com>
Subject: Re: Linux 2.6.37
From: Alex Riesen <raa.lkml@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 21:55, Alex Riesen <raa.lkml@gmail.com> wrote:
> On Thu, Jan 6, 2011 at 18:49, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>>
>> My fear is that some machines have a dependency between the backlight
>> and panel power status. The patch in question changed the timing between
>> turning on the panel and adjusting the backlight which would be restore
>> with:
>>
>> diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
>> index aa23070..0b40b4f 100644
>> --- a/drivers/gpu/drm/i915/intel_lvds.c
>> +++ b/drivers/gpu/drm/i915/intel_lvds.c
>> @@ -106,6 +106,12 @@ static void intel_lvds_enable(struct intel_lvds *intel_lvds)
>>        I915_WRITE(ctl_reg, I915_READ(ctl_reg) | POWER_TARGET_ON);
>>        POSTING_READ(lvds_reg);
>>
>> +       {
>> +               u32 reg = HAS_PCH_SPLIT(dev) ? PCH_PP_STATUS : PPS_STATUS;
...
> FWIW it does not compile:
>  CC      drivers/gpu/drm/i915/intel_lvds.o
> drivers/gpu/drm/i915/intel_lvds.c: In function ‘intel_lvds_enable’:
> drivers/gpu/drm/i915/intel_lvds.c:110: error: ‘PPS_STATUS’ undeclared

Ah, I see. Should be PP_STATUS. Whatever. It does not help. The backlight
stays off.

P.S. Probably unrelated, but I just noticed that the backlight never goes
off when closing the lid. Am I supposed to hook up on the corresponding
input event and put the panel in standby? It used to work all by itself,
I think...
