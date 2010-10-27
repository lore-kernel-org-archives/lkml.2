Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213Ab0J0Oj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 10:39:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58857 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189Ab0J0Ojy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 10:39:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=m4+od8Gapi3Vd1RB/teD7Ka1rIEac0L1MZbCIo3OScO3RaXAlvg9mCJpBVxbmXDC0B
         mhpqy5pX6+F5HCGztAqYN0hIBZjveTxMFQZLO2eursBCvfx7fLUjUFbKs/P18vd7e4kN
         s4qLR0N33Or0oWvCiMmsxejNoL3/IVckpLdx4=
Subject: Re: [PATCH] x86-32: Allocate irq stacks seperate from percpu area
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Brian Gerst <brgerst@gmail.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, mingo@elte.hu
In-Reply-To: <1288189461.2709.144.camel@edumazet-laptop>
References: <AANLkTinnc3vBSmewf7ixuOSDYxG+5VNiGaB-vSrDNRiO@mail.gmail.com>
	 <1288158182-1753-1-git-send-email-brgerst@gmail.com>
	 <1288159670.2652.181.camel@edumazet-laptop>
	 <1288173442.15336.1490.camel@twins>
	 <1288186405.2709.117.camel@edumazet-laptop>  <4CC82C2F.1020707@kernel.org>
	 <1288187870.2709.128.camel@edumazet-laptop>  <4CC83067.5000009@kernel.org>
	 <1288189461.2709.144.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Oct 2010 16:39:47 +0200
Message-ID: <1288190387.2709.147.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 27 octobre 2010 à 16:24 +0200, Eric Dumazet a écrit :
> Le mercredi 27 octobre 2010 à 16:00 +0200, Tejun Heo a écrit :
> 
> > Heh, interesting table.  What does the same code say on 64bit?  Is it
> > the same?
> > 
> 
> Yes this is the same

Oops sorry :!)

On 64bit kernel, the 16 'possible but not online' cpus are not on node
0, but balanced between two nodes.

cpu=0 node=1
cpu=1 node=0
cpu=2 node=1
cpu=3 node=0
cpu=4 node=1
cpu=5 node=0
cpu=6 node=1
cpu=7 node=0
cpu=8 node=1
cpu=9 node=0
cpu=10 node=1
cpu=11 node=0
cpu=12 node=1
cpu=13 node=0
cpu=14 node=1
cpu=15 node=0
cpu=16 node=0
cpu=17 node=1
cpu=18 node=0
cpu=19 node=1
cpu=20 node=0
cpu=21 node=1
cpu=22 node=0
cpu=23 node=1
cpu=24 node=0
cpu=25 node=1
cpu=26 node=0
cpu=27 node=1
cpu=28 node=0
cpu=29 node=1
cpu=30 node=0
cpu=31 node=1


