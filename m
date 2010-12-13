Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664Ab0LMO3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 09:29:18 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:42487 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab0LMO3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 09:29:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=UEn8amoZpwA7S3NBZ0YmSh5T7vbGBC2TXumhIMoUxoFwbowdbZhhIadZzSaetuTxlh
         xb1rJpjd6kGwDoKbYDmg5Jj7dvxtYfHnH/Sd5cqswix9N7Ck7xnNWbowlz2sND6W5hNd
         4yz5XJC6hBcM5z80q3GQO/vUlHIc1+s4AeLjo=
Date: Mon, 13 Dec 2010 12:29:11 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Andres Freund <andres@anarazel.de>
Cc: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
        linux-kernel@vger.kernel.org
Subject: Re: Costly Context Switches
Message-ID: <20101213142911.GH5407@ghostprotocols.net>
References: <20101212151112.GE26583@charite.de>
 <201012122007.07372.andres@anarazel.de>
 <20101213135104.GE5407@ghostprotocols.net>
 <201012131525.54577.andres@anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012131525.54577.andres@anarazel.de>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 13, 2010 at 03:25:54PM +0100, Andres Freund escreveu:
> On Monday 13 December 2010 14:51:04 Arnaldo Carvalho de Melo wrote:
> > Em Sun, Dec 12, 2010 at 08:07:07PM +0100, Andres Freund escreveu:
> > > On Sunday 12 December 2010 16:11:12 Ralf Hildebrandt wrote:
> > > > I recently made a parallel installation of dovecot-2.0 on my mailbox
> > > > server, which is running dovecot-1.2 without any problems whatsoever.
> > > > 
> > > > Using dovecot-2.0 on the same hardware, same kernel, with the same
> > > > users and same mailboxes and usage behaviour results in an immense
> > > > increase in the load numbers.
> > > > 
> > > > Switching back to 1.2 results in a immediate decrease of the load back
> > > > to "normal" numbers.
> > > > 
> > > > This is mainly due to a 10-20 fold increase of the number of context
> > > > switches. The same problem has been reported independently by Cor
> > > > Bosman of XS4All, on different hardware (64bit instead of 32bit,
> > > > real hardware instead of virtual hardware).
> > > > 
> > > > So, now the kernel related question: How can I find out WHY the
> > > > context switches are happening? Are there any "in kernel" statistics
> > > > I could look at?
> > > 
> > > "strace" or "perf trace syscall-counts" would be a good start.
> > 
> > Better to record just "cs" (Context Switches) events and also to collect
> > callchains when those events take place:

> Hm. Its also a good starting point but it may be harder to see the differences 
> between dovecot-2.0 and dovecot-1.2 that way because its harder to see if its 

Well, for that he can try 'perf diff', i.e.:

1. run perf record on dovecot-1.2
2. run perf record on dovecot-2.0
3. perf diff

> the usage being different causing the problem (i.e. calling in a different 
> order, trashing caches) or if its the amount of syscalls that changed. But I 
> agree that both are very usefull analyze problems like that.

Well, I tried to answer his question:

"How can I find out WHY the context switches are happening?"

:-)

- Arnaldo
