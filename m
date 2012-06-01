Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965156Ab2FAP5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:57:20 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:43843 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965093Ab2FAP5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:57:18 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: D76MKlkVM1ky4o3fPwV1vTCBUMpHsxEm51BgWF9ZdzujtfN
 bsXQrmeHJOwSMBJXByEU748YeMlV8b_FgmLDhqkFgDdmd_K97CTG94qKzG25
 YaPnRwL3K5mOteGBQj9RBROphAe.P2Dc24T4SZ3kRnPuptxKq1RlHdETy2Ku
 aCr7aHgckq3O1LyCBDPiOUftqw_enAhOqsOnCh0pKEWe0GIYOI9wEbHqkfn6
 wbnd5952k7rA22e5PLd5AivCHACGjPI44LylRwGAwtUz6AES8rDpkNLuQ77Y
 iWlmEEzWHjCVXcjvQd.t8kReqc1SvwPjs2XZCudrE5bQyZrmBbg.5aNaOoJj
 7kvixj1Xi5TylGDxO5msJ7uWwpVc4cmsX2KFfN57B5v3M_8l8oLxYOU.mw6v
 E
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 1 Jun 2012 10:57:14 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Joonsoo Kim <js1304@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 4/4] slub: refactoring unfreeze_partials()
In-Reply-To: <1337269668-4619-5-git-send-email-js1304@gmail.com>
Message-ID: <alpine.DEB.2.00.1206011055230.8851@router.home>
References: <1337269668-4619-1-git-send-email-js1304@gmail.com> <1337269668-4619-5-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2012, Joonsoo Kim wrote:

> Minimizing code in do {} while loop introduce a reduced fail rate
> of cmpxchg_double_slab. Below is output of 'slabinfo -r kmalloc-256'
> when './perf stat -r 33 hackbench 50 process 4000 > /dev/null' is done.

Ok. This works because the pages are frozen and the node lock has been
taken so the only concurrency to worry about is freeing of objects via
slab_free(). The cmpxchg is safe for that.

Acked-by: Christoph Lameter <cl@linux.com>

