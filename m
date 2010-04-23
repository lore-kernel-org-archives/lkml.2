Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489Ab0DWRuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 13:50:17 -0400
Received: from relais.videotron.ca ([24.201.245.36]:31263 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081Ab0DWRuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 13:50:14 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Fri, 23 Apr 2010 13:50:10 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Paulius Zaleckas <paulius.zaleckas@gmail.com>, dwmw2@infradead.org,
       jamie@shareable.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, u.kleine-koenig@pengutronix.de,
       simon.kagstrom@netinsight.net, akpm@linux-foundation.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] MTD: Fix Orion NAND driver compilation with ARM OABI
In-reply-to: <1272035596.11751.1437.camel@localhost.localdomain>
Message-id: <alpine.LFD.2.00.1004231308300.7232@xanadu.home>
References: <20100325152505.17612.40158.stgit@pauliusz>
 <alpine.LFD.2.00.1003251225500.694@xanadu.home> <4BB33988.9070608@gmail.com>
 <1272023778.6917.6.camel@localhost>
 <alpine.LFD.2.00.1004230853230.7232@xanadu.home>
 <1272035596.11751.1437.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Content-id: <alpine.LFD.2.00.1004231344241.7232@xanadu.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010, Artem Bityutskiy wrote:

> On Fri, 2010-04-23 at 08:54 -0400, Nicolas Pitre wrote:
> > On Fri, 23 Apr 2010, Artem Bityutskiy wrote:
> > 
> > > On Wed, 2010-03-31 at 15:01 +0300, Paulius Zaleckas wrote:
> > > > On 03/25/2010 06:26 PM, Nicolas Pitre wrote:
> > > > > On Thu, 25 Mar 2010, Paulius Zaleckas wrote:
> > > > >
> > > > >> We must tell GCC to use even register for variable passed
> > > > >> to ldrd instruction. Without this patch GCC 4.2.1 puts this
> > > > >> variable to r2/r3 on EABI and r3/r4 on OABI, so force it to
> > > > >> r2/r3. This does not change anything when EABI and OABI
> > > > >> compilation works OK.
> > > > >>
> > > > >> Without this patch and with OABI I get:
> > > > >>    CC      drivers/mtd/nand/orion_nand.o
> > > > >> /tmp/ccMkwOCs.s: Assembler messages:
> > > > >> /tmp/ccMkwOCs.s:63: Error: first destination register must be even -- `ldrd r3,[ip]'
> > > > >> make[5]: *** [drivers/mtd/nand/orion_nand.o] Error 1
> > > > >>
> > > > >> Signed-off-by: Paulius Zaleckas<paulius.zaleckas@gmail.com>
> > > > >
> > > > > Acked-by: Nicolas Pitre<nico@fluxnic.net>
> > > > 
> > > > David,
> > > > 
> > > > Will you take this patch?
> > > > Or you are waiting till I will add all Cc as Jamie suggested?
> > > 
> > > Meanwhile, I've pushed your patch to my l2-mtd-2.6.git / dunno.
> > 
> > I think it should go to mainline.  It is not perfect, but still better 
> > than the current situation.
> 
> Fine with me, but not up to me. But I guess Andrew could merge it.

The patch is providing a fix to my own code, and I acked it already. The 
root of the problem is a defficiency in gcc, and dwmw2 asked that a PR 
be filled for that and a reference to it added to the patch.  This has 
been done.


Nicolas
