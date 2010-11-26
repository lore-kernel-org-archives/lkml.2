Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab0KZPsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:48:19 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:44872 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751734Ab0KZPsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:48:18 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 3WuzNsMVM1k1VQGbETlOHtmILqI1Hn8l30Kljf8nNKXx.Qq
 mMpjzd9sCapTINCFDLY7zZ4d8XzdrkREIrnWeMqBioIUzDFz_K.fNUTQQu68
 g2Yb3Xy7AAmoPSdi66YawOTPNLG7eSG5q00xC3xfjIUUzzdTBa2teRkA23Hu
 RkQQWsp_D9mXOWP17MlMG74dfsktSWPF1ELgP60VZjLeCV8L5Bl_RkZK7IRY
 m5OxNt..Tkrw-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 26 Nov 2010 09:48:14 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Simon Kirby <sim@hostway.ca>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: Free memory never fully used, swapping
In-Reply-To: <20101125101803.F450.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1011260943220.12265@router.home>
References: <20101124092753.GS19571@csn.ul.ie> <20101124191749.GA29511@hostway.ca> <20101125101803.F450.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Nov 2010, KOSAKI Motohiro wrote:
> Please try SLAB instead SLUB (it can be switched by kernel build option).
> SLUB try to use high order allocation implicitly.

SLAB uses orders 0-1. Order is fixed per slab cache and determined based
on object size at slab creation.

SLUB uses orders 0-3. Falls back to smallest order if alloc order cannot
be met by the page allocator.

One can reduce SLUB to SLAB orders by specifying the following kernel
commandline parameter:

slub_max_order=1
