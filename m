Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab0JOEpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 00:45:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54736 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab0JOEpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 00:45:50 -0400
Message-ID: <4CB7DC58.2090902@zytor.com>
Date: Thu, 14 Oct 2010 21:45:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Casey Dahlin <cdahlin@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] x86: allow ZONE_DMA to be configurable
References: <cbd8b37e-a1a3-4275-8acb-a76476211366@email.android.com> <alpine.DEB.2.00.1010131832400.794@chino.kir.corp.google.com> <4CB688F4.9040706@zytor.com> <alpine.DEB.2.00.1010132140550.20995@chino.kir.corp.google.com> <4CB7240E.9000905@zytor.com> <AANLkTin-VOKXe6wcwt_r3bLcS6=WYJ4EAPPUZWLbEGQF@mail.gmail.com> <4CB7418C.7010505@zytor.com> <20101014183448.GA3187@elte.hu> <20101014123511.d628f873.akpm@linux-foundation.org> <1bdcb8fa-d858-4a79-ae28-de8c94d13f5f@email.android.com> <20101015030336.GB9640@elte.hu>
In-Reply-To: <20101015030336.GB9640@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2010 08:03 PM, Ingo Molnar wrote:
> 
> Dunno, that i'd consider more of a bug. If an architecture absolutely 
> needs to configure in or out a kernel feature then it should not be 
> under CONFIG_EXPERT on other architectures either: it only sets us up 
> for cross-arch build failures if say the CONFIG_EXPERT dependency is 
> present on x86.
> 

Well, no, it really rather makes sense.

Consider something like CONFIG_SERIO_I8042 -- that is very much an
EXPERT option to remove on x86, but on a lot of other platforms it is
Just Another Interface.

So I think CONFIG_EXPERT_ will just encourage people to do strange
things and reduces flexibility.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

