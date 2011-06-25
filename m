Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713Ab1FYNJo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 09:09:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55448 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab1FYNJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 09:09:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: [PATCH] modules: add default loader hook implementations
Date: Sat, 25 Jun 2011 15:08:49 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        monstr@monstr.eu, cmetcalf@tilera.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <1308987512-6583-1-git-send-email-jonas@southpole.se> <20110625100449.GA19097@elte.hu> <1308998367.6699.30.camel@localhost>
In-Reply-To: <1308998367.6699.30.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106251508.50129.arnd@arndb.de>
X-Provags-ID: V02:K0:tCucPkWQt9GUPJHLgh+ctSHx0BBG9lqcrZ4wtPkWgEy
 S6DB1MHgAW9qg62JT/HJobqWOjWLct+GvfKHoUChY/sl5/qZke
 g4psP7PBDcApS/EJjMcoHQii7G2IHlFZdP3NggijvMC7//BejL
 C01NRSZvdyaWRx0dYGVFVwo46e87qf06ZoP9jkRZJXHp6E0aZf
 9AdzeTo8NONkiDS0aVTJg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 June 2011, Jonas Bonn wrote:
> On Sat, 2011-06-25 at 12:04 +0200, Ingo Molnar wrote:
> > Also, and more importantly, don't we generally do such things via 
> > __weak aliases, because the result looks cleaner and needs no changes 
> > for architectures beyond the removal of the generic functions? We 
> > have excluded broken toolchains that miscompile/mislink __weak IIRC 
> > so __weak ought to work.
> 
> When we discussed this briefly yesterday, both Rusty and Arnd showed a
> preference for not using __weak aliases... I'll leave it to them to
> comment further.
> 
> The alternative patch that just provides __weak implementations for
> these hooks is much less invasive than the patch I sent, effectively
> touching only kernel/module.c
> 
> Let me know which is preferable.

I don't care much either way, you would get my Ack for both solutions.
The __weak approach would definitely make a simpler patch, and the
patch you sent adds extra complexity because of the
asm_generic_moduleloader_hooks macro you used to avoid having to
change all other architectures.

	Arnd
