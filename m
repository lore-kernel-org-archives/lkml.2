Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759601Ab0E0T5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 15:57:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755488Ab0E0T5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 15:57:15 -0400
Date: Thu, 27 May 2010 21:55:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Mike Frysinger <vapier.adi@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Roland McGrath <roland@redhat.com>,
       linux-sh@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] blackfin: ptrace mm/sram_list fixes
Message-ID: <20100527195544.GA25935@redhat.com>
References: <1274431345-22366-1-git-send-email-vapier@gentoo.org> <20100521162659.GA16193@redhat.com> <20100521183512.4477F40476@magilla.sf.frob.com> <20100522165320.GA19573@redhat.com> <25539.1274711817@redhat.com> <20100524151445.GA6393@redhat.com> <17134.1274778852@redhat.com> <20100525102345.GA23574@redhat.com> <AANLkTilT3D8c86LYK2DxcNpM2F3D8iCbgY_sfUg8h58p@mail.gmail.com> <20100526124006.GA28358@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100526124006.GA28358@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26, Oleg Nesterov wrote:
>
> On 05/25, Mike Frysinger wrote:
> >
> > we probably should add proper locking to this
> > structure though.
>
> Agreed. I'll try to make the trivial patch tomorrow. I think we
> can just use mm->mmap_sem, is_user_addr_valid() needs this lock
> for find_vma() anyway.

please see the patches.

UNTESTED! the second one certainly needs the review from someone
who knows what this code does ;)

BTW. Obviously sys_sram_alloc() can create multiple sram_list_struct
nodes with the same ->addr (with or without this patch), I hope this
is fine.

Oleg.

