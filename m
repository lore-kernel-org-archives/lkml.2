Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093Ab0JUVQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 17:16:09 -0400
Received: from edu-smtp-01.edutel.nl ([88.159.1.175]:35008 "EHLO
	edu-smtp-01.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab0JUVQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 17:16:07 -0400
Message-ID: <4CC0AD74.8070800@neli.hopto.org>
Date: Thu, 21 Oct 2010 23:15:32 +0200
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: Alexandre Bounine <alexandre.bounine@idt.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Thomas Moll <thomas.moll@sysgo.com>
Subject: Re: [PATCH -mm 0/2] RapidIO: Changes to handling of RIO switches
References: <1287688250-14226-1-git-send-email-alexandre.bounine@idt.com>
In-Reply-To: <1287688250-14226-1-git-send-email-alexandre.bounine@idt.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexandre Bounine wrote:
> 1. Using one storage location common for switches and endpoints eliminates
> unnecessary device type checks during maintenance access operations.
> While destination IDs and hop counts have different meaning for endpoints and
> switches, this does not prevent us from storing them in the primary RIO device
> structure (rio_dev) for both types.

How can you say this? The two variables have different meanings, this 
logically implies you can't merge them. So how do you say 'this does not 
prevent us from ...' without providing a reason?

> 2. Convert RIO switch device structures (rio_dev + rio_switch) into single
> allocation unit. This change is based on the fact that RIO switches are using
> common RIO device objects anyway. Allocating RIO switch objects as RIO devices
> with added space for switch information simplifies handling of RIO switch device
> objects.

I still don't think that's a good idea because the rdev->rswitch pointer 
can be defined to point to the switch that a given rio_dev is connected 
to. This is useful for quick lookups. How else can to know to which 
switch a given device is connected?

Micha
