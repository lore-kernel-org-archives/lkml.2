Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab2FWVBq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 17:01:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51206 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704Ab2FWVBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 17:01:44 -0400
Date: Sat, 23 Jun 2012 22:01:41 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: deferring __fput()
Message-ID: <20120623210141.GK14083@ZenIV.linux.org.uk>
References: <1340369098.2464.20.camel@falcor>
 <20120623092049.GH14083@ZenIV.linux.org.uk>
 <20120623194505.GI14083@ZenIV.linux.org.uk>
 <20120623203800.GA10306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120623203800.GA10306@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 10:38:00PM +0200, Oleg Nesterov wrote:

> > Matter of fact, it would become identical to struct rcu_head
> > after that...
> 
> This is not clear to me... Why this is good?

Occam's Razor.

> I understand that sizeof(task_work) == sizeof(rcu_head) would be
> nice, probably you meant just this?

More than that - the callback type is also the same (pointer to such
struct -> void).  IOW, they both look like two instances of the
same thing ("list of callbacks"), differing only in what and
when does calling.
