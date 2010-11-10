Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab0KJOtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:49:22 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:41499 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353Ab0KJOtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 09:49:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kTtTVrDHQu+s95/tnf+w+7iGLBoJaaQNAYb2h42HOez2cRxKjtvemYII+1zpVsx15i
         29lg5MTcYt7CozCvKDD6RhBQkt4fI19ri5MB1Qna3OWTu+0b1XcjlI5LRauBD0CBVE9P
         76WT3l4Ci8fYT9yTliXN2WROh4AvQzCpgP6ZQ=
Subject: Re: [PATCH v2]mm/oom-kill: direct hardware access processes should
 get bonus
From: "Figo.zhang" <figo1802@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1011091307240.7730@chino.kir.corp.google.com>
References: <1288662213.10103.2.camel@localhost.localdomain>
	 <1289305468.10699.2.camel@localhost.localdomain>
	 <alpine.DEB.2.00.1011091307240.7730@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 22:48:16 +0800
Message-ID: <1289400496.10699.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 13:16 -0800, David Rientjes wrote:
> On Tue, 9 Nov 2010, Figo.zhang wrote:
> 
> >  
> > the victim should not directly access hardware devices like Xorg server,
> > because the hardware could be left in an unpredictable state, although 
> > user-application can set /proc/pid/oom_score_adj to protect it. so i think
> > those processes should get 3% bonus for protection.
> > 
> 
> The logic here is wrong: if killing these tasks can leave hardware in an 
> unpredictable state (and that state is presumably harmful), then they 
> should be completely immune from oom killing since you're still leaving 
> them exposed here to be killed.

we let the processes with hardware access get bonus for protection. the
goal is not select them to be killed as possible.


> 
> So the question that needs to be answered is: why do these threads deserve 
> to use 3% more memory (not >4%) than others without getting killed?  If 
> there was some evidence that these threads have a certain quantity of 
> memory they require as a fundamental attribute of CAP_SYS_RAWIO, then I 
> have no objection, but that's going to be expressed in a memory quantity 
> not a percentage as you have here.
> 
> The CAP_SYS_ADMIN heuristic has a background: it is used in the oom killer 
> because we have used the same 3% in __vm_enough_memory() for a long time 
> and we want consistency amongst the heuristics.  Adding additional bonuses 
> with arbitrary values like 3% of memory for things like CAP_SYS_RAWIO 
> makes the heuristic less predictable and moves us back toward the old 
> heuristic which was almost entirely arbitrary.


yes, i think it is be better those processes which be protection maybe
divided the badness score by 4, like old heuristic.




