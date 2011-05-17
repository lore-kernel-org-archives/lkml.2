Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab1EQJQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 05:16:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232Ab1EQJQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 05:16:45 -0400
Message-ID: <4DD23CB6.3050503@redhat.com>
Date: Tue, 17 May 2011 12:15:34 +0300
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
References: <1305581685-5144-1-git-send-email-fenghua.yu@intel.com> <4DD19C81.8000902@zytor.com> <20110517070527.GD22305@elte.hu>
In-Reply-To: <20110517070527.GD22305@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2011 10:05 AM, Ingo Molnar wrote:
> * H. Peter Anvin<hpa@zytor.com>  wrote:
>
> >  On 05/16/2011 02:34 PM, Fenghua Yu wrote:
> >  >
> >  >  Note: This patch set doesn't enable the SMEP feature in KVM. If it's needed,
> >  >  another patch will be pushed for enabling the feature in KVM.
> >  >
> >
> >  Hi Avi,
> >
> >  Could you comment on if this needs to be a gating factor?

It should certainly not be a gating factor.  Note that smep will be 
disabled when switching to the guest, so there are no compatibility issues.

> I think KVM would benefit from the native kernel playing guinea pig whether
> SMEP is really, truly 100% trouble-free to enable by default (for Linux) ;-)
>
> Some programmable configurability seems necessary on the KVM side, as KVM has
> no control over how sane the guest kernel is.

We should simply expose the cpuid bit and cr4.smep.  If the guest kernel 
feels it is up to it, it can enable smep itself.

-- 
error compiling committee.c: too many arguments to function

