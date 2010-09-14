Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab0INW3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 18:29:00 -0400
Received: from r00tworld.com ([212.85.137.21]:59372 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523Ab0INW26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 18:28:58 -0400
From: pageexec@freemail.hu
To: Roland McGrath <roland@redhat.com>
Date: Wed, 15 Sep 2010 00:27:58 +0200
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
Message-ID: <4C8FF6EE.21454.153770F9@pageexec.freemail.hu>
In-reply-to: <20100914211644.E0C58403E8@magilla.sf.frob.com>
References: <20100908023549.BFFA8401AF@magilla.sf.frob.com>, <pageexec@freemail.hu's message of  Tuesday, 14 September 2010 22:28:31 +0200 <4C8FDAEF.17347.14CA1791@pageexec.freemail.hu>>, <20100914211644.E0C58403E8@magilla.sf.frob.com>
X-mailer: Pegasus Mail for Windows (4.52)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Wed, 15 Sep 2010 00:27:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 Sep 2010 at 14:16, Roland McGrath wrote:

> > obviously an AT_ARGMAX computed at execve time would be based on the rlimits
> > as well and if later userland changed the rlimits, it'd be userland's problem,
> > not that of the kernel (or the kernel could refuse a change that would violate
> > its earlier promise).
> 
> This would thoroughly defeat the purpose of adding the thing.  The
> only reason to have a new thing is so that userland does not have to
> mirror the kernel's policy (as it attempts to do now, with the 1/4
> calculation).  If the new thing is not something that userland can
> use consistently so as not to have to know what the kernel's actual
> policy is, then I don't see the point of it at all.

userland could never rely on the kernel's policy at all since get_arg_page
could have failed for more reasons than overstepping the currently hardcoded
ARG_MAX check in there. so what AT_ARGMAX would buy us is to allow the kernel
policy to change over time, but it's never been about guarantees, whether
POSIX wants such a thing or not.

> > >  auxv is only appropriate for things that
> > > are known at the time of the exec and won't change thereafter.
> > 
> > you mean stuff like AT_EUID et al.? ;)
> 
> The information that these give is about the conditions at startup.
> That's what they mean to userland, and userland only uses them to know
> the situation before it has made any calls.  The definition of AT_EUID
> is "effective user ID at program startup", and that fact does not
> change.

just for my own curiosity, where does this definition come from?

