Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab0ITUk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 16:40:59 -0400
Received: from edu-smtp-01.edutel.nl ([88.159.1.175]:58960 "EHLO
	edu-smtp-01.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756831Ab0ITUk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 16:40:58 -0400
Message-ID: <4C97C6D8.4010407@neli.hopto.org>
Date: Mon, 20 Sep 2010 22:40:56 +0200
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Thomas Moll <thomas.moll@sysgo.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH v2 03/10] RapidIO: Use stored ingress port number instead
 of register read
References: <1284476363-1677-1-git-send-email-alexandre.bounine@idt.com><1284476363-1677-4-git-send-email-alexandre.bounine@idt.com> <20100914151219.5d92c6f9.akpm@linux-foundation.org> <0CE8B6BE3C4AD74AB97D9D29BD24E55201303D0E@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E55201303D0E@CORPEXCH1.na.ads.idt.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

Bounine, Alexandre wrote:
> struct rio_dev {
>     struct list_head global_list;
>     struct list_head net_list;
>     .....
>     ..... rest of rio_dev
>     .....
>     struct rio_switch switch[0];
> }

It makes sense to let rio_dev structures point to the switch they are 
attached to. That can be useful in various situations, but is not 
possible with this setup.

If a rio_dev is a switch then rdev->rswitch->rdev == rdev holds.

> This will remove extra memory allocation, remove overlapping structure
> members and clean code sections like one shown below:
> 
> 	u8 hopcount = 0xff;
> 	u16 destid = rdev->destid;
> 
> 	if (rdev->rswitch) {
> 		destid = rdev->rswitch->destid;
> 		hopcount = rdev->rswitch->hopcount;
> 	}    

Note that it is possible for rdev->destid to differ from 
rdev->rswitch->destid even if rswitch->rdev == rdev (for non-hosts i.e. 
agents). rswitch->destid is the destid by which we discovered the switch 
(and can reach it) but rdev->destid is the actual id given to the switch.

Micha
