Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934299Ab1CXUvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:51:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61539 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934262Ab1CXUvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:51:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vyarI+EJn5wNCVQqgNcGVHh5UKA1MA3IT+XPAr7Z2OkcU3NCoxra+4X3bYvem5zmSP
         dVgwYOA5B4lNfrRygJr9L8OhbkmPhsOr4iHFhCkJrkquKVwm4w7s3J7b2Ex76xA1NLcj
         xhXmk5kfwZG3dCIUwY3TAUPJY6RAKqN1Yh1sE=
Subject: Re: [PATCH RFC] x86: avoid atomic operation in
 test_and_set_bit_lock if possible
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jack Steiner <steiner@sgi.com>, Jan Beulich <JBeulich@novell.com>,
        Borislav Petkov <bp@amd64.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@kernel.dk>, "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, tee@sgi.com,
        Nikanth Karthikesan <knikanth@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20110324200010.GB7957@elte.hu>
References: <201103241026.01624.knikanth@suse.de>
	 <20110324085647.GI30812@elte.hu> <20110324145221.GC31194@aftab>
	 <4D8B83DA02000078000381DE@vpn.id2.novell.com>
	 <20110324173020.GA26761@sgi.com>  <20110324200010.GB7957@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 21:48:02 +0100
Message-ID: <1300999682.2714.23.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 24 mars 2011 à 21:00 +0100, Ingo Molnar a écrit :

> One good way to see cache bounces is to run a misses/accesses ratio profile:
> 
>    perf top -e cache-misses -e cache-references --count-filter 10
> 

Oh well , something must be broken...

"perf top" is working here, but if I use any "-e ...." argument, it
fails :

# perf top -e cache-misses

  Error: sys_perf_event_open() syscall returned with 2 (No such file or directory).
  /bin/dmesg may provide additional information.

  Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?

# grep PERF_EVENTS .config
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_EVENTS=y
CONFIG_HAVE_PERF_EVENTS_NMI=y

Nothing in dmesg...

uname -a
Linux ed001 2.6.38-08165-g2712750-dirty #517 SMP Thu Mar 24 21:31:00 CET 2011 i686 i686 i386 GNU/Linux



