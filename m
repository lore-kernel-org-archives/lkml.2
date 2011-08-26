Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab1HZVNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 17:13:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753774Ab1HZVNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 17:13:38 -0400
Date: Fri, 26 Aug 2011 14:13:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vladimir Zapolskiy <vzapolskiy@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [PATCH] connector: add comm change event report to proc
 connector
Message-Id: <20110826141334.bc2b5da6.akpm@linux-foundation.org>
In-Reply-To: <1312310811-17327-1-git-send-email-vzapolskiy@gmail.com>
References: <1312310811-17327-1-git-send-email-vzapolskiy@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  2 Aug 2011 21:46:51 +0300
Vladimir Zapolskiy <vzapolskiy@gmail.com> wrote:

> This change adds an event to monitor comm value changes of tasks. Such
> an event becomes vital, if someone desires to control threads of a
> process in different manner.
> 
> A natural characteristic of threads is its comm value, and helpfully
> application developers have an opportunity to change it in runtime.
> Reporting about such events via proc connector allows to fine-grain
> monitoring and control potentials, for instance a process control
> daemon listening to proc connector and following comm value policies
> can place specific threads to assigned cgroup partitions.
> 
> It might be possible to achieve a pale partial one-shot likeness
> without this update, if an application changes comm value of a thread
> generator task beforehand, then a new thread is cloned, and after
> that proc connector listener gets the fork event and reads new
> thread's comm value from procfs stat file, but this change visibly
> simplifies and extends the matter.

Monotoring and controlling tasks via their comm value seems weird,
inefficient and unreliable.  Who is doing this, and why?

