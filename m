Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab0CTEzK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 00:55:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51004 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab0CTEzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 00:55:08 -0400
Message-ID: <4BA45527.5050202@zytor.com>
Date: Fri, 19 Mar 2010 21:55:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] x86-32: Split cache flush handler from simd handler
References: <1268936453-3727-1-git-send-email-brgerst@gmail.com>	 <1268936453-3727-2-git-send-email-brgerst@gmail.com>	 <4BA3FBB5.2050008@zytor.com> <73c1f2161003192108n72311e00h49fcf9eac5a2b4fc@mail.gmail.com>
In-Reply-To: <73c1f2161003192108n72311e00h49fcf9eac5a2b4fc@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2010 09:08 PM, Brian Gerst wrote:
>>
>> Does anyone have *any idea* what processor this applies to?  I've
>> tracked the code back all the way to the original inclusion in the
>> kernel, and there isn't even the slightest hint.
>>
>> The comment, of course, is a great example on how *not* to write
>> comments... it should have mentioned the CPU in question.
> 
> This thread appears to describe the problem:
> http://marc.info/?t=104960872800014&r=1&w=2
> 
> And the initial patch:
> http://marc.info/?l=linux-kernel&m=104960870106838&w=2
> 
> It looks like to me, that an AMD 486 clone has an erratum where the
> invd instruction from userspace generates exception 19 (13 hex)
> instead of #GP (13 dec).
> 

Ah, guess it was even older than I first realized ... I should have
searched for the string "cache flush denied" instead.

Sounds like we should do three things:

a) update the comment to actually reflect what is going on;
b) compile it out for > 486;
c) report the error as trap 13 rather than 19.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

