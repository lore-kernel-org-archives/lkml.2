Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab2AaNkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 08:40:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:51752 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab2AaNkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 08:40:23 -0500
Date: Tue, 31 Jan 2012 05:41:55 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>,
        Andrew Morton <akpm@linux-foundation.org>, arjanvandeven@gmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: smp: Start up non-boot CPUs asynchronously
Message-ID: <20120131054155.371e8307@infradead.org>
In-Reply-To: <20120131125232.GD4408@elte.hu>
References: <20120130205444.22f5e26a@infradead.org>
	<20120131125232.GD4408@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jan 2012 13:52:32 +0100
Ingo Molnar <mingo@elte.hu> wrote:
> 
> The real fix would be to make the init code depend less on each 
> other, i.e. have less hotplug lock dependencies. Or, if it's 
> such a hot lock for a good reason, why does spinning on it slow 
> down the boot process? It really shouldnt.

by inspection, anything that calls get_online_cpus()/put_online_cpus()
will block while a CPU is coming up. This is used in things like 
kmem_cache_create()... which is used about everywhere.
(there's various other places... more or less it's a requirement
for using the for_each_online_cpu() api correctly)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
