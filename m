Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab1CIGjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 01:39:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60564
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752732Ab1CIGjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 01:39:14 -0500
Date: Tue, 08 Mar 2011 22:39:51 -0800 (PST)
Message-Id: <20110308.223951.193722389.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, mrubin@google.com, dhsharp@google.com
Subject: Re: [PATCH 04/15] ftrace: pack event structures.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1299627003.20306.94.camel@gandalf.stny.rr.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
	<1291421609-14665-5-git-send-email-dhsharp@google.com>
	<1299627003.20306.94.camel@gandalf.stny.rr.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 08 Mar 2011 18:30:03 -0500

> I'm going back through this patch set and looking to incorporate it into
> 2.6.39. But I know how touchy sparc is with "packed" data structures. Do
> you see this patch as hurting sparc?
> 
> I wonder if we should change this to something like:
> 
> #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> # define do_event_packed __attirbute__((packed))
> #else
> # define do_event_packed
> #endif
> 
> and use "do_event_packed" instead?

I think you should elide packed at all costs, and instead tell the compiler
what your intentions are by exposing the real types using unions or
similar instead of hiding it in an opaque way behind final char[] arrays.

