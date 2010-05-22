Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab0EVOyo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 10:54:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187Ab0EVOym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 10:54:42 -0400
Date: Sat, 22 May 2010 18:53:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-sh@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: [PATCH -mm 0/1] (Was: ptrace: unify FDPIC implementations)
Message-ID: <20100522165320.GA19573@redhat.com>
References: <1266280229-18469-1-git-send-email-vapier@gentoo.org> <1274431345-22366-1-git-send-email-vapier@gentoo.org> <20100521162659.GA16193@redhat.com> <20100521183512.4477F40476@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100521183512.4477F40476@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21, Roland McGrath wrote:
>
> > This looks unsafe. What protect child->mm if ptrace() races with SIGKILL ?
> >
> > Of course, I do not blame this patch, the code was copied from arch/, but
> > I think we need another patch which checks ->mm != NULL under task_lock()
> > on top of this one?
>
> Agreed, unless things are somehow different on nommu so there aren't such
> races.

I don't this !CONFG_MMU can make any difference, nothing can protect us
from exit_mm() afaics.

> But, as you mention, this is a long-standing issue that is entirely
> unrelated to the cleanup here and should not delay merging this patch.

Yes, yes, agreed.

Please see the patch on top of ptrace-unify-fdpic-implementations.patch
Untested, but hopefully trivial enough.

Oleg.

