Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410Ab0KORny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:43:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53906 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933281Ab0KORnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:43:52 -0500
Message-ID: <4CE17133.2050101@zytor.com>
Date: Mon, 15 Nov 2010 09:43:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andres Salomon <dilinger@queued.net>, Milton Miller <miltonm@bga.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86: OLPC: speed up device tree creation during boot
 (v2)
References: <20101111214546.4e573cad@queued.net> <reply-olpc-3-v2@mdm.bga.com> <20101112002704.50c629e2@queued.net> <20101114095013.GB24206@elte.hu> <4CE0B54E.6000101@zytor.com> <20101115070254.GA25243@elte.hu>
In-Reply-To: <20101115070254.GA25243@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2010 11:02 PM, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> What?  What is wrong with static variables in functions?  It really doesn't seem 
>> to be a good idea to make them file-scope if they don't need to be.
> 
> They are very easy to overlook and mix up with regular stack variables and i've seen 
> (and introduced myself) a number of bugs due to them.
> 
> They also often are used in buggy ways (with SMP not taken into consideration), so 
> overlooking them during review compounds their negative effects. Putting them in 
> front of the function isnt a big deal in exchange.
> 
> There are people who never overlook them (like yourself), but my brain is wired up 
> differently.
> 

However, I have to vehemently object to putting them in a wider scope
than is otherwise necessary.  I agree that static variables should be
used sparsely if at all (there really are vary few uses of them that are
valid), but putting them in a larger scope screams "I'm used in more
than one function", and that is *not* a good thing.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

