Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab1HZOvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 10:51:05 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:33370 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751368Ab1HZOvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 10:51:01 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: CxVEykgVM1mn.JzVGdRHin52bvW9UlfLs.fXcJh6erRga9X
 3sTGIOJqbTNGsKb50FNkNqvwgPF4FAl4uY_TIZTNgF8QK5Pig8vbC1RlI82u
 aP46GwZgpgNWWfjta316jc2snXolTS4JDMnOP8DTeraz8KfF0KjI221F9Ff_
 rT4BQVuyM9uUX00hNDCyolcZdY4VCBIuz6BHBCDlfd5Guv9_WxNA3LhhzT3J
 RkTcAikCbhQIEydyI_W3.XrZeIy1ALxnZWPXGa0pFWjvCxxYWhBL0KK9Jzzo
 ITRArUBeFMZdwLZbHrsMH1.HmrPogPq2pgWpq_4CUEPJlQNWdloqEnchQ1ez
 jEVMkUMxreTDq6c9dEYbvtuOs4VCid0KgabyBGBMHEdwQEw--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 26 Aug 2011 09:50:58 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Zhao Jin <cronozhj@gmail.com>
cc: penberg@kernel.org, mpm@selenic.com, trivial@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: avoid unnecessary touching of a partial slab
In-Reply-To: <1314370016.8991.38.camel@vm>
Message-ID: <alpine.DEB.2.00.1108260950220.5818@router.home>
References: <CADqbE97Vj0UV-2XvpkoELwdey_Xw7iCsF1AhQNFjwxY583SUwg@mail.gmail.com>  <alpine.DEB.2.00.1108260841570.5818@router.home> <1314370016.8991.38.camel@vm>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Aug 2011, Zhao Jin wrote:

> On Fri, 2011-08-26 at 09:08 -0500, Christoph Lameter wrote:
> > On Fri, 26 Aug 2011, Zhao Jin wrote:
> >
> > > In cache_alloc_refill(), after refilling from a partial slab, if the
> > > slab remains partial, it would be deleted from and then added again to
> > > the partial list. As the slab is the first element in the list before
> > > deletion, such behavior has no effect. This patch avoids touching the
> > > slab in this case.
> >
> > The list_del/list_add action is a list_move.
>
> But in cache_alloc_refill(), it is the first slab (that is: its list
> field is pointed by the l3->slabs_partial.next) that is picked from the
> partial list for refilling. Assume it remains partial after that. Since
> list_add inserts a new element after the head (l3->slabs_partial), the
> position of the slab in the partial list won't change after
> list_del/list_add: it will be still the first element. Therefore,
> list_del/list_add has done nothing actually in this case.

Correct but still tthe del/add is a list_move operation. Convert that the
other case as well?

