Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760530Ab2CTPPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 11:15:10 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:21426 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760165Ab2CTPPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 11:15:08 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: gENDUIUVM1lYBJIGiNOOLjsWLC8tLvhAhlFbDJATJobLsYT
 bHKcSKapJoMUlv5ZckDTurRLUZO3V22ZdlhiFXeuDDacgyuBRn.qYqH5rxFb
 tnNipdVlAQFp8aUDy02LTe5cF1xb_jdxZkj4i30EYRY_BhfYqMxBMISQTyMP
 f_RBapp672.J3XOgqn0gcvSYFvsFHHPClTUw.KYyQTgINVSCjGEczs0d2cHW
 _C2g6dXPKaTeBtErhvPEgHk7cFT2gVxf2r9foMfgyU3t9a.DbUFOIMzEbi1h
 CdLQpki6dgTuHAO_lJWXGvJOC7G9aJaRQGU1GLy7NbX4tDvGZYM7dm1xMLlV
 MQEBk9AotoIApr6QxzXscM0_BzT6ok9vI.W24Pu2XqkCiLAr5HCXFwyONCFV
 ct3PwT3QsDDBkKLs9aRzoOxkMLvPFNglIifVZ
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 20 Mar 2012 10:15:05 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 6/6] workqueue: use kmalloc_align() instead of
 hacking
In-Reply-To: <1332238884-6237-7-git-send-email-laijs@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1203201014030.19333@router.home>
References: <1332238884-6237-1-git-send-email-laijs@cn.fujitsu.com> <1332238884-6237-7-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2012, Lai Jiangshan wrote:

> kmalloc_align() makes the code simpler.

Another approach would be to simply create a new slab cache using
kmem_cache_create() with the desired alignment and allocate from
that.

