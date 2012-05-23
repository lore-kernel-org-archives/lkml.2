Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab2EWNxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 09:53:33 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:40357 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752642Ab2EWNxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 09:53:32 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: GXyqLFIVM1kUXGDK4BEukqxTzMJhjPZtMcpqkQ8GzOGm15r
 O2Y62X1JOdDhpPzlJp3VQHFf0kVGPYtQV0PIVw3LOgGPhRGCzgG3GPqZLyQJ
 2TZwihwos5OrKa_UYKmptgNVev286JpS8Z51EZ784xMp8BPqYWmBFZbO800h
 iuIrESG81yAWim3K_xf8PLaS2q.9Z_A8cKFd8qup_Q2y8yYwqw4t8L4EKmPS
 CeOQ2sZz8R7TBbr.3411GzngHlAoiEgjt8EilWGCY1JKq10QZ9YSp_HK3dsF
 fi9TAn55kNTEXMy5xtOQJtwwpSrsHuUWWCYguISQzsDg8DNM6ZOiyx_d5aek
 73vPRztBD.o9h42nErGQu.wxifTCxerQ2d4qTtdeNZINPBrpl8VsIoB01vc_
 X
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 23 May 2012 08:53:29 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2] slab+slob: dup name string
In-Reply-To: <alpine.DEB.2.00.1205222048380.28165@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1205230849410.29893@router.home>
References: <1337680298-11929-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205220857380.17600@router.home> <alpine.DEB.2.00.1205222048380.28165@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, David Rientjes wrote:

> On Tue, 22 May 2012, Christoph Lameter wrote:
>
> > > [ v2: Also dup string for early caches, requested by David Rientjes ]
> >
> > kstrdups that early could cause additional issues. Its better to leave
> > things as they were.
> >
>
> No, it's not, there's no reason to prevent caches created before
> g_cpucache_up <= EARLY to be destroyed because it makes a patch easier to
> implement and then leave that little gotcha as an undocumented treasure
> for someone to find when they try it later on.

g_cpucache_up <= EARLY is slab bootstrap code and the system is in a
pretty fragile state. Plus the the kmalloc logic *depends* on these
caches being present. Removing those is not a good idea. The other caches
that are created at that point are needed to create more caches.

There is no reason to remove these caches.

> This is much easier to do, just statically allocate the const char *'s
> needed for the boot caches and then set their ->name's manually in
> kmem_cache_init() and then avoid the kfree() in kmem_cache_destroy() if
> the name is between &boot_cache_name[0] and &boot_cache_name[n].

Yeah that is already occurring for some of the boot caches.

