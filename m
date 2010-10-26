Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426Ab0JZOWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:22:55 -0400
Received: from edu-smtp-02.edutel.nl ([88.159.1.176]:49433 "EHLO
	edu-smtp-02.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758331Ab0JZOWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:22:54 -0400
Message-ID: <4CC6E43C.8010104@neli.hopto.org>
Date: Tue, 26 Oct 2010 16:22:52 +0200
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Thomas Moll <thomas.moll@sysgo.com>
Subject: Re: [PATCH -mm 0/2] RapidIO: Changes to handling of RIO switches
References: <1287688250-14226-1-git-send-email-alexandre.bounine@idt.com> <4CC0AD74.8070800@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E55201445906@CORPEXCH1.na.ads.idt.com> <4CC1D7DE.7060405@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E55201445A6B@CORPEXCH1.na.ads.idt.com> <4CC20923.8050400@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E55201445BA4@CORPEXCH1.na.ads.idt.com> <4CC5ACAB.7070309@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E5520147D5C2@CORPEXCH1.na.ads.idt.com> <4CC5E354.80009@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E5520147D879@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E5520147D879@CORPEXCH1.na.ads.idt.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bounine, Alexandre wrote:
> Micha Nelissen <micha@neli.hopto.org> wrote:
>> I look at it this way: it prevents the need for another layer of
>> indirection: translating component tag to a destid.
> 
> The destid alone is not enough. You will need an entire rio_dev object
> for that device anyway.

?? I did not say a rio_dev object is not needed; on the contrary, I do 
have it.

In various parts of the enumeration and routing algorithm, it would need 
to lookup the tag to find the destid, if the destid is in the tag then 
this lookup is not needed.

> I think we are mixing two things together here. I understand your idea
> but do not see how it prevents me from having one common set of access
> coordinates for RIO devices (the starting point of our discussion). 

I'm trying to argue we do not want redundant identification in the first 
  place unless absolutely necessary.

> Regardless of an implementation, having a way that ensures unified
> identification of switches by all processor boards is better than the
> current mainline implementation. 

Well, we both know "the current mainline implementation" is easily 
improved to unique identification I proposed. Therefore this statement 
is misleading.

> Methods of forming a component tag may
> differ but still serve the same purpose. Personally I prefer to avoid
> any link of device identification to the destid because it may not be as
> intuitive as it seems for large systems with hot-plug. I will discuss
> this with some of RIO TWG guys to get their opinion on the best
> approach.

Please do, please elaborate: "may not be as intuitive" ... to what? for 
implementation of ...?

> I will make a patch that defines fields of component tag, probably just
> one for now - identification field. This will ensure that any method
> used to assign component tag (id part of it) will be compatible with RIO
> spec part 8 error management.

Again slightly misleading information. Any unique identification 
satisfies this requirement.

To prove my point: are you going to recycle the component tags as well 
in case of hot-swaps, just like the destids?

> As for switch identification, at this moment I still prefer replacing
> rswitch->switchid with ID portion of the component tag because it is
> very simple and does not require changes to enumeration algorithm.   

Yes, I agree switchid = tag, that's what I use also.

Micha
