Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab0HXCVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 22:21:22 -0400
Received: from ozlabs.org ([203.10.76.45]:49405 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227Ab0HXCVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 22:21:20 -0400
Date: Tue, 24 Aug 2010 12:16:26 +1000
From: Anton Blanchard <anton@samba.org>
To: Eric Paris <eparis@redhat.com>
Cc: Michael Neuling <mikey@neuling.org>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] audit: speedup for syscalls when auditing is disabled
Message-ID: <20100824021625.GA2425@kryten>
References: <29151.1282270393@neuling.org>
 <1282586177.2681.43.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282586177.2681.43.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Hi Eric,

> I don't think this works at all.  I don't see how syscall audit'ing can
> work.  What if I have nothing in the AUDIT_FILTER_TASK list but I want
> to audit all 'open(2)' syscalls?  This patch is going to leave the task
> in the DISABLED state and we won't ever be able to match on the syscall
> rules.

That's a good point. What if we went through and created an audit context
for each thread at the point where we add a rule to the audit subsystem?

That would make the common case where no one touches audit go fast. It's
only once you add a rule that you get the syscall entry/exit overhead of
audit.

Anton
