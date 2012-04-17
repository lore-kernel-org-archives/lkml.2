Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab2DQNy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 09:54:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932331Ab2DQNyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 09:54:25 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120414030507.GA27579@redhat.com>
References: <20120414030507.GA27579@redhat.com> <20120414021201.GA23385@redhat.com> <20120414021220.GA23393@redhat.com> <CA+55aFyxV8v2mOjb1Ly=1ttPyLvUt6RZO8wgjD_9owtO=VM0hw@mail.gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Gordeev <agordeev@redhat.com>,
        Chris Zankel <chris@zankel.net>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] task_work_add: generic process-context callbacks
Date: Tue, 17 Apr 2012 14:53:59 +0100
Message-ID: <26488.1334670839@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> tsk is always "current", probably this should be documented, I'll add
> the comment.

If tsk is always current, then don't pass it as a parameter.  Some arches keep
current in a register and it's much more efficient to use current directly in
those cases - and those that don't have to be able to obtain it reasonably
quickly.

David
