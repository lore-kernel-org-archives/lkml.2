Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778Ab0JHSGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 14:06:30 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:32694 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758997Ab0JHSG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 14:06:29 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: .mK4WSoVM1nd3k0vvnG1.hJco126nA_H5QU_BSNHvGGSaZ1
 YUtpQt_lBHY.A6NFZIROMluDrE4GfvhZPJUAIaxvUV5TGTBv6QGGp_Lf.VL2
 6QCAsC48h9gOEGzGyZ9ZAfo.jWHnRdcv7Ot3uS_UE2x2iHzseo2mt1TiNaR3
 XH8gQWCP0Wu7uX3gl2.lUVl5_5V2N8pqE1C_RaMpWsXksOyIaxk12_7tddst
 WvoYwVd9CPTZWZpEeUUV3wv.AxGGWFwMpJY3CntR.3cddY_6dRGraHpwgX7_
 ofw--
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 8 Oct 2010 12:56:03 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Rob Mueller <robm@fastmail.fm>,
        linux-kernel@vger.kernel.org, Bron Gondwana <brong@fastmail.fm>,
        linux-mm <linux-mm@kvack.org>, David Rientjes <rientjes@google.com>
Subject: Re: [resend][PATCH] mm: increase RECLAIM_DISTANCE to 30
In-Reply-To: <20101008165930.GH5327@balbir.in.ibm.com>
Message-ID: <alpine.DEB.2.00.1010081255010.32749@router.home>
References: <20101008104852.803E.A69D9226@jp.fujitsu.com> <20101008090427.GB5327@balbir.in.ibm.com> <alpine.DEB.2.00.1010081044530.30029@router.home> <20101008165930.GH5327@balbir.in.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Oct 2010, Balbir Singh wrote:

> * Christoph Lameter <cl@linux.com> [2010-10-08 10:45:16]:
>
> > On Fri, 8 Oct 2010, Balbir Singh wrote:
> >
> > > I am not sure if this makes sense, since RECLAIM_DISTANCE is supposed
> > > to be a hardware parameter. Could you please help clarify what the
> > > access latency of a node with RECLAIM_DISTANCE 20 to that of a node
> > > with RECLAIM_DISTANCE 30 is? Has the hardware definition of reclaim
> > > distance changed?
> >
> > 10 is the local distance. So 30 should be 3x the latency that a local
> > access takes.
> >
>
> Does this patch then imply that we should do zone_reclaim only for 3x
> nodes and not 2x nodes as we did earlier.

It implies that zone reclaim is going to be automatically enabled if the
maximum latency to the memory farthest away is 3 times or more that of a
local memory access.

