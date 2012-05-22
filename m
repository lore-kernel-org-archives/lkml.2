Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab2EVRSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 13:18:34 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:48118 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755444Ab2EVRSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 13:18:32 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: UdXpC5cVM1nBOkCKXdz885rs6kXGzFnGXNR3ONbghbpbSg7
 VOVsRP1xjOtFnQYjfArCurMgA97Hgtk7jR24kmSGnbplJ.LwLzstX_n4CbHh
 Izg4CIRNBuRKVdxMR8Nv28H1.oXWDrslW_bRqWLzDKXYNMRGZzCw5AyFdgec
 AVDYxI6F1ZdZn_vA5e7JCJGJPAIc4.mVlC0lQzU1_HmVLs0mITwBIo77AJ4W
 0ei72NDlphBmdH.stwTyiRe8OgqDu02Yw1NVwVPN48DCGKrwUBM2_hdWKHFz
 PfCc7tPvRySNOT.paqaQX4FMS8uY9pxF3V3Uec_tmbtOcLSDcwrU3xMoY3T0
 hhawRWnnIBRPU2Zsu_gYarf5GvRTYMVF57mTyEHECIGrEzOynHTxP5msrYZw
 H
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 22 May 2012 12:18:29 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2] slab+slob: dup name string
In-Reply-To: <4FBBB059.1060903@parallels.com>
Message-ID: <alpine.DEB.2.00.1205221216590.17721@router.home>
References: <1337680298-11929-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205220857380.17600@router.home> <4FBBB059.1060903@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Glauber Costa wrote:

> On 05/22/2012 05:58 PM, Christoph Lameter wrote:
> > On Tue, 22 May 2012, Glauber Costa wrote:
> >
> > > [ v2: Also dup string for early caches, requested by David Rientjes ]
> >
> > kstrdups that early could cause additional issues. Its better to leave
> > things as they were.
> >
>
> For me is really all the same. But note that before those kstrdups, we do a
> bunch of kmallocs as well already. (ex:

We check carefully and make sure those caches are present before doing
these kmallocs. See the slab bootup code. A kstrdup may take a variously
sized string and explode because the required kmalloc cache is not
present.

