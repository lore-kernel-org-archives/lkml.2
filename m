Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab0G2KKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 06:10:31 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:56706 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756180Ab0G2KK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 06:10:27 -0400
Message-ID: <4C51538C.1090803@bfs.de>
Date: Thu, 29 Jul 2010 12:10:20 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Vasiliy Kulikov <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] x86: mce: fix error handling
References: <1280335185-23265-1-git-send-email-segooon@gmail.com> <4C5063D4.4070108@linux.intel.com> <20100728171327.GA24149@albatros> <4C5066CB.7010009@linux.intel.com> <20100729093511.GB7143@albatros> <4C514F04.80603@linux.intel.com>
In-Reply-To: <4C514F04.80603@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andi Kleen schrieb:
> 
>> IMO memmory allocation fails are dangerous in kernel mode. As it is
>> probably not exploitable because of boot time, it can destroy some
>> sensitive data like dirty disk caches those are going to be written on
>> disk.
> 
> It's true for runtime, but not for normal boot time.
> 
> Anyways if it happens on boot time the only thing you can do is panic,
> but someone else
> will likely panic anyways for you. Just ignoring it like your patch
> effectively does
> (because nothing will ever look at the ENOMEMs for an initcall) is wrong
> though
> In this case it's actually better to oops like the original code does.
> 
> BTW even with your patch likely later code will crash anyways because it
> doesn't
> expect init code to fail.
> 

NTL it is nice to have a error message. for users it is worse if you crash suddenly
with out warning than having a crash with "OOM" before because it gives you a clue
what is going on.
short:
please think of users that are not kernel developers give them a hint what went wrong.

to make thinks more easy on boot we could replace kalloc() with kmalloc_or_die().
When anyone runs out of mem on boottime you can panic() instantly.

just my to cents,
 wh

