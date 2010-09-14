Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab0INXFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 19:05:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab0INXFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 19:05:00 -0400
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
In-Reply-To: pageexec@freemail.hu's message of  Wednesday, 15 September 2010 00:27:58 +0200 <4C8FF6EE.21454.153770F9@pageexec.freemail.hu>
References: <20100908023549.BFFA8401AF@magilla.sf.frob.com>
	<pageexec@freemail.hu's message of  Tuesday, 14 September 2010 22:28:31 +0200 <4C8FDAEF.17347.14CA1791@pageexec.freemail.hu>
	<20100914211644.E0C58403E8@magilla.sf.frob.com>
	<4C8FF6EE.21454.153770F9@pageexec.freemail.hu>
X-Shopping-List: (1) Metric rectums
   (2) Asiatic Paradoxes
   (3) Periodical excitements
   (4) Disorienting ceremonious brunch
   (5) Interlocking inhibitions
Message-Id: <20100914230411.B1F0D403E8@magilla.sf.frob.com>
Date: Tue, 14 Sep 2010 16:04:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> userland could never rely on the kernel's policy at all since get_arg_page
> could have failed for more reasons than overstepping the currently hardcoded
> ARG_MAX check in there. 

I don't see how it could fail except for OOM cases where get_user_pages()
failed rather than blocking.  Is that what you mean?

> so what AT_ARGMAX would buy us is to allow the kernel
> policy to change over time, but it's never been about guarantees, whether
> POSIX wants such a thing or not.

I understand the motivation for an explicit mechanism for the kernel to
tell userland its limit.  Since the kernel policy today depends on
something that can change between execs, AT_ARGMAX is inadequate for
that purpose for today's policy, let alone any future different policy.

> > The information that these give is about the conditions at startup.
> > That's what they mean to userland, and userland only uses them to know
> > the situation before it has made any calls.  The definition of AT_EUID
> > is "effective user ID at program startup", and that fact does not
> > change.
> 
> just for my own curiosity, where does this definition come from?

You mean documentation?  I'm not really sure if there is any for that.
But it's the inherent definition of auxv that all its information can
only be about the conditions at program startup.


Thanks,
Roland
