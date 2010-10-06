Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467Ab0JFC5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 22:57:01 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53104 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab0JFC5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 22:57:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GdpBVHhMKaRZaaBs6XbLyAYOu61TaVU6UxErbA/Ci8JHl1q7C7zFqM/edUTEo+qgaT
         I5rYLdzmLbUS7rPY6YYvqtH9jzDoqkWvt/JGp6HO8nAjDLjzJ8vweDDmlgIeLEaCAXJz
         kIpJ5r8PCM+t8n+2Qgm0UAtURjCNDvYf5aRxg=
Subject: Re: [GIT PULL] core kernel fixes
From: Eric Dumazet <eric.dumazet@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20101005220546.GS2369@linux.vnet.ibm.com>
References: <20101005191223.GA31795@elte.hu>
	 <AANLkTik9E0dr=Qah0d_+9YaAsA7WfeawA1c4oDbiJK-j@mail.gmail.com>
	 <20101005210904.GQ2369@linux.vnet.ibm.com>
	 <AANLkTi==ZE7+PTPdB1JjdSdqus0Ox+rjTAxMMMJk0fBi@mail.gmail.com>
	 <20101005220546.GS2369@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 04:56:54 +0200
Message-ID: <1286333814.4861.9.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 05 octobre 2010 à 15:05 -0700, Paul E. McKenney a écrit :
> On Tue, Oct 05, 2010 at 02:45:07PM -0700, Linus Torvalds wrote:
> > On Tue, Oct 5, 2010 at 2:09 PM, Paul E. McKenney
> > <paulmck@linux.vnet.ibm.com> wrote:
> > >
> > > Good point!!!  If the following diff looks good to you, I will get it
> > > tested and pushed.
> > 
> > Looks good. Except since I pulled the thing despite my complaint,
> > you'll also need to undo the extra irqs_disabled() test.
> 
> No problem, the diff I sent you combined two commits.  ;-)
> 

Hi Paul & Linus

I originally considered adding the test in rcu_read_lock_bh_held() too,
but thought (wrongly) :

	"rcu_read_unlock_bh() doesnt block hard IRQ, thus
	 rcu_read_lock_bh_held() should not test hard irq."

I remember anyway my first patch was wrong, since I was not using
irqs_disabled() but in_irq() 

http://kerneltrap.org/mailarchive/linux-kernel/2010/9/22/4622784

Thanks !


