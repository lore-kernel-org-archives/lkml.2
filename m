Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020Ab1FGTG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 15:06:27 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58104 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab1FGTGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 15:06:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZtMR732+FxG2ptDx2Ko8oMHWB9x+WjmttRZwoTTVwJYwMC3P09Y8Z1a0hd8AWrWNTm
         jA8KLBcGP8ZcWQ9NaCTpjSKtjC6LuvTkN1ogO+eFhr73oz1fc6PGg0UkQGRZhdQKM1P4
         KEtm8dvl1Z/MvAY67cESnYiKYzxYMjs7SHMos=
Subject: Re: Change in functionality of futex() system call.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Oliver <david@rgmadvisors.com>, linux-kernel@vger.kernel.org,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Zachary Vonler <zvonler@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTinyuHUGXACJYUT241g8rzg6AzPBiA@mail.gmail.com>
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>
	 <1307373819.3098.40.camel@edumazet-laptop>
	 <1307376672.2322.167.camel@twins> <1307376989.2322.171.camel@twins>
	 <1307377349.3098.65.camel@edumazet-laptop>
	 <1307377782.2322.183.camel@twins>
	 <1307378564.3098.67.camel@edumazet-laptop>
	 <4DED1421.5000300@linux.intel.com>
	 <1307383898.3098.90.camel@edumazet-laptop> <4DED976C.90009@linux.intel.com>
	 <4DEE3944.5020005@mit.edu> <1307462300.3091.39.camel@edumazet-laptop>
	 <BANLkTinyuHUGXACJYUT241g8rzg6AzPBiA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jun 2011 21:06:21 +0200
Message-ID: <1307473581.3091.61.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 07 juin 2011 à 14:43 -0400, Andrew Lutomirski a écrit :

> I have some software I'm working on that uses shared files and could
> easily use futexes.  I don't want random read-only processes to
> interfere with the futex protocol.

Relying on kernel doing 'the right thing for you' wont work on old
kernels. Some people still want to run 2.6.18 ones, for very good
reasons. Also this 'magical protection' is not documented on man pages,
so this is would be a bad choice.

Regression being one year old, you can bet many machines run with
previous behavior (safe too, unless your application design is not
secured)

> There's a difference between slowing down users by abusing a kernel
> hash and deadlocking users by eating a wakeup.  (If you eat a wakeup
> the wakeup won't magically come back later.  It's gone.)

Sure, you could let messages queues, named pipes, being readable as
well. Or your files being writeable, who knows, and lost your data too.

I dont know why I even discuss the point. A regression was added, you
cant justify it saying futexes were insecure from 2002 to 2010.



