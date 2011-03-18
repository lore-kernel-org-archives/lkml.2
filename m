Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab1CRDOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 23:14:08 -0400
Received: from tex.lwn.net ([70.33.254.29]:59099 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932130Ab1CRDOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 23:14:03 -0400
Date: Thu, 17 Mar 2011 21:15:48 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] checkpatch: Test for kmalloc/memset(0) pairs
Message-ID: <20110317211548.646b04d2@tpl.lwn.net>
In-Reply-To: <1300416744.16880.904.camel@gandalf.stny.rr.com>
References: <1300416744.16880.904.camel@gandalf.stny.rr.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Mar 2011 22:52:24 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> The use of kzalloc() is preferred over kmalloc/memset(0) pairs.
> 
> When a match is made with "memset(p, 0, s);" a search back through the
> patch hunk is made looking for "p = kmalloc(s,". If that is found, then
> a warning is given, suggesting to use kzalloc() instead.

The Coccinelle stuff already has a lot of this kind of test.  See, for
example, scripts/coccinelle/api/alloc/kzalloc-simple.cocci.  Suppose
there is some way all this nice analysis infrastructure could be
integrated instead of duplicated?  Or am I just a crazy dreamer?

jon
