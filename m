Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309Ab0IUOOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 10:14:19 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:45553 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753521Ab0IUOOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 10:14:16 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: FfQNcV0VM1lrhVD6UZ.Yqthmz.Et1vaH1nvCdO.1tdL.LYr
 cLmPlre8Ci8EPD_.z4FF7.yDq1o.eSpb7v7K.JwbDbbWJQSiJ3SCnC_BvFgh
 Vo.F.N2sRL9LOy5lG84jyMGdiImN8Dsch4yQ5bpXTCbCvAPklw3w430oDr5H
 h0vDkiQZd_PACWOB6wmVtxeHJFbJvx22.pJAyfnnVbZi2A8aL1eiPfuOmM7n
 3chpZ70xCdNf6iYSHHGQF.crjRn1g
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 21 Sep 2010 09:14:13 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: Rob Mueller <robm@fastmail.fm>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Bron Gondwana <brong@fastmail.fm>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: Default zone_reclaim_mode = 1 on NUMA kernel is bad forfile/email/web
 servers
In-Reply-To: <20100921090407.GA11439@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1009210911270.1271@router.home>
References: <1284349152.15254.1394658481@webmail.messagingengine.com> <20100916184240.3BC9.A69D9226@jp.fujitsu.com> <20100920093440.GD1998@csn.ul.ie> <52C8765522A740A4A5C027E8FDFFDFE3@jem> <20100921090407.GA11439@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Sep 2010, Mel Gorman wrote:

> > However there's still another question, why is this problem happening at
> > all for us? I know almost nothing about NUMA, but from other posts, it
> > sounds like the problem is the memory allocations are all happening on
> > one node?
>
> Yes.

This could be a screwy hardware issue as pointed out before. Certain
controllers restrict the memory that I/O can be done to also (32 bit
controller only able to do I/O to lower 2G?, controller on a PCI bus that
is local only to a particular node) which would make balancing
the file cache difficult.
