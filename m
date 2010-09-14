Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab0INUaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:30:10 -0400
Received: from r00tworld.com ([212.85.137.21]:48877 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755543Ab0INUaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:30:08 -0400
From: pageexec@freemail.hu
To: Roland McGrath <roland@redhat.com>
Date: Tue, 14 Sep 2010 22:28:31 +0200
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] setup_arg_pages: diagnose excessive argument size
Reply-to: pageexec@freemail.hu
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Brad Spengler <spender@grsecurity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
        linux-fsdevel@vger.kernel.org, Eugene Teo <eugene@redhat.com>
Message-ID: <4C8FDAEF.17347.14CA1791@pageexec.freemail.hu>
In-reply-to: <20100914185135.03DD6403E8@magilla.sf.frob.com>
References: <20100908023549.BFFA8401AF@magilla.sf.frob.com>, <pageexec@freemail.hu's message of  Saturday, 11 September 2010 15:39:30 +0200 <4C8B8692.7649.3E0895B@pageexec.freemail.hu>>, <20100914185135.03DD6403E8@magilla.sf.frob.com>
X-mailer: Pegasus Mail for Windows (4.52)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Tue, 14 Sep 2010 22:28:22 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 Sep 2010 at 11:51, Roland McGrath wrote:

> > no it doesn't have to, similarly to how it doesn't have to hardcode
> > _SC_PAGESIZE either, AT_PAGESZ tells userland what it needs to know
> > and i think AT_ARGMAX could exist just as well.
> 
> I was referring to the ways available to userland heretofore.  Certainly,
> the kernel could add new ways and then userland could do different things
> (with new kernels).  
> 
> auxv in particular is not a mechanism that could fit for this.  The actual
> limit depends on rlimits of the calling process, and rlimits can change
> during the life of the program.

obviously an AT_ARGMAX computed at execve time would be based on the rlimits
as well and if later userland changed the rlimits, it'd be userland's problem,
not that of the kernel (or the kernel could refuse a change that would violate
its earlier promise).

>  auxv is only appropriate for things that
> are known at the time of the exec and won't change thereafter.

you mean stuff like AT_EUID et al.? ;)

