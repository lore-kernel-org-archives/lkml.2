Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab1JMOPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 10:15:45 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:30845 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754515Ab1JMOPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 10:15:44 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: pkM7kFoVM1kBymXyADihW9_fJe1H2yVyZ089g9vLDJNQq9Z
 H9RXPCRgHuXlloVGANgGrk_mhPnNgHF9C2xccu_9FU2x986Cm5Wr8ygwtcQC
 LdnSGshQ9jWxe39ZDDppKkj4hXzXbfi_UEQioDX1JhkiGHdRsAS9nJgCFeJM
 gX4FDduzVAgesta5cwGKq4oSejb0J78.Zmpi0R5zHgSu0eD6a72aSeLimUIn
 0Qsg9OuK4NQLPzBOl1bun9QO_q1720AEjTTujs9hJ7toLt1C9i0kjX0sZwSq
 B5Gfux8NxzrXrOJsIlgcCYoySU3TDhMO9ENdqmYQxoANE8vU8_iL_pYhkYZE
 C7pDmUDAYS.6S6e9rq66tpX.beQT5e1rrkhy9_Lc97DVeIt.zwLGL9q2HI8h
 XidwXSw3EpaC6cXUZ0.J3Yjgkr9YtFWNRF3XfxNZgQcE6N6WanvmtyK3NUA-
 -
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 13 Oct 2011 09:15:39 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Tim Chen <tim.c.chen@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Dimitri Sivanich <sivanich@sgi.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ak@linux.intel.com
Subject: Re: [PATCH] Reduce vm_stat cacheline contention in
 __vm_enough_memory
In-Reply-To: <1318464437.6469.16.camel@schen9-DESK>
Message-ID: <alpine.DEB.2.00.1110130914480.16230@router.home>
References: <20111012160202.GA18666@sgi.com>  <20111012120118.e948f40a.akpm@linux-foundation.org>  <CADE8fzrdMOBF1RyyEpMVi8aKcgOVKRQSKi0=c1Qvh3p6hHcXRA@mail.gmail.com> <1318464437.6469.16.camel@schen9-DESK>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Oct 2011, Tim Chen wrote:

> Yeah, we have had this discussion on vm_enough_memory before.
>
> https://lkml.org/lkml/2011/1/26/473
>
> The current version of per cpu counter was not really suitable because
> the batch size is not appropriate.  I've tried to use per cpu counter
> with batch size adjusted in my attempt.  Andrew has suggested having an
> elastic batch size that's proportional to the size of the central
> counter but I haven't gotten around to try that out.

These counter are already managed as a ZVC counter. It may be easiest to
adjust the batching parameters for those to solve this issue.
