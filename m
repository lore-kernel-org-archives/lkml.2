Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab2HTPsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:48:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42814 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab2HTPsP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:48:15 -0400
Message-ID: <1345477686.23018.62.camel@twins>
Subject: Re: lockdep trace from posix timers
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Date: Mon, 20 Aug 2012 17:48:06 +0200
In-Reply-To: <20120820154331.GA20796@redhat.com>
References: <20120724203613.GA9637@redhat.com>
	 <1345140478.29668.54.camel@twins> <20120817151447.GA7918@redhat.com>
	 <1345446957.23018.14.camel@twins> <20120820154331.GA20796@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-20 at 17:43 +0200, Oleg Nesterov wrote:
> BTW, do you think it is really important to try to avoid ->pi_lock?

It is for me, I'm doing task_work_add() from under rq->lock.. :/ I could
fudge around and delay, but not having to would be nice.
