Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab1HZOIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 10:08:22 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:47467 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755153Ab1HZOIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 10:08:21 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: FM7yspcVM1nV68oyk3MamEg2qDVMyn_qJWeZ65SePZ6tthp
 TCXAHLgZ0j0riL8p7NB8uBLmyFiRr0WkKIKHDJGpgB7UGJbFC1V.eoxtKdl7
 vsstDyEouZ4QNnBLNT1K_N4Q1pEoMq8gMNtSbyIrwVDdHKBw0VbGR3Koppvb
 dGVQqRpBEJ2CS9F_Ilt676oU0aWjUrb6mF9XhCyDOL2GTlin.ATKC4lb2T7U
 sb7ZpPh6qreJgsnGH_5QrkwJVtvTRqdw6LDw2tXRJjiHJTh0mrHa7LxNj6Se
 uF4JQDva2ogb.SPS4_UYkSKuCMJ2JzdGFVwfh0QZXHyTl0062LRBRiT0KzQU
 gfd8iWE1uUG8yxtM_.S2YYPh7ikSEIWb.iu9l3RQZlLINqQ--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 26 Aug 2011 09:08:17 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Zhao Jin <cronozhj@gmail.com>
cc: penberg@kernel.org, mpm@selenic.com, trivial@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: avoid unnecessary touching of a partial slab
In-Reply-To: <CADqbE97Vj0UV-2XvpkoELwdey_Xw7iCsF1AhQNFjwxY583SUwg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1108260841570.5818@router.home>
References: <CADqbE97Vj0UV-2XvpkoELwdey_Xw7iCsF1AhQNFjwxY583SUwg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Aug 2011, Zhao Jin wrote:

> In cache_alloc_refill(), after refilling from a partial slab, if the
> slab remains partial, it would be deleted from and then added again to
> the partial list. As the slab is the first element in the list before
> deletion, such behavior has no effect. This patch avoids touching the
> slab in this case.

The list_del/list_add action is a list_move.
