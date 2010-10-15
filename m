Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab0JOJFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 05:05:44 -0400
Received: from smtp-out.google.com ([216.239.44.51]:55903 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab0JOJFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 05:05:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=dAUSz0Ob4uJyUtWJc56q27AWVkL/bN/mcTY/Xyus59vnJxd+ba5PzoEx7jngSzRKbG
         b1KTAq459ikXgvEtCDDw==
Date: Fri, 15 Oct 2010 02:05:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Casey Dahlin <cdahlin@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] x86: allow ZONE_DMA to be configurable
In-Reply-To: <20101015030336.GB9640@elte.hu>
Message-ID: <alpine.DEB.2.00.1010150154510.8103@chino.kir.corp.google.com>
References: <cbd8b37e-a1a3-4275-8acb-a76476211366@email.android.com> <alpine.DEB.2.00.1010131832400.794@chino.kir.corp.google.com> <4CB688F4.9040706@zytor.com> <alpine.DEB.2.00.1010132140550.20995@chino.kir.corp.google.com> <4CB7240E.9000905@zytor.com>
 <AANLkTin-VOKXe6wcwt_r3bLcS6=WYJ4EAPPUZWLbEGQF@mail.gmail.com> <4CB7418C.7010505@zytor.com> <20101014183448.GA3187@elte.hu> <20101014123511.d628f873.akpm@linux-foundation.org> <1bdcb8fa-d858-4a79-ae28-de8c94d13f5f@email.android.com>
 <20101015030336.GB9640@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Oct 2010, Ingo Molnar wrote:

> Also, historically we have not been moving kconfig variables in and out 
> of CONFIG_EMBEDDED all that often for this to be an issue in the future.
> 

There are also kconfig options that depend on EMBEDDED that are actually 
for embedded or very small systems; the most obvious example that comes to 
mind is SLOB.  Simply doing an s/EMBEDDED/EXPERT/ conversion seems 
appropriate given the semantics for the option that Peter gave, but there 
are exceptions that will need to be identified, and I think SLOB is one of 
them.

I don't think we need a kconfig _dependency_ that exists solely to 
identify other config options for a specific field of hardware, but then 
we leave a burden for those users to identify the correct options that 
they need for their configurations that was, I'm assuming, the original 
intent of CONFIG_EMBEDDED in the first place.  So perhaps we can allow an 
option for small embedded systems that can "select" other options when 
enabled but don't have strict "depends" requirements?

I had a thread with Matt Mackall about a year and a half ago on LKML about 
the meaning of CONFIG_EMBEDDED and its use for the SLOB allocator; it 
would be much better for us to identify systems with memory limitations 
that strive to reduce footprint as much as possible to automatically 
select certain options over others.  I believe we talked about SLOB being 
the default for systems with under 16MB of memory, but we have limited 
ability to identify that for the user.
