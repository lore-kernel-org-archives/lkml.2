Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab0INVRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 17:17:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114Ab0INVRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 17:17:33 -0400
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
In-Reply-To: pageexec@freemail.hu's message of  Tuesday, 14 September 2010 22:28:31 +0200 <4C8FDAEF.17347.14CA1791@pageexec.freemail.hu>
References: <20100908023549.BFFA8401AF@magilla.sf.frob.com>
	<pageexec@freemail.hu's message of  Saturday, 11 September 2010 15:39:30 +0200 <4C8B8692.7649.3E0895B@pageexec.freemail.hu>
	<20100914185135.03DD6403E8@magilla.sf.frob.com>
	<4C8FDAEF.17347.14CA1791@pageexec.freemail.hu>
Emacs: ed  ::  20-megaton hydrogen bomb : firecracker
Message-Id: <20100914211644.E0C58403E8@magilla.sf.frob.com>
Date: Tue, 14 Sep 2010 14:16:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> obviously an AT_ARGMAX computed at execve time would be based on the rlimits
> as well and if later userland changed the rlimits, it'd be userland's problem,
> not that of the kernel (or the kernel could refuse a change that would violate
> its earlier promise).

This would thoroughly defeat the purpose of adding the thing.  The
only reason to have a new thing is so that userland does not have to
mirror the kernel's policy (as it attempts to do now, with the 1/4
calculation).  If the new thing is not something that userland can
use consistently so as not to have to know what the kernel's actual
policy is, then I don't see the point of it at all.

> >  auxv is only appropriate for things that
> > are known at the time of the exec and won't change thereafter.
> 
> you mean stuff like AT_EUID et al.? ;)

The information that these give is about the conditions at startup.
That's what they mean to userland, and userland only uses them to know
the situation before it has made any calls.  The definition of AT_EUID
is "effective user ID at program startup", and that fact does not
change.  You proposed AT_ARGMAX for a purpose that requires knowing
the current information in the process at the time it might attempt an
execve call, not at startup.  It is not an equivalent case.


Thanks,
Roland

