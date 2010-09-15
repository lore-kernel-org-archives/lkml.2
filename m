Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab0IOJ3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 05:29:25 -0400
Received: from r00tworld.com ([212.85.137.21]:37140 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab0IOJ3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 05:29:23 -0400
From: pageexec@freemail.hu
To: Roland McGrath <roland@redhat.com>
Date: Wed, 15 Sep 2010 11:27:47 +0200
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
Message-ID: <4C909193.2667.179386C9@pageexec.freemail.hu>
In-reply-to: <20100914230411.B1F0D403E8@magilla.sf.frob.com>
References: <20100908023549.BFFA8401AF@magilla.sf.frob.com>, <pageexec@freemail.hu's message of  Wednesday, 15 September 2010 00:27:58 +0200 <4C8FF6EE.21454.153770F9@pageexec.freemail.hu>>, <20100914230411.B1F0D403E8@magilla.sf.frob.com>
X-mailer: Pegasus Mail for Windows (4.52)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Wed, 15 Sep 2010 11:27:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 Sep 2010 at 16:04, Roland McGrath wrote:

> > userland could never rely on the kernel's policy at all since get_arg_page
> > could have failed for more reasons than overstepping the currently hardcoded
> > ARG_MAX check in there. 
> 
> I don't see how it could fail except for OOM cases where get_user_pages()
> failed rather than blocking.  Is that what you mean?

yes but it's not only OOM (ENOMEM from some allocation), but it can be also
EPERM from LSM (if mmap_min_addr is set too high) or EFAULT from get_user_pages
(e.g., if VM_FAULT_HWPOISON was returned for a requested page).

