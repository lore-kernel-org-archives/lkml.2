Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab0GEL6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 07:58:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55682 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab0GEL6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 07:58:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :user-agent;
        b=U6K86Jj1nWoVgEkunFZ0uUG4By3yyLhX7qR5T7AunjooHxzOPyGxCmn8wDy3t8s7Cf
         wKODilUldvagWsTIlDRuu7t+eou2+zUF4uRoYaVqLJyCWNuvdVV3AzSFTYcrNjCtC5X3
         WjIN4OlXUzrqGkQTk5WKCc9tGcPtlW/qwRa+Q=
Date: Mon, 05 Jul 2010 11:38:14 +0000
From: Ali Gholami Rudi <ali@rudi.ir>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, dfeng@redhat.com, x86@kernel.org,
       venki@google.com, tglx@linutronix.de, suresh.b.siddha@intel.com,
       mingo@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [regression] commit 6a4f3b52 causes invalid memtype
Message-ID: <20100507113814@tarekhel>
In-Reply-To: <20100705104035.GA28190@elte.hu>
References: <20100507075128@tarekhel>
 <4C319D61.5090002@redhat.com>
 <20100507092842@tarekhel>
 <4C31A7A0.1020800@redhat.com>
 <4c31ac7b.J+CU0Yt+zKZ9ho1fjKvu6Z1v@tarekhel>
	<20100705104035.GA28190@elte.hu>
User-Agent: git://repo.or.cz/mailx.git
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:
> > > >> commit 2463eb8b3093995e09a0d41b3d78ee0cf5fb4249
> > > >> Author: Peter Zijlstra<peterz@infradead.org>
> > > >> Date:   Sat May 29 15:31:43 2010 +0200
> > > >>
> > > >>       rbtree: Undo augmented trees performance damage
> > > >
> > > > Where can I get it?  I couldn't find it either in
> > > > Linus' or x86 repo tip.
> > > http://git.kernel.org/tip/2463eb8b3093995e09a0d41b3d78ee0cf5fb4249
> > 
> > It does fix it.
> 
> Hm, interesting. That's a pure performance fix - so why does it fix a 
> regression?
> 
> Does Peter's augmented rbtrees improvements fix a bug too, as a side-effect? 
> If yes then we need to accelerate that commit - right now it's aimed for 
> v2.6.36.

Since the bug appears after commit 6a4f3b52, it seems to be
related to the value of memtype->subtree_max_end.  Peter's
patch seems to change the way memtype->subtree_max_end is
updated, which seems to fix the problem too.

Thanks,
Ali

