Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab1EQJcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 05:32:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661Ab1EQJcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 05:32:52 -0400
Message-ID: <4DD2409F.4030800@redhat.com>
Date: Tue, 17 May 2011 12:32:15 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2 0/4] Enable SMEP CPU Feature
References: <1305581685-5144-1-git-send-email-fenghua.yu@intel.com> <4DD19C81.8000902@zytor.com> <20110517070527.GD22305@elte.hu> <4DD23CB6.3050503@redhat.com> <20110517092903.GJ22093@elte.hu>
In-Reply-To: <20110517092903.GJ22093@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2011 12:29 PM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
> >  >  Some programmable configurability seems necessary on the KVM side, as KVM
> >  >  has no control over how sane the guest kernel is.
> >
> >  We should simply expose the cpuid bit and cr4.smep.  If the guest kernel
> >  feels it is up to it, it can enable smep itself.
>
> Well, given that there's lots of legacy installations around it would be a neat
> KVM feature if it was possible to enable SMEP even if the guest kernel does not
> enable it. As an additional (optional) layer of security.
>
> For example legacy Linux guests will work just fine, even if they do not enable
> SMEP themselves.

It's certainly possible (set CR4.SMEP transparently and hide it from the 
guest).  But there's no way to tell if it doesn't break something 
wierd.  The host might not even know if the guest is Linux or something 
else.

We could support it as a non-default feature, but that reduces its utility.

-- 
error compiling committee.c: too many arguments to function

