Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab1BCVgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:36:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935Ab1BCVgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:36:52 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Tejun Heo <tj@kernel.org>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
In-Reply-To: Oleg Nesterov's message of  Thursday, 3 February 2011 21:41:54 +0100 <20110203204154.GB26371@redhat.com>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
	<1296227324-25295-11-git-send-email-tj@kernel.org>
	<20110203204122.GA26371@redhat.com>
	<20110203204154.GB26371@redhat.com>
Emacs: there's a reason it comes with a built-in psychotherapist.
Message-Id: <20110203213640.1F516180995@magilla.sf.frob.com>
Date: Thu,  3 Feb 2011 13:36:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMHO this sort of band-aid does not really help the overall situation.
It takes something that is intricate and fiddly and just fiddles it a
bit more.  Userland will still have to handle older kernels where this
behavior is not there.  If userland does anything that relies on this
new behavior, then it will have to try somehow to figure out which
kernel versions have which behavior and adapt, etc.

When the old behaviors are unhelpful like this, I think it is really
better to add new mechanisms instead.  We can make new mechanisms more
clear and straightforward for userland to work with from the beginning.
Then the compatibility picture for userland is simply to try a new call
or new ptrace request or new option bit or whatever it is.  When the
kernel supports the new thing, things are easy.  When it doesn't, then
they cope with life as they have been coping before on old kernels.

I have some ideas about new things to add for this problem area.  But
we have to think those through carefully and discuss all the details
thoroughly with Jan and other folks working on userland debuggers
before we write the kernel side.


Thanks,
Roland
