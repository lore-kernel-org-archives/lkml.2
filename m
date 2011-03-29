Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab1C2P2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 11:28:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39389 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab1C2P2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 11:28:16 -0400
Message-ID: <4D91FA76.1010908@zytor.com>
Date: Tue, 29 Mar 2011 08:27:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
CC: Brian Gerst <brgerst@gmail.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        "eranian@google.com" <eranian@google.com>,
        "Richter, Robert" <robert.richter@amd.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [RFC v2 8/8] x86, xsave: remove lazy allocation of xstate area
References: <1299698102-972771-9-git-send-email-hans.rosenfeld@amd.com> <1300894067-604408-9-git-send-email-hans.rosenfeld@amd.com> <AANLkTin6XrHKR6ARwC0v4b1URaB=08MD7fUoPap+9Dfb@mail.gmail.com> <20110329141712.GM13@escobedo.osrc.amd.com>
In-Reply-To: <20110329141712.GM13@escobedo.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2011 07:17 AM, Hans Rosenfeld wrote:
>>
>> I'm not sure I like this.  I did a quick test on 64-bit, and found
>> that while most if not all user processes allocated the fpu save area
>> (probably because of glibc blindly initializing the fpu), kernel
>> threads did not.  This patch would force kernel threads to allocate
>> memory they would never use.
> 
> Yes, up to a few kilobytes would be wasted by kernel threads. The
> related code gets much simpler. I think that is a good thing.
> 

This is silly.  It shouldn't be very hard to allocate this for user
threads while avoiding the allocation for kernel threads.  The only
excuse for allocating it for user threads is if it becomes part of the
kernel stack allocation.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

