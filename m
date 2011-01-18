Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab1ARGg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 01:36:26 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53005
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753153Ab1ARGgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 01:36:24 -0500
Date: Mon, 17 Jan 2011 22:36:58 -0800 (PST)
Message-Id: <20110117.223658.39164511.davem@davemloft.net>
To: mathieu.desnoyers@efficios.com
Cc: rostedt@goodmis.org, richm@oldelvet.org.uk, 609371@bugs.debian.org,
        ben@decadent.org.uk, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110117193525.GD16154@Krystal>
References: <20110116.113944.48514452.davem@davemloft.net>
	<1295273486.16479.15.camel@gandalf.stny.rr.com>
	<20110117193525.GD16154@Krystal>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Mon, 17 Jan 2011 14:35:25 -0500

> Steven, what were you trying to fix in the first place when you added the
> aligned(4) to the definition ? It might have just been that the _ftrace_events
> section needed to be aligned on at least 8 bytes in the linker scripts, but was
> only aligned on 4-bytes. Forcing the definition alignment down to 4 possibly
> fixed the problem you experienced on x86_64, but seems to be causing other
> problems.
> 
> I would recommend to:
> 
> - Keep the linker script _ftrace_events alignment as it is now (aligned on 32
>   bytes).
> - Remove the aligned(4) attributes from all struct ftrace_event_call
>   definitions.

Completely agreed.
