Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab0DFJAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 05:00:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:44707 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab0DFJAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 05:00:34 -0400
Subject: Re: [PATCH] Separate lock events with types
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       tglx@linutronix.de, gregkh@suse.de
In-Reply-To: <20100326233259.GI7166@nowhere>
References: <20100129221252.GA5052@nowhere>
	 <1267002166-7281-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <20100326233259.GI7166@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Apr 2010 10:26:06 +0200
Message-ID: <1270542366.1597.720.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-27 at 00:33 +0100, Frederic Weisbecker wrote:
> So if we store the lock type in the lockdep_map, we can just dump
> the type on lock class initialization:
> 
> - on register_lock_class
> - on event injection to catchup with lock that have already registered
> 
> That's what does my tree perf/inject (minus the lock type), but this
> all require a redesign, in both ftrace and perf sides.
> 

Right, and I don't like to bloat dep_map for no reason. I still think
all this lock type stuff is a waste of time.

