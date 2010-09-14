Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab0INSxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 14:53:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab0INSw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 14:52:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: pageexec@freemail.hu
X-Fcc: ~/Mail/linus
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Brad Spengler <spender@grsecurity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
        linux-fsdevel@vger.kernel.org, Eugene Teo <eugene@redhat.com>
Subject: Re: [PATCH 1/3] setup_arg_pages: diagnose excessive argument size
In-Reply-To: pageexec@freemail.hu's message of  Saturday, 11 September 2010 15:39:30 +0200 <4C8B8692.7649.3E0895B@pageexec.freemail.hu>
References: <20100908023549.BFFA8401AF@magilla.sf.frob.com>
	<KOSAKI Motohiro's message of  Thursday, 9 September 2010 14:31:18 +0900 <20100909141534.C948.A69D9226@jp.fujitsu.com>
	<20100910092541.2864A405D5@magilla.sf.frob.com>
	<4C8B8692.7649.3E0895B@pageexec.freemail.hu>
X-Windows: complex nonsolutions to simple nonproblems.
Message-Id: <20100914185135.03DD6403E8@magilla.sf.frob.com>
Date: Tue, 14 Sep 2010 11:51:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> no it doesn't have to, similarly to how it doesn't have to hardcode
> _SC_PAGESIZE either, AT_PAGESZ tells userland what it needs to know
> and i think AT_ARGMAX could exist just as well.

I was referring to the ways available to userland heretofore.  Certainly,
the kernel could add new ways and then userland could do different things
(with new kernels).  

auxv in particular is not a mechanism that could fit for this.  The actual
limit depends on rlimits of the calling process, and rlimits can change
during the life of the program.  auxv is only appropriate for things that
are known at the time of the exec and won't change thereafter.


Thanks,
Roland
