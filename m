Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934062Ab1CYJiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 05:38:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36397 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab1CYJiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 05:38:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Z+DMfboCPMjguaT7G9ljr3VnK50RwTiGBXt+VlS7jfkv/a7YV10hcgsTBjeDNpXOdn
         g87K8hRIbZgaBtebFNo9XVN3l0Zgmn9AVa2sM7bufJHdA3n5ME8ix9cTx5NKynyDssz8
         i/2porBCuUAoAATr/tUKSNYDLmMc8AIogQROo=
Subject: Re: [PATCH RFC] x86: avoid atomic operation in
 test_and_set_bit_lock if possible
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>,
        Jan Beulich <JBeulich@novell.com>, Borislav Petkov <bp@amd64.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@kernel.dk>, "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, tee@sgi.com,
        Nikanth Karthikesan <knikanth@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1301032040.2714.569.camel@edumazet-laptop>
References: <20110324085647.GI30812@elte.hu> <20110324145221.GC31194@aftab>
	 <4D8B83DA02000078000381DE@vpn.id2.novell.com>
	 <20110324173020.GA26761@sgi.com> <20110324200010.GB7957@elte.hu>
	 <1300999682.2714.23.camel@edumazet-laptop> <20110324205422.GB2393@elte.hu>
	 <1301000557.2714.33.camel@edumazet-laptop> <m2oc50kxg0.fsf@firstfloor.org>
	 <AANLkTimib3TqemF9L=VNkcXT3uFam1gYmVtuA3wrAv1j@mail.gmail.com>
	 <20110324235654.GM21838@one.firstfloor.org>
	 <1301032040.2714.569.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 10:38:02 +0100
Message-ID: <1301045882.3268.2.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 25 mars 2011 à 06:47 +0100, Eric Dumazet a écrit :

> I tried many different changes in BIOS and all failed (the machine is
> damn slow at boot, this takes age).

I even tried on a more recent hardware (ProLiant BL460c G7)

BIOS :	Version: I27  Release Date: 09/30/2010

[    0.021849] CPU0: Intel(R) Xeon(R) CPU           E5640  @ 2.67GHz stepping 02
[    0.123904] Performance Events: PEBS fmt1+, Westmere events, Broken BIOS detected, using software events only.
[    0.124125] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR 38d is 330)

I guess I'll have to patch my kernel, I doubt HP will make any change in this area.


