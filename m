Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab0EYMZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 08:25:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755365Ab0EYMY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 08:24:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100525102345.GA23574@redhat.com>
References: <20100525102345.GA23574@redhat.com> <20100524234250.F158849A56@magilla.sf.frob.com> <20100522165401.GB19573@redhat.com> <1266280229-18469-1-git-send-email-vapier@gentoo.org> <1274431345-22366-1-git-send-email-vapier@gentoo.org> <20100521162659.GA16193@redhat.com> <20100521183512.4477F40476@magilla.sf.frob.com> <20100522165320.GA19573@redhat.com> <25539.1274711817@redhat.com> <20100524151445.GA6393@redhat.com> <17134.1274778852@redhat.com> 
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier@gentoo.org>, linux-sh@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/1] ptrace: PTRACE_GETFDPIC: fix the unsafe usage of child->mm
Date: Tue, 25 May 2010 13:24:00 +0100
Message-ID: <20147.1274790240@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> > Like PEEKTEXT and POKETEXT?
> 
> They use access_process_vm().

Which needs to get the mm:

	int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, int len, int write)
	{
		struct vm_area_struct *vma;
		struct mm_struct *mm;

		if (addr + len < addr)
			return 0;

		mm = get_task_mm(tsk);
		if (!mm)
			return 0;

David
