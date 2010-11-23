Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab0KWKFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 05:05:50 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:1694 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751572Ab0KWKFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 05:05:49 -0500
X-IronPort-AV: E=Sophos;i="4.59,241,1288566000"; 
   d="scan'208";a="80751857"
Message-ID: <4CEB91FA.3040209@inria.fr>
Date: Tue, 23 Nov 2010 11:05:46 +0100
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101030 Icedove/3.0.10
MIME-Version: 1.0
To: Christopher Yeoh <cyeoh@au1.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH] Cross Memory Attach v2 (resend)
References: <20101122122847.3585b447@lilo> <20101122130527.c13c99d3.akpm@linux-foundation.org> <20101123195523.46e6addb@lilo>
In-Reply-To: <20101123195523.46e6addb@lilo>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 23/11/2010 10:25, Christopher Yeoh a écrit :
> On Mon, 22 Nov 2010 13:05:27 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
>   
>> We have a bit of a track record of adding cool-looking syscalls and
>> then regretting it a few years later.  Few people use them, and maybe
>> they weren't so cool after all, and we have to maintain them for
>> ever. Bugs (sometimes security-relevant ones) remain undiscovered for
>> long periods because few people use (or care about) the code.
>>
>> So I think the bar is a high one - higher than it used to be.
>> Convince us that this feature is so important that it's worth all
>> that overhead and risk?
>>     
> Well there are the benchmark results to show that there is
> real improvement for MPI implementations (well at least for those
> benchmarks ;-) There's also been a few papers written on something
> quite similar (KNEM) which goes into more detail on the potential gains.
>
> http://runtime.bordeaux.inria.fr/knem/
>
> I've also heard privately that something very similar has been used in
> at least one device driver to support intranode operations for quite a
> while
>   

Many HPC hardware vendors implemented something like this in their
custom drivers to avoid going through their network loopback for local
communication. Even if their loopback is very fast, going to the NIC and
back to same host isn't really optimal. And I think all of them kept the
traditional approach (double-copy across a shared-memory buffer) for
small messages and only switched to this single-copy model for large
messages (tens or hundreds of kB). CMA and KNEM are "standardizing" all
this work and making it portable across multiple HPC platform/networks.

Brice

