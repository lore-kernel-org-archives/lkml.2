Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab1D3LSy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 07:18:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62938 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab1D3LSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 07:18:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EWpzB0BHbuL0fiPkqTq+Rt1JecWBVfRRO3LQgHm26rdSjPWA14+3K5qFJGZ83/ikCR
         8BN0lC1Q3tCsFg8Q6RM/zh6zya66PsQVwGWLY7lW+Nx8RbPqJmEWMM1xjiUUT2XLCaDe
         zdsV7aa0yXzfZN6TSAewZy4xltl9ohu5u4ZgE=
Date: Sat, 30 Apr 2011 13:18:49 +0200
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thilo-Alexander Ginkel <thilo@ginkel.com>
Subject: [GIT PULL] workqueue: fix possible deadlock on non-preemptive
 kernels
Message-ID: <20110430111849.GA29280@htj.dyndns.org>
References: <20110430111526.GA28147@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110430111526.GA28147@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry, the original posting was missing subject line.  Resending.)

Hello, Linus.

Please pull from the following branch to receive fix for a deadlock
which can happen between rescuers and stop_machine() while bringing
down CPUs on non-preemptive kernels.  The problem could be
half-reliably reproduced by Thilo-Alexander while the system is
entering suspend.  The branch also contains another commit which
documents workqueue debugging tricks.

The pull will cause conflict against 25985edced (Fix common
misspellings).  The fixed misspelling unfortunately was in the comment
which the fix replaces.  The conflict can be resolved by simply taking
the version from the fix commit.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git fixes-2.6.39

Thank you.

Florian Mickler (1):
      workqueue: Document debugging tricks

Tejun Heo (1):
      workqueue: fix deadlock in worker_maybe_bind_and_lock()

 Documentation/workqueue.txt |   40 ++++++++++++++++++++++++++++++++++++++++
 kernel/workqueue.c          |    8 +++++++-
 2 files changed, 47 insertions(+), 1 deletions(-)

-- 
tejun
