Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab2BOSTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 13:19:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908Ab2BOSTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 13:19:39 -0500
Date: Wed, 15 Feb 2012 19:12:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
        arjan@linux.intel.com, fhrbata@redhat.com, john.johansen@canonical.com,
        penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, tj@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] usermodehelper: kill umh_wait, renumber UMH_*
	constants
Message-ID: <20120215181245.GA22588@redhat.com>
References: <20120214164709.GA21178@redhat.com> <20120214164821.GC21185@redhat.com> <87ty2sc37m.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ty2sc37m.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15, Rusty Russell wrote:
>
> On Tue, 14 Feb 2012 17:48:21 +0100, Oleg Nesterov <oleg@redhat.com> wrote:
> > No functional changes. It is not sane to use UMH_KILLABLE with
> > enum umh_wait, but obviously we do not want another argument in
> > call_usermodehelper_* helpers. Kill this enum, use the plain int.
>
> Seems like a step backwards.  Perhaps reorder the enum, but implying an
> explicit range of values explicit by using an enum seems good.

The problem is, the things like "UMH_WAIT_EXEC | UMH_KILLABLE" do not
look like enum to me, even if they both are enums and the resulting
code is correct.

OTOH, something like

	enum umh_wait {
		UMH_NO_WAIT,
		UMH_WAIT_EXEC,
		UMH_WAIT_PROC,
		UMH_WAIT_EXEC_KILLABLE,
		UMH_WAIT_PROC_KILLABLE,
	};

doesn't look very nice/convenient too.

But. This is the cleanup, and thus it should not disturb the maintainer.
I do not mind to redo it either way, just tell me what you prefer.

This change doesn't create any dependency, it can be reverted/reworked
at any moment. It could be the last patch in series, probably I should
have sent it as 6/6.

Or,

> But it's a minor gripe, feel free to ignore.

works for me too ;)

> Entire series:
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks!

Oleg.

