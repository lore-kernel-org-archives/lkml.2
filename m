Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab1KWLLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 06:11:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab1KWLLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 06:11:38 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1321985686-798-2-git-send-email-ddaney.cavm@gmail.com>
References: <1321985686-798-2-git-send-email-ddaney.cavm@gmail.com> <1321985686-798-1-git-send-email-ddaney.cavm@gmail.com>
To: David Daney <ddaney.cavm@gmail.com>
Cc: dhowells@redhat.com, ralf@linux-mips.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, DM <dm.n9107@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH v2 1/2] kernel.h: Add BUILD_BUG() macro.
Date: Wed, 23 Nov 2011 11:11:20 +0000
Message-ID: <2657.1322046680@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Daney <ddaney.cavm@gmail.com> wrote:

> From: David Daney <david.daney@cavium.com>
> 
> We can place this in definitions that we expect the compiler to remove
> by dead code elimination.  If this assertion fails, we get a nice
> error message at build time.
> 
> The GCC function attribute error("message") was added in version 4.3,
> so we define a new macro __linktime_error(message) to expand to this
> for GCC-4.3 and later.  This will give us an error diagnostic from the
> compiler on the line that fails.  For other compilers
> __linktime_error(message) expands to nothing, and we have to be
> content with a link time error, but at least we will still get a build
> error.
> 
> BUILD_BUG() expands to the undefined function __build_bug_failed() and
> will fail at link time if the compiler ever emits code for it.  On
> GCC-4.3 and later, attribute((error())) is used so that the failure
> will be noted at compile time instead.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>

Acked-by: David Howells <dhowells@redhat.com>
