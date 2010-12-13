Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab0LMO0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 09:26:00 -0500
Received: from mail.anarazel.de ([217.115.131.40]:56154 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab0LMOZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 09:25:58 -0500
From: Andres Freund <andres@anarazel.de>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: Costly Context Switches
Date: Mon, 13 Dec 2010 15:25:54 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc6-andres-00006-g4193d91; KDE/4.5.1; x86_64; ; )
Cc: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
        linux-kernel@vger.kernel.org
References: <20101212151112.GE26583@charite.de> <201012122007.07372.andres@anarazel.de> <20101213135104.GE5407@ghostprotocols.net>
In-Reply-To: <20101213135104.GE5407@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012131525.54577.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 December 2010 14:51:04 Arnaldo Carvalho de Melo wrote:
> Em Sun, Dec 12, 2010 at 08:07:07PM +0100, Andres Freund escreveu:
> > On Sunday 12 December 2010 16:11:12 Ralf Hildebrandt wrote:
> > > I recently made a parallel installation of dovecot-2.0 on my mailbox
> > > server, which is running dovecot-1.2 without any problems whatsoever.
> > > 
> > > Using dovecot-2.0 on the same hardware, same kernel, with the same
> > > users and same mailboxes and usage behaviour results in an immense
> > > increase in the load numbers.
> > > 
> > > Switching back to 1.2 results in a immediate decrease of the load back
> > > to "normal" numbers.
> > > 
> > > This is mainly due to a 10-20 fold increase of the number of context
> > > switches. The same problem has been reported independently by Cor
> > > Bosman of XS4All, on different hardware (64bit instead of 32bit,
> > > real hardware instead of virtual hardware).
> > > 
> > > So, now the kernel related question: How can I find out WHY the
> > > context switches are happening? Are there any "in kernel" statistics
> > > I could look at?
> > 
> > "strace" or "perf trace syscall-counts" would be a good start.
> 
> Better to record just "cs" (Context Switches) events and also to collect
> callchains when those events take place:
Hm. Its also a good starting point but it may be harder to see the differences 
between dovecot-2.0 and dovecot-1.2 that way because its harder to see if its 
the usage being different causing the problem (i.e. calling in a different 
order, trashing caches) or if its the amount of syscalls that changed. But I 
agree that both are very usefull analyze problems like that.

Andres
