Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642Ab1EFS44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 14:56:56 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:31067 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932557Ab1EFS4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 14:56:55 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: QFd0jPgVM1nUnCE0lDdUXAmHF8UeOmCeMuUK22WDWr9pFGS
 YlplIUqmvfx.mxSVQL4sSULS3eypyi9yCfixpcN1lk61i28lwPWs0CUbW.TS
 nf6tnDL0FHLm9we4gdk63J55iGzxkJu6axUHbCrDznUg_pT7SalKHbMz6sIt
 lW2sv7zdL6tdr1BCtVupc7WmLOcPTUK.HDXTX7KRPbSDYzOtSxt5j__FotTS
 pLYFSpP7vbguUMW8bwR8IhNJelNBc_Vtnha2q2jzJXM.xo2FSp_ZyZ1MOFnF
 qhmBOFqZv1C1.HWe1XnyuFw_5RrHo_blNdHdPKF3vaSrwCHyb
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 6 May 2011 13:56:52 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Maxin John <maxin.john@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: slub_def.h: needs additional check for "index"
In-Reply-To: <BANLkTi=Jdxu7am8-jhJbT0t-uhNmW4zWhw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1105061355020.5832@router.home>
References: <BANLkTi=Jdxu7am8-jhJbT0t-uhNmW4zWhw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 May 2011, Maxin John wrote:

> In slub_def.h file, the kmalloc_index() may return -1 for some special cases.
> If that negative return value gets assigned to "index", it might lead to issues
> later as the variable "index" is used as index to array "kmalloc_caches" in :


The value passed to kmalloc_slab is tested before the result is used.
kmalloc_slab() only returns -1 for values > 4MB.

The size of the object is checked against SLUB_MAX size which is
significantly smaller than 4MB. 8kb by default.

So kmalloc_slab() cannot return -1 if the parameter is checked first.
