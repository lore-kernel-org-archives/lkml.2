Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab1LLVKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 16:10:06 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:65147 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753529Ab1LLVKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 16:10:02 -0500
Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Scott Wood <scottwood@freescale.com>
Cc: shuo.liu@freescale.com, dwmw2@infradead.org, Artem.Bityutskiy@nokia.com,
        linux-mtd@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        leoli@freescale.com
Date: Mon, 12 Dec 2011 23:09:51 +0200
In-Reply-To: <4EDEAEB9.6020703@freescale.com>
References: <1322973098-2528-1-git-send-email-shuo.liu@freescale.com>
	 <1322973098-2528-3-git-send-email-shuo.liu@freescale.com>
	 <4EDEAEB9.6020703@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1323724195.2297.11.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-06 at 18:09 -0600, Scott Wood wrote:
> On 12/03/2011 10:31 PM, shuo.liu@freescale.com wrote:
> > From: Liu Shuo <shuo.liu@freescale.com>
> > 
> > Freescale FCM controller has a 2K size limitation of buffer RAM. In order
> > to support the Nand flash chip whose page size is larger than 2K bytes,
> > we read/write 2k data repeatedly by issuing FIR_OP_RB/FIR_OP_WB and save
> > them to a large buffer.
> > 
> > Signed-off-by: Liu Shuo <shuo.liu@freescale.com>
> > ---
> > v3:
> >     -remove page_size of struct fsl_elbc_mtd.
> >     -do a oob write by NAND_CMD_RNDIN. 
> > 
> >  drivers/mtd/nand/fsl_elbc_nand.c |  243 ++++++++++++++++++++++++++++++++++----
> >  1 files changed, 218 insertions(+), 25 deletions(-)
> 
> What is the plan for bad block marker migration?

Why it should be migrated? I thought that you support 2KiB pages, and
this adds 4 and 8 KiB pages support, which you never supported before.
What is the migration you guys are talking about?

Artem.

