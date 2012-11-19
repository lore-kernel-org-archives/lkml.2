Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab2KSLK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 06:10:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842Ab2KSLK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 06:10:57 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <201211172227.BHB30739.OVOMFtFLHOFSQJ@I-love.SAKURA.ne.jp>
References: <201211172227.BHB30739.OVOMFtFLHOFSQJ@I-love.SAKURA.ne.jp>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: dhowells@redhat.com, arnd@arndb.de, tglx@linutronix.de,
        paulmck@linux.vnet.ibm.com, davej@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [3.7-rc6] Build failure with scripts/Makefile.headersinst
Date: Mon, 19 Nov 2012 11:10:15 +0000
Message-ID: <24020.1353323415@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:

> /usr/src/all/linux/scripts/Makefile.headersinst:50: *** Missing UAPI file /usr/src/all/linux/include/uapi/asm-generic/auxvec.h.  Stop.

That line is here:

	input-files   := $(foreach hdr, $(header-y), \
			   $(or \
				$(wildcard $(srcdir)/$(hdr)), \
				$(wildcard $(oldsrcdir)/$(hdr)), \
--->				$(error Missing UAPI file $(srcdir)/$(hdr)) \
			   )) \
			 $(foreach hdr, $(genhdr-y), \
			   $(or \
				$(wildcard $(gendir)/$(hdr)), \
				$(error Missing generated UAPI file $(gendir)/$(hdr)) \
			   ))

The version of the compiler shouldn't have any effect as far as I can see.
Can you add the following:

	$(info XXXX $(srcdir)/$(hdr)) \
	$(info YYYY $(oldsrcdir)/$(hdr)) \

immediately before the marked line and look for the lines in the output from
make.  The error suggests that neither pattern match worked.

Btw, are you supplying an O= flag to make when you build?

David
