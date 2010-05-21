Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934273Ab0EUSfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 14:35:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934101Ab0EUSff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 14:35:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Mike Frysinger <vapier@gentoo.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2] ptrace: unify FDPIC implementations
In-Reply-To: Oleg Nesterov's message of  Friday, 21 May 2010 18:26:59 +0200 <20100521162659.GA16193@redhat.com>
References: <1266280229-18469-1-git-send-email-vapier@gentoo.org>
	<1274431345-22366-1-git-send-email-vapier@gentoo.org>
	<20100521162659.GA16193@redhat.com>
X-Windows: the cutting edge of obsolescence.
Message-Id: <20100521183512.4477F40476@magilla.sf.frob.com>
Date: Fri, 21 May 2010 11:35:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This looks unsafe. What protect child->mm if ptrace() races with SIGKILL ?
> 
> Of course, I do not blame this patch, the code was copied from arch/, but
> I think we need another patch which checks ->mm != NULL under task_lock()
> on top of this one?

Agreed, unless things are somehow different on nommu so there aren't such
races.  But, as you mention, this is a long-standing issue that is entirely 
unrelated to the cleanup here and should not delay merging this patch.


Thanks,
Roland
