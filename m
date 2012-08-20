Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab2HTHQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 03:16:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51619 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab2HTHQJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 03:16:09 -0400
Message-ID: <1345446957.23018.14.camel@twins>
Subject: Re: lockdep trace from posix timers
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Date: Mon, 20 Aug 2012 09:15:57 +0200
In-Reply-To: <20120817151447.GA7918@redhat.com>
References: <20120724203613.GA9637@redhat.com>
	 <1345140478.29668.54.camel@twins> <20120817151447.GA7918@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-17 at 17:14 +0200, Oleg Nesterov wrote:
> I still think that task_work_add() should synhronize with exit_task_work()
> itself and fail if necessary. But I wasn't able to convince Al ;)

I'm not at all sure how that relates to needing task_lock() in the
keyctl stuff.

Also, can't task_work use llist stuff? That would also avoid using
->pi_lock.
