Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab1HHM3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 08:29:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130Ab1HHM26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 08:28:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20110807175511.GZ2203@ZenIV.linux.org.uk>
References: <20110807175511.GZ2203@ZenIV.linux.org.uk>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: fix rcu annotations noise in cred.h
Date: Mon, 08 Aug 2011 13:28:51 +0100
Message-ID: <5285.1312806531@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> wrote:

> task->cred is declared as __rcu, and access to other tasks' ->cred is,
> indeed, protected.  Access to current->cred does not need rcu_dereference()
> at all, since only the task itself can change its ->cred.  sparse, of
> course, has no way of knowing that...

What was the Sparse warning, btw?  You didn't say.  I don't see any warnings,
but it's possible I have a too-old version of Sparse or the wrong config
options?  (Or maybe I just don't know what to look for)

David
