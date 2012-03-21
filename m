Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030196Ab2CUNpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 09:45:43 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:22574 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932214Ab2CUNpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 09:45:41 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: tc9tLxAVM1m5lrFUBQwgfCh458NLZ5iR2nkhMon05b282OM
 UdmoGpCu0Z3BZ32egUcNJym8v10Fg.qy58IOB4FWCWusfw_6wH5_69ySC5Vb
 qTAuyFKQGwxVcY3MFxfImZftMeJutwwJEhGICN9NPaqA.ZLsYl.AcQ6PoJO1
 IiPwH6qE57lLVVhlrEXUfftcx9_l.l9w3jUQbGAhFso7M6Af6AFZ7HaCR5Wn
 xyC05Ok64MRRBGIdp0g1cO7OtH6FFnLOvl6pu.bbx5cEtpIdn1O._exTm2LV
 IeWe5ON9lKuozN0y9nGtVTRUpDi7UUqB4Ojgv.eGuLHtMG7brlZ2yUoiUkhJ
 c0nK8XvByrixNZ40XkSC.Qa.IoFfylD5iOACAUDAb2M9TTrjCKIxrrPJEmXY
 GI_BEJdRr77QRaf0oPVFSr5LT_LGRDl5CbZ7Ds2U8jy.ORls-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 21 Mar 2012 08:45:38 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 6/6] workqueue: use kmalloc_align() instead of
 hacking
In-Reply-To: <4F6944D9.5090002@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1203210842200.20382@router.home>
References: <1332238884-6237-1-git-send-email-laijs@cn.fujitsu.com> <1332238884-6237-7-git-send-email-laijs@cn.fujitsu.com> <20120320154619.GA5684@google.com> <4F6944D9.5090002@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2012, Lai Jiangshan wrote:

> Yes, I don't want to build a complex kmalloc_align(). But after I found
> that SLAB/SLUB's kmalloc-objects are natural/automatic aligned to
> a proper big power of two. I will do nothing if I introduce kmalloc_align()
> except just care the debugging.

They are not guaranteed to be aligned to the big power of two! There are
kmalloc caches that are not power of two. Debugging and other
necessary meta data may change alignment in both SLAB and SLUB. SLAB needs
a metadata structure in each page even without debugging that may cause
alignment issues.

> And kmalloc_align() can be used in the following case:
> o	a type object need to be aligned with cache-line for it contains a frequent
> 	update-part and a frequent read-part.
> o	The total number of these objects in a given type is not much, creating
> 	a new slab cache for a given type will be overkill.
>
> This is a RFC patch and it seems mm gurus don't like it. I'm sorry I
> bother all of you.

Ideas are always welcome. Please do not get offended by our problems with
your patch.


