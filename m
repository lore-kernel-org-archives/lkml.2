Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab1KQDDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 22:03:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45507 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365Ab1KQDDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 22:03:41 -0500
Date: Thu, 17 Nov 2011 11:03:32 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -rt] memcg: use migrate_disable()/migrate_enable( ) in
 memcg_check_events()
Message-ID: <20111117030332.GA14492@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <alpine.LFD.2.02.1111150050590.4902@ionos>
 <20111115084059.GA23250@zhy>
 <20111116091653.GA8692@zhy>
 <1321452758.4181.18.camel@frodo>
 <alpine.LFD.2.02.1111161801270.4902@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1111161801270.4902@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 06:02:42PM +0100, Thomas Gleixner wrote:
> On Wed, 16 Nov 2011, Steven Rostedt wrote:
> > On Wed, 2011-11-16 at 17:16 +0800, Yong Zhang wrote:
> > > Looking at commit 4799401f [memcg: Fix race condition in
> > > memcg_check_events() with this_cpu usage], we just want
> > > to disable migration. So use the right API in -rt. This
> > > will cure below warning.
> > No this won't work. Not even for -rt. If we disable migration but not
> > preemption, then two tasks can take this path. And the checks in
> > __memcg_event_check() will be corrupted because nothing is protecting
> > the updates from two tasks going into the same path.
> > 
> > Perhaps a local_lock would work.
> 
> Yes, that's the only sensible option for now. Untested patch below.

Works for me.

Thanks,
Yong
