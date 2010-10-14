Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab0JNTg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 15:36:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755000Ab0JNTg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 15:36:27 -0400
Date: Thu, 14 Oct 2010 12:35:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Casey Dahlin <cdahlin@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] x86: allow ZONE_DMA to be configurable
Message-Id: <20101014123511.d628f873.akpm@linux-foundation.org>
In-Reply-To: <20101014183448.GA3187@elte.hu>
References: <alpine.DEB.2.00.1010131739010.27124@chino.kir.corp.google.com>
	<4CB65262.3070507@zytor.com>
	<alpine.DEB.2.00.1010131744540.27124@chino.kir.corp.google.com>
	<cbd8b37e-a1a3-4275-8acb-a76476211366@email.android.com>
	<alpine.DEB.2.00.1010131832400.794@chino.kir.corp.google.com>
	<4CB688F4.9040706@zytor.com>
	<alpine.DEB.2.00.1010132140550.20995@chino.kir.corp.google.com>
	<4CB7240E.9000905@zytor.com>
	<AANLkTin-VOKXe6wcwt_r3bLcS6=WYJ4EAPPUZWLbEGQF@mail.gmail.com>
	<4CB7418C.7010505@zytor.com>
	<20101014183448.GA3187@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Oct 2010 20:34:48 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > On 10/14/2010 09:00 AM, Pekka Enberg wrote:
> >
> > >> CONFIG_EMBEDDED *is* "I am a user who (think I) know what I'm 
> > >> doing". That is *what it is* and *all it is*.
> > > 
> > > Yup. The naming is quite unfortunate, though. Can we change it to 
> > > something else?
> > 
> > Funny, this seems to come up repeatedly ;)
> 
> I'd suggest to rename CONFIG_EMBEDDED=y to CONFIG_EXPERT=y, but i'd also 
> suggest to rename all sub-config-options that depend on CONFIG_EXPERT to 
> have a CONFIG_EXPERT_ prefix.
> 
> So we'd have:
> 
>   CONFIG_EXPERT_CPU_SUP_INTEL=y
>   CONFIG_EXPERT_MMAP_ALLOW_UNINITIALIZED=y
> 
> etc.

yup.  CONFIG_EMBEDDED didn't make a lot of sense even when we first did it. 
I suppose CONFIG_EXPERT is OK, although everyone will select it because
they think they're experts ;)  CONFIG_PROPELLORHEAD!

> That way all the enabled 'expert options' become easily visible in the 
> .config file and they advertise themselves properly - it's also easily 
> greppable. In the source code it also becomes self-documenting, it's 
> obvious when a dependency is 'rare' or 'special' - it has a 
> CONFIG_EXPERT_ prefix.
> 
> Something for the KS i guess.

nah, just do it.
