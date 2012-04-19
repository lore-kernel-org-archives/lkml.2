Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab2DSUVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 16:21:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51155 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932356Ab2DSUVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 16:21:19 -0400
Message-ID: <4F9073A6.4030709@zytor.com>
Date: Thu, 19 Apr 2012 13:20:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@amd64.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH 3/3] x86, extable: Handle early exceptions
References: <1334794610-5546-1-git-send-email-hpa@zytor.com> <20120419092255.GA29542@aftab> <20120419092630.GD29542@aftab> <4F904541.2030200@zytor.com> <CA+55aFwMsm7zVqPjKptm38zJAbJpF=9e51ew7BP6S5YnoJa3ig@mail.gmail.com> <20120419173802.GI3221@aftab.osrc.amd.com> <4F90527B.7020005@zytor.com> <CA+55aFxhY1Ug5esj==Sm=o1Epg+NFnvFs74syqRxbYDbPQJEFA@mail.gmail.com> <9ff2e09c-57e4-455e-8614-1b3b17b652f4@email.android.com> <4F9072CA.6030903@gmail.com>
In-Reply-To: <4F9072CA.6030903@gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2012 01:17 PM, David Daney wrote:
> On 04/19/2012 11:55 AM, H. Peter Anvin wrote:
>> Either way I suggest picking up David's presorting patchset since it
>> is already done and use its infrastructure for any further improvements.
> 
> It does have the advantage of already being implemented.  There was a
> little feedback on the kbuild portions of the patch.
> 
> If you would like, I will send an updated version of the patch.

Please.  It gets us 90% of the way, and we need the infrastructure
anyway to do any further work.

>> As far as a linear probe you get an average of n lookups with a
>> packing density of 1-1/n so you are right; a linear probe with a
>> density of say 1/2 is probably best.
>>
> 
> I usually see exception table sizes on the order of 2^10 entries, so I
> have to wonder how much you really gain from an O(1) implementation.

Well, for either variant of hash table you end up with ~2 serial memory
references as opposed to ~11.  No idea if there are workloads where this
actually matters.

	-hpa

