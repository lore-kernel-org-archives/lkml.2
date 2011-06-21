Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab1FUNDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 09:03:22 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:54042 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756663Ab1FUNDT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 09:03:19 -0400
Date: Tue, 21 Jun 2011 09:03:18 -0400 (EDT)
From: Dave Anderson <anderson@redhat.com>
To: Cong Wang <amwang@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <876358254.119683.1308661398718.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <4E000776.7000504@redhat.com>
Subject: Re: [PATCH 00/10] Enhance /dev/mem to allow read/write of arbitrary
 physical addresses
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.5.5.71]
X-Mailer: Zimbra 6.0.9_GA_2686 (ZimbraWebClient - FF3.0 (Linux)/6.0.9_GA_2686)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> 于 2011年06月20日 21:24, Dave Anderson 写道:
> >> On Mon, Jun 20, 2011 at 10:42:47, Amerigo Wang<amwang@redhat.com>
> >
> > I don't know what you mean by I "didn't consider it", because
> > the crash utility does support using /proc/kcore as an alternative
> > live memory source.
> 
> Sorry, I recall that in our last discussion you didn't
> mention this. But it is good to know that crash supports this!
> 
> >
> > The problem is that /proc/kcore can only access highmem if it
> > is mapped as kernel virtual address. So it cannot read 32-bit
> > highmem PTE's, user-space memory, etc.
> >
> 
> Hmm, looking at the code, you are right, it only has
> low memory in kernel space.
> 
> But what's the problem of adding highmem into kcore? :-/
> 
> Thanks.

/proc/kcore was presumably designed for use by gdb with a vmlinux
namelist, and like user-space core dumps, the PT_LOAD segments 
reference virtual address regions with p_vaddr/p_paddr pairs.

Dave
