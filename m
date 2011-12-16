Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759934Ab1LPPeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 10:34:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49074 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab1LPPeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 10:34:08 -0500
Message-ID: <4EEB6479.8010500@zytor.com>
Date: Fri, 16 Dec 2011 07:32:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jan Beulich <JBeulich@suse.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Alexander van Heukelum <heukelum@fastmail.fm>, fweisbec@gmail.com,
        Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Use -m-omit-leaf-frame-pointer to shrink text size
References: <20111216081915.GA28288@elte.hu> <20111216085259.GA2338@elte.hu> <4EEB0E14.9050505@goop.org> <4EEB3D8B0200007800068759@nat28.tlf.novell.com> <20111216120001.GA27801@elte.hu>
In-Reply-To: <20111216120001.GA27801@elte.hu>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2011 04:00 AM, Ingo Molnar wrote:
>>
>> Are you sure about that even if the leaf function uses rBP for 
>> a different purpose?
> 
> Well, i assumed that GCC does not mess with %bp in leaf 
> functions - a frame pointer is barely useful if it's destroyed 
> spuriously in leaf functions.
> 

We should verify that explicitly.  gcc has every "right" to treat it as
a normal callee-saved register, but I think it is a very low priority
register in gcc's register allocation scheme.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

