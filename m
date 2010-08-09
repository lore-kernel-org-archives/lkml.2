Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab0HIJIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 05:08:16 -0400
Received: from lo.gmane.org ([80.91.229.12]:53110 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755834Ab0HIJIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 05:08:15 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: [PATCH]exit.c: support larger exit code
Date: Mon, 9 Aug 2010 09:25:49 +0100
Message-ID: <dlq4j7-0tp.ln1@chipmunk.wormnet.eu>
References: <14414B36FFA0F1418CB707361EAA199A0194FB16@CNBEEXC006.nsn-intra.net>
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: chipmunk.wormnet.eu
User-Agent: tin/1.9.3-20080506 ("Dalintober") (UNIX) (Linux/2.6.26-2-sparc64-smp (sparc64))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Zhang, Wei-Jovi (NSN - CN/Hangzhou)" <wei-jovi.zhang@nsn.com> wrote:
> 
> I think this is just a convention of userspace program. if program 
> want to obey this convention, it should be use one-byte limition exit 
> code, I agree this. so this mail thread's subject should change to "if 
> program use exit code with not want to obey the convention, kernel 
> should return which value?"
>
I do have to agree with you on this point, although I stand by my 
thoughts on *how* you should be using the exit code.  Whilst writing my 
post I was thinking why in C is it 'int main()' and not 'u8 main()'.

A dig around with my Googlefu and on Wackipedia gave me nothing 
either...

One thing I can think of why the kernel is forcing a one byte return 
code is that:
 * guarantee there is no endian issue; hard to pull off though but I 
	guess that exit code could travel across IP to another 
	architecture
 * stop people abusing the exitcode :)

There is probably a deeper reason as errno.h/errno-base.h all seem to be 
one byte return codes too.  I'm starting to ponder if that top three 
bytes are meant to carry some other information?

Cheers

-- 
Alexander Clouter
.sigmonster says: Make sure your code does nothing gracefully.

