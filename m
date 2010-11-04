Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab0KDN6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 09:58:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34704 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab0KDN6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 09:58:17 -0400
Date: Thu, 4 Nov 2010 14:58:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Marcus Meissner <meissner@suse.de>
Cc: linux-kernel@vger.kernel.org, jason.wessel@windriver.com,
        fweisbec@gmail.com, tj@kernel.org, mort@sgi.com, akpm@osdl.org,
        security@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
Message-ID: <20101104135802.GA31416@elte.hu>
References: <20101104100914.GC25118@suse.de>
 <20101104114648.GA23381@elte.hu>
 <20101104122906.GH25118@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101104122906.GH25118@suse.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Marcus Meissner <meissner@suse.de> wrote:

> On Thu, Nov 04, 2010 at 12:46:48PM +0100, Ingo Molnar wrote:
> > 
> > * Marcus Meissner <meissner@suse.de> wrote:
> > 
> > > Hi,
> > > 
> > > Making /proc/kallsyms readable only for root makes it harder for attackers to 
> > > write generic kernel exploits by removing one source of knowledge where things are 
> > > in the kernel.
> > 
> > Cc:-ed Linus - i think he argued in favor of such a patch in the past.
> > 
> > I generally agree with such patches (i have written some myself), but there's a few 
> > questions with this one, which make this limited change ineffective and which make 
> > it harder to implement a fuller patch that makes it truly harder to figure out the 
> > precise kernel build:
> > 
> >  - The real security obstruction effect is very small from this measure alone: the 
> >    overwhelming majority of our users are running distro kernels, so the Symbol.map 
> >    file (and hence 99% of /proc/kallsyms content) is well-known - unless we also 
> >    restrict 'uname -r' from nonprivileged users-ace. Hiding that might make sense - 
> >    but the two should be in one patch really.
> 
> Of course. System.map and others also need to turn to mode 400.

That is not what I meant, at all.

It's not the System.map _on the system_.

It's the SuSE or Fedora kernel rpm package with a System.map in it, which
package the attacker can download from a hundred mirrors on the internet,
based on 'uname -r' output.

You cannot obfuscate the System.map of a distro kernel without obfuscating all 
identification info. (Note that even the pure size of the System.map might tell a 
kernel rpm version from another ...)

	Ingo
