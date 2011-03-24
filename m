Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934327Ab1CXVCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 17:02:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56265 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341Ab1CXVCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 17:02:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=eBgU77xNBZRE4bDkv07Pec5Co28hNimxtrL+zRNwxD0A4hhC5FgxYGa5gJOj8trlCq
         r3no7tFRWPtFsE4X6zpq7ji0kNjEs78zgMHwfktBS1drstC/Ynj33FP6FLucvtyJzomi
         sh9pNXOGXSOL4gJ+KTfIrp29IvRi18Whh8pQs=
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
In-Reply-To: <20110324205422.GB2393@elte.hu>
References: <201103241026.01624.knikanth@suse.de>
	 <20110324085647.GI30812@elte.hu> <20110324145221.GC31194@aftab>
	 <4D8B83DA02000078000381DE@vpn.id2.novell.com>
	 <20110324173020.GA26761@sgi.com> <20110324200010.GB7957@elte.hu>
	 <1300999682.2714.23.camel@edumazet-laptop>  <20110324205422.GB2393@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 22:02:37 +0100
Message-ID: <1301000557.2714.33.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 24 mars 2011 à 21:54 +0100, Ingo Molnar a écrit :

> Does it work better if you run it as root?
> 

I confess I always am root on my dev machines :(

> To easiest way to debug as user is to do:
> 
>   echo -1 > /proc/sys/kernel/perf_event_paranoid 
> 
> and to put this into /etc/sysctl.conf:
> 
>   kernel.perf_event_paranoid = -1
> 


Hmm... on one machine (HP BL460c G1 ) I do have :

[    0.015998] Performance Events: PEBS fmt0+, Core2 events, Broken BIOS detected, using software events only.
[    0.015998] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR 186 is 43003c)


and the other one (HB BL460c G6)

[    0.122760] Performance Events: PEBS fmt1+, Nehalem events, Broken BIOS detected, using software events only.
[    0.123047] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR 38d is 330)


Hmm.. I have latest HP BIOS.

Version: I15
Release Date: 10/25/2010

and

Version: I24
Release Date: 09/02/2010

I am pretty sure I used "-e ..." some time ago with same BIOS.



