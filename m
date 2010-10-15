Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab0JOPHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 11:07:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45378 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334Ab0JOPHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 11:07:38 -0400
X-User-Agent: K-9 Mail for Android
References: <cbd8b37e-a1a3-4275-8acb-a76476211366@email.android.com> <alpine.DEB.2.00.1010131832400.794@chino.kir.corp.google.com> <4CB688F4.9040706@zytor.com> <alpine.DEB.2.00.1010132140550.20995@chino.kir.corp.google.com> <4CB7240E.9000905@zytor.com> <AANLkTin-VOKXe6wcwt_r3bLcS6=WYJ4EAPPUZWLbEGQF@mail.gmail.com> <4CB7418C.7010505@zytor.com> <20101014183448.GA3187@elte.hu> <20101014123511.d628f873.akpm@linux-foundation.org> <1bdcb8fa-d858-4a79-ae28-de8c94d13f5f@email.android.com> <20101015030336.GB9640@elte.hu> <alpine.DEB.2.00.1010150154510.8103@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1010150154510.8103@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [patch] x86: allow ZONE_DMA to be configurable
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 15 Oct 2010 08:06:15 -0700
To: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Casey Dahlin <cdahlin@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <35610cef-d2f0-455f-a2d1-d9cb3435482b@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, those exceptions should be factored out and put under a separate suboption... CONFIG_SMALLMEM or so.

"David Rientjes" <rientjes@google.com> wrote:

>On Fri, 15 Oct 2010, Ingo Molnar wrote:
>
>> Also, historically we have not been moving kconfig variables in and out 
>> of CONFIG_EMBEDDED all that often for this to be an issue in the future.
>> 
>
>There are also kconfig options that depend on EMBEDDED that are actually 
>for embedded or very small systems; the most obvious example that comes to 
>mind is SLOB.  Simply doing an s/EMBEDDED/EXPERT/ conversion seems 
>appropriate given the semantics for the option that Peter gave, but there 
>are exceptions that will need to be identified, and I think SLOB is one of 
>them.
>
>I don't think we need a kconfig _dependency_ that exists solely to 
>identify other config options for a specific field of hardware, but then 
>we leave a burden for those users to identify the correct options that 
>they need for their configurations that was, I'm assuming, the original 
>intent of CONFIG_EMBEDDED in the first place.  So perhaps we can allow an 
>option for small embedded systems that can "select" other options when 
>enabled but don't have strict "depends" requirements?
>
>I had a thread with Matt Mackall about a year and a half ago on LKML about 
>the meaning of CONFIG_EMBEDDED and its use for the SLOB allocator; it 
>would be much better for us to identify systems with memory limitations 
>that strive to reduce footprint as much as possible to automatically 
>select certain options over others.  I believe we talked about SLOB being 
>the default for systems with under 16MB of memory, but we have limited 
>ability to identify that for the user.

-- 
Sent from my mobile phone.  Please pardon any lack of formatting.
