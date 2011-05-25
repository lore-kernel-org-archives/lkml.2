Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497Ab1EYQ35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 12:29:57 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:47320 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757240Ab1EYQ34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 12:29:56 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: InV_5BgVM1nXjZuv0OCcMgfAe1jyMn9TEU0AYP3HbRqDBO4
 EaLnwZhIYeadMJYmdLFaqdGWMkK4CoUBQRUf1jTMsSmXPFzAxqY7OQIIkrfK
 1annczwQjoOPqIRFxoqXg7Ssvs9cfmQSrhGAhh7_s3s.WIVEFBOwm2NIXi4m
 rGMEFKJvCFQ6wxcaMeGKKlRfISZWgjFvELxldcLXhRBWIurNsdwoVSs78x9u
 qFyc_N5q2PK.RCplPcRvu5USReKQSIotx2bZWqwJbIAV5FGOkoc91u64f1YA
 HqnnfN2PtEIsjJq21zIc17sBDoD2yymO5r2BlIR4QBH5WVAzdCZuddie1WyS
 dZc4wCWEpv_VF6Y3_uVOZG8E-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 25 May 2011 11:29:53 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: James Morris <jmorris@namei.org>, Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: SLUB regression in current Linus
In-Reply-To: <1306338149.2820.27.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1105251129300.26118@router.home>
References: <alpine.LRH.2.00.1105242146240.12134@tundra.namei.org>  <alpine.LRH.2.00.1105242204100.12283@tundra.namei.org>  <alpine.DEB.2.00.1105240908100.25760@router.home>  <alpine.LRH.2.00.1105250813290.16922@tundra.namei.org>  <alpine.DEB.2.00.1105250945240.23309@router.home>
 <1306338149.2820.27.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Eric Dumazet wrote:

> > Index: linux-2.6/mm/slub.c
> > ===================================================================
> > --- linux-2.6.orig/mm/slub.c	2011-05-25 09:41:27.000000000 -0500
> > +++ linux-2.6/mm/slub.c	2011-05-25 09:41:39.000000000 -0500
> > @@ -1884,7 +1884,8 @@ debug:
> >  	deactivate_slab(s, c);
> >  	c->page = NULL;
>
> is this c->page = NULL; really necessary ?

No. deactivate_slab() already sets it to NULL.

