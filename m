Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934575Ab2C3QPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 12:15:11 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:22844 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934521Ab2C3QPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 12:15:04 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: EF32ddIVM1mAgpsDOx7GpQt5yh97mwiTpJMXBRmnLdwbbqS
 Ltssma.1OdIDAHpt2qpHnFW_52iqMnZPHby9F7ezjEUc2KxL5BjXDwFgMSVR
 3CKATi_YpAFr_IDJicE2my4S5uo2H62PapQ5cuCZxFSzVQqz7Cbx.8uKT8D6
 kI89sSMOCmMmtPOS3.kHNu.d.2NTSvnQeTZHc2CH2wmRQN.IiT7RT_MWxIRi
 bhWCRD6cBAI3ZR4Z6Pk7jafrWDNfDYaEEa4fq8vMB9iMR1u2Ca9ufX3PWIj2
 eN7elZ59O33wfox7kSb3S.jkchgyF4TlFhjwPu9zEJemrcpqz8CBuMCEWg3Y
 dTARm7_mvvzfelyVGkFfsF6R4SKDyqbx3TZ_7WoZv6srUuywBgvkEVygc_H2
 V
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 30 Mar 2012 11:15:01 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
cc: lwoodman@redhat.com, linux-mm@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Motohiro Kosaki <mkosaki@redhat.com>
Subject: Re: [PATCH -mm] do_migrate_pages() calls migrate_to_node() even if
 task is already on a correct node
In-Reply-To: <4F74BB67.30703@gmail.com>
Message-ID: <alpine.DEB.2.00.1203301113530.22502@router.home>
References: <4F6B6BFF.1020701@redhat.com> <4F6B7358.60800@gmail.com> <alpine.DEB.2.00.1203221348470.25011@router.home> <4F6B7854.1040203@redhat.com> <alpine.DEB.2.00.1203221421570.25011@router.home> <4F74A344.7070805@redhat.com> <4F74BB67.30703@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2012, KOSAKI Motohiro wrote:

> >
> > 		for_each_node_mask(s, tmp) {
> > +
> > +			/* IFF there is an equal number of source and
> > +			 * destination nodes, maintain relative node distance
> > +			 * even when source and destination nodes overlap.
> > +			 * However, when the node weight is unequal, never
> > move
> > +			 * memory out of any destination nodes */
> > +			if ((nodes_weight(*from_nodes) !=
> > nodes_weight(*to_nodes)) &&
> > +						(node_isset(s, *to_nodes)))
> > +				continue;
> > +
> > 			d = node_remap(s, *from_nodes, *to_nodes);
> > 			if (s == d)
> > 				continue;
>
> I'm confused. Could you please explain why you choose nodes_weight()? On my
> first impression,
> it seems almostly unrelated factor.

Isnt this the original code by Paul? I would think that the 1-1 movement
is only useful to do if the number of nodes in both the destination and
the source is the same.
