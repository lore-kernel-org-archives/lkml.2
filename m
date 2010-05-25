Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab0EYMbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 08:31:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756297Ab0EYMbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 08:31:53 -0400
Date: Tue, 25 May 2010 14:30:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier@gentoo.org>, linux-sh@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/1] ptrace: PTRACE_GETFDPIC: fix the unsafe usage
	of child->mm
Message-ID: <20100525123027.GA29883@redhat.com>
References: <20100522165401.GB19573@redhat.com> <1266280229-18469-1-git-send-email-vapier@gentoo.org> <1274431345-22366-1-git-send-email-vapier@gentoo.org> <20100521162659.GA16193@redhat.com> <20100521183512.4477F40476@magilla.sf.frob.com> <20100522165320.GA19573@redhat.com> <25539.1274711817@redhat.com> <20100524151445.GA6393@redhat.com> <17134.1274778852@redhat.com> <20147.1274790240@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20147.1274790240@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > > Like PEEKTEXT and POKETEXT?
> >
> > They use access_process_vm().
>
> Which needs to get the mm:
>
> 	int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, int len, int write)
> 	{
> 		struct vm_area_struct *vma;
> 		struct mm_struct *mm;
>
> 		if (addr + len < addr)
> 			return 0;
>
> 		mm = get_task_mm(tsk);

Yes sure,

But I do not think it makes any sense to change the signature of
access_process_vm() as well, it has a lot of callers. And it is
complex, it does get_user_pages(). Compared to that get_task_mm()
inside of access_process_vm() is nothing.

Oleg.

