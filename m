Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab0I3Jgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 05:36:35 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45371 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab0I3Jge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 05:36:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ikUvbII6SUzeZBdE3PVLhvDNTMEKk1gBEkUa5XX+0gKObHAKsSymLK9Bj0EKHhaYoQ
         8Z/lRQaVXq5EX982l2VlpdoGIYOzglEHMxKGUvkkTP/OV0TlMgO6eL+Ycs1pJwoRjl0N
         BVn9XsOuACBGcwC5tXZicekdromJoY4HM3k3M=
MIME-Version: 1.0
In-Reply-To: <20100930083806.GU13563@erda.amd.com>
References: <1285549026-5008-6-git-send-email-ying.huang@intel.com>
	<20100927100901.GC32222@erda.amd.com>
	<AANLkTimY5hr3DgN9=v83Z289MkzjgX8k0WzdTWZbGorj@mail.gmail.com>
	<20100927133816.GP13563@erda.amd.com>
	<20100927152014.GY26290@redhat.com>
	<1285634172.20791.92.camel@yhuang-dev>
	<20100928153247.GL26290@redhat.com>
	<AANLkTinmhTgVhPsmGLC8Z-9Kx3xRovWy=9+R_5B4u6Cx@mail.gmail.com>
	<20100930043628.GE26290@redhat.com>
	<1285822630.6944.69.camel@yhuang-dev>
	<20100930083806.GU13563@erda.amd.com>
Date: Thu, 30 Sep 2010 17:36:33 +0800
Message-ID: <AANLkTimWwO=6uOxxXdSgOU2vWY8a-XeW1b+GRyua2Brw@mail.gmail.com>
Subject: Re: [PATCH -v2 6/7] x86, NMI, Add support to notify hardware error
 with unknown NMI
From: huang ying <huang.ying.caritas@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Huang Ying <ying.huang@intel.com>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 4:38 PM, Robert Richter <robert.richter@amd.com> wrote:
> On 30.09.10 00:57:10, Huang Ying wrote:
>> Yes. Both MCE and perf are CPU features. I think they can be thought as
>> optional architectural features. I think it is good to put similar
>> features into arch/x86/kernel/cpu instead of traps.c. But if necessary,
>> we can put direct call in traps.c instead of notifier block.
>
> As you see it seems not being obviously, what goes here and what goes
> there. The approach is wrong. If we want to handle some hardware
> feature, we should simply register a handler for this. Implemetations
> for unhandled or unrecovered interrupts should be in traps.c. It's
> that simple.

That is possible. I just don't like it. We should keep things as
"straightforward" as possible. Direct call is more straightfoward than
indirect call like notifier chain.

Best Regards,
Huang Ying
