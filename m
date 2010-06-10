Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802Ab0FJLV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:21:57 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50161 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753680Ab0FJLVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:21:55 -0400
Subject: Re: [PATCH -mm] only drop root anon_vma if not self
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
In-Reply-To: <AANLkTin9UTy3qSWJ8u3b1hwhnsX5NHCZNzkFbH9_-vIZ@mail.gmail.com>
References: <AANLkTin1OS3LohKBvWyS81BoAk15Y-riCiEdcevSA7ye@mail.gmail.com>
	 <1275929000.3021.56.camel@e102109-lin.cambridge.arm.com>
	 <AANLkTilsCkBiGtfEKkNXYclsRKhfuq4yI_1mrxMa8yJG@mail.gmail.com>
	 <AANLkTik-cwrabXH_bQRPFtTo3C9r30B83jMf4IwJKCms@mail.gmail.com>
	 <20100609211617.3e7e41bd@annuminas.surriel.com>
	 <AANLkTin9UTy3qSWJ8u3b1hwhnsX5NHCZNzkFbH9_-vIZ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Thu, 10 Jun 2010 12:21:06 +0100
Message-ID: <1276168866.24535.25.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jun 2010 11:21:06.0584 (UTC) FILETIME=[04E7D980:01CB088F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

On Thu, 2010-06-10 at 02:30 +0100, Dave Young wrote:
> On Thu, Jun 10, 2010 at 9:16 AM, Rik van Riel <riel@redhat.com> wrote:
> > On Wed, 9 Jun 2010 17:19:02 +0800
> > Dave Young <hidave.darkstar@gmail.com> wrote:
> >
> >> > Manually bisected mm patches, the memleak caused by following patch:
> >> >
> >> > mm-extend-ksm-refcounts-to-the-anon_vma-root.patch
> >>
> >>
> >> So I guess the refcount break, either drop-without-get or over-drop
> >
> > I'm guessing I did not run the kernel with enough debug options enabled
> > when I tested my patches...
> >
> > Dave & Catalin, thank you for tracking this down.
> >
> > Dave, does the below patch fix your issue?
> 
> Yes, it fixed the issue. Thanks.

Thanks for investigating this issue.

BTW, without my kmemleak nobootmem patch (and CONFIG_NOBOOTMEM enabled),
do you get other leaks (false positives). If my patch fixes the
nobootmem problem, can I add a Tested-by: Dave Young?

Thanks.

-- 
Catalin

