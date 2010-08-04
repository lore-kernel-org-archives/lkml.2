Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab0HDBen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 21:34:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:37254 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858Ab0HDBel convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 21:34:41 -0400
Date: Tue, 3 Aug 2010 18:34:47 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Cc: paulmck@linux.vnet.ibm.com, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100803183447.0275c134@infradead.org>
In-Reply-To: <AANLkTi=a-1hn_oL=i-=RKK9xOur+4mQjTRut+aiXtYkE@mail.gmail.com>
References: <20100731175841.GA9367@linux.vnet.ibm.com>
	<20100731215214.2543c07e@infradead.org>
	<20100801054816.GI2470@linux.vnet.ibm.com>
	<20100731230101.7cc1d8c7@infradead.org>
	<20100801191228.GL2470@linux.vnet.ibm.com>
	<20100801154708.19817b75@infradead.org>
	<20100802011006.GS2470@linux.vnet.ibm.com>
	<AANLkTi=a-1hn_oL=i-=RKK9xOur+4mQjTRut+aiXtYkE@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Aug 2010 21:56:10 -0700
Arve Hjønnevåg <arve@android.com> wrote:

> > non-obvious dependencies.
> >
> 
> The dependencies is what made this solution uninteresting to us. For
> instance, we currently use cgroup scheduling to reduce the impact of
> some background tasks, but we occasionally saw a watchdog restart of
> the system process were critical services were waiting on a kernel
> mutex owned by a background task for more than 20 seconds. If we froze
> a cgroup instead, we would not hit this particular problem since tasks
> cannot be frozen while executing kernel code the same way they can be
> preempted, but nothing prevents a task from being frozen while holding
> a user-space resource.
> 


one of the solutions we're looking at to solve this is to unfreeze the
cgroup on a regular basis (say, every 15 to 30 seconds) briefly to avoid
this kind of deadlock...



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
