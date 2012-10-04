Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494Ab2JDRlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 13:41:23 -0400
Received: from mail.vyatta.com ([76.74.103.46]:47891 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932214Ab2JDRlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 13:41:22 -0400
Date: Thu, 4 Oct 2012 10:40:45 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: mlindner@marvell.com, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/20] drivers/net/ethernet/marvell/skge.c: fix error
 return code
Message-ID: <20121004104045.4fa02775@nehalam.linuxnetplumber.net>
In-Reply-To: <CA+MoWDp=_F9opJbVkv9sDsmoykm7MTUZwRVumKCB0ZqDwD6NoQ@mail.gmail.com>
References: <1349281090-10013-20-git-send-email-peter.senna@gmail.com>
	<20121003092508.6a7da662@nehalam.linuxnetplumber.net>
	<CA+MoWDp4W5BCA1t_HgEtLhMs1btVTOkbtBytOVtAzJriEZ-16A@mail.gmail.com>
	<20121004074442.180d8f01@nehalam.linuxnetplumber.net>
	<CA+MoWDp=_F9opJbVkv9sDsmoykm7MTUZwRVumKCB0ZqDwD6NoQ@mail.gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Oct 2012 19:32:12 +0200
Peter Senna Tschudin <peter.senna@gmail.com> wrote:

> >> Stephen, I do not want to include function names on the commit
> >> message. What do you think about this updated message, is it
> >> acceptable?
> >>
> >
> > No still to generic, it needs to be written by a human examining
> > the file and understanding what the cause and effect of the bug
> > is.
> 
> Stephen I've understood what you want. But it is not clear to me why
> you want. Let me show what Coccinelle produces as output:
> 
> [peter@ace linux-next]$ spatch ../../cocci/ret4.cocci -dir .
> ...
> * TODO [[view:./drivers/net/ethernet/sun/sungem.c::face=ovl-face1::linb=2894::colb=1::cole=3][./drivers/net/ethernet/sun/sungem.c::2894]]
> [[view:./drivers/net/ethernet/sun/sungem.c::face=ovl-face2::linb=2966::colb=1::cole=3][./drivers/net/ethernet/sun/sungem.c::2966]]
> [[view:./drivers/net/ethernet/sun/sungem.c::face=ovl-face2::linb=3015::colb=1::cole=7][./drivers/net/ethernet/sun/sungem.c::3015]]
> ...
> 
> There is "no" automatic code transformation. The semantic patch I'm
> using only points out where to investigate to change, or not, the
> code. The output is in Emcas org-mode format. So I can tell you that
> the patches are not being robot generated. I'm making the patches, one
> by one, with great help of Coccinelle, but I'm making the code changes
> by hand.
> 
> I can't understand the advantages of describing each patch as you are
> asking. "For me" the generic commit message together with the patch
> makes sense.  Can you please help me on that?

The purpose of the commit message is not only so other developers understand
the patch. It is also so that the consumers (distro's and maintainers)
understand the scope of the impact.  It maybe that your effort uncovers
a really bad security hole that requires a CVE and a re-release of a 
major enterprise product like RHEL, or it could just be a minor corner
case that can never realistically happen. Unless you give a more complete
description, someone else will have to do it for each case.

