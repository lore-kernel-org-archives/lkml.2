Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab0D0Q3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 12:29:11 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:43170 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab0D0Q3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 12:29:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=l0vvjjXeTlDodTxkh8qnxEm3y0CeraV7JXae6Fke3wXZYfFeFL+XVmPNn6QZN0Jxxn
         yypuTFKPWS5L9eeQKBGwDK5qdUcjet4+kTvWIsLc0eohrPOU7RGlLHJGI15PaqgAISSY
         Psas69MwaSA3qsGn8sIrfrJOT3E/0n3Q1p6qE=
Date: Tue, 27 Apr 2010 18:29:02 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: John Kacur <jkacur@redhat.com>,
       =?ISO-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>,
       Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/7] logfs: push down BKL into ioctl function
In-Reply-To: <alpine.LFD.2.00.1004270833530.3739@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1004271826140.3318@localhost>
References: <alpine.LFD.2.00.1004271359180.3318@localhost> <1272378265-10909-2-git-send-email-arnd@arndb.de> <20100427145804.GA16794@logfs.org> <201004271705.50499.arnd@arndb.de> <20100427150919.GB16794@logfs.org> <alpine.LFD.2.00.1004271725490.3318@localhost>
 <alpine.LFD.2.00.1004270833530.3739@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 Apr 2010, Linus Torvalds wrote:

> 
> 
> On Tue, 27 Apr 2010, John Kacur wrote:
> >
> > You can ask Linus whether he'll take a convert unlocked_ioctl now or not.
> 
> Absolutely not.
> 
> I could imagine merging something like just the bkl_ioctl rename: if it 
> breaks, it won't compile, so there is little risk, and _if_ it helps the 
> next merge window I could merge it early.
> 
> But it looks like people are trying to avoid it entirely, and there is not 
> a way in *hell* I will take some big and scary "push BKL down" patch that 
> is clearly _not_ 99% mechanical and clearly _can_ introduce major and 
> subtle bugs while compiling. 
> 

Heh, that's exactly what I thought you would say, but still good to 
clarify it for everyone.

John 
