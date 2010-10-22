Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab0JVV7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 17:59:07 -0400
Received: from edu-smtp-02.edutel.nl ([88.159.1.176]:60810 "EHLO
	edu-smtp-02.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab0JVV7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 17:59:05 -0400
Message-ID: <4CC20923.8050400@neli.hopto.org>
Date: Fri, 22 Oct 2010 23:58:59 +0200
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Thomas Moll <thomas.moll@sysgo.com>
Subject: Re: [PATCH -mm 0/2] RapidIO: Changes to handling of RIO switches
References: <1287688250-14226-1-git-send-email-alexandre.bounine@idt.com> <4CC0AD74.8070800@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E55201445906@CORPEXCH1.na.ads.idt.com> <4CC1D7DE.7060405@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E55201445A6B@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E55201445A6B@CORPEXCH1.na.ads.idt.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bounine, Alexandre wrote:
> Micha Nelissen <micha@neli.hopto.org> wrote:
>> rswitch->rdev->destid should be the id associated with a given switch,
>> so that every (processor) device can agree what id some switch has.
> 
> If we will need to identify the same physical switch by different
> processors we may use the component tag which now is unique for every
> device.

Yes, identification is the point. I think it might be confusing to have 
a destid *and* a component tag id which are slightly different. The 
destid is unambiguous (if you know whether the device is a switch or 
endpoint) so I think it makes sense to use that if possible.

> This actually gives me another idea: instead of using global
> next_switchid counter make rswitch->switchid = component_tag and
> switches in sysfs will look identical for every processor (or just get
> rid of rswitch->switchid and use component_tag directly for switches).

I still prefer the destid as the single identification id.

Micha
