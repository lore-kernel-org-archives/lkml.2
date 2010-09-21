Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab0IUWFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 18:05:11 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37453 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab0IUWFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 18:05:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=DW7FMW1oxCAboIR0M0DVHUd3UN8SCzb9Jtu2/D+2FqcUnHQ0kgjJDhHjURpjUyPSu5
         ABHFL7rvIM2131XcHClJKH+rDdMdo53vLFNpJgLR7A1zXPkNMTIvkP0N1bw1uxvsPrwy
         qbdC/0x3k8bO71eR4PfywGT+HpjcXf6P0SnUA=
MIME-Version: 1.0
In-Reply-To: <20100921164944.164ed0af@udp111988uds.am.freescale.net>
References: <1285066638-7473-1-git-send-email-leoli@freescale.com>
 <877FD0B5-19A7-4A16-831E-369B80B104EA@kernel.crashing.org>
 <AANLkTimiwtoa6i10OTcgFnvbvcO9N4KWHyt4Poj-yj=T@mail.gmail.com>
 <20100921163456.7e2c9b32@udp111988uds.am.freescale.net> <AANLkTine--kry0c0n87WOqYyi3AQOb2KnmNRs-MeXcQt@mail.gmail.com>
 <20100921164944.164ed0af@udp111988uds.am.freescale.net>
From: Timur Tabi <timur@freescale.com>
Date: Tue, 21 Sep 2010 17:04:39 -0500
X-Google-Sender-Auth: uZLdeUC6w1fy2iWFANn2j2sJQO8
Message-ID: <AANLkTik3dNU1FdUG6sWnQ3P0eXQu62PrckQ9_-Dk7GEJ@mail.gmail.com>
Subject: Re: [PATCH] fsldma: add support to 36-bit physical address
To: Scott Wood <scottwood@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>, dan.j.williams@intel.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 4:49 PM, Scott Wood <scottwood@freescale.com> wrote:

> Look in dmaengine.c, there are calls to dma_map_single() and
> dma_map_page(), using what I assume is that same device pointer --
> unless there's confusion between the channel and the controller.

You're right.  I missed this line in the driver:

	fdev->common.dev = &op->dev;

Also, the driver does something stupid.  Sometimes "chan->dev" refers
to dma_chan.chan, and sometimes it refers to fsldma_chan.chan.  I
could have sworn I saw a patch that fixes that, though.

-- 
Timur Tabi
Linux kernel developer at Freescale
