Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680Ab0KRPEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 10:04:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38161 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757989Ab0KRPEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 10:04:53 -0500
Message-ID: <4CE54064.6010702@zytor.com>
Date: Thu, 18 Nov 2010 07:04:04 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: michael@ellerman.id.au
CC: Ingo Molnar <mingo@elte.hu>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>,
        Ingo Molnar <mingo@redhat.com>, Andres Salomon <dilinger@queued.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] x86: OLPC: speed up device tree creation during boot
 (v2)
References: <20101111214546.4e573cad@queued.net>	 <reply-olpc-3-v2@mdm.bga.com> <20101112002704.50c629e2@queued.net>	 <20101114095013.GB24206@elte.hu> <4CE0B54E.6000101@zytor.com>	 <20101115070254.GA25243@elte.hu> <4CE17133.2050101@zytor.com>	 <20101118083420.GC26398@elte.hu> <1290078135.22575.4.camel@concordia>
In-Reply-To: <1290078135.22575.4.camel@concordia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 03:02 AM, Michael Ellerman wrote:
> On Thu, 2010-11-18 at 09:34 +0100, Ingo Molnar wrote:
>>
>> Look at the general balance of hardship: very little harm is done (it's not a big 
>> deal if a variable is only used in a single function) but having it with local 
>> variables can be _really_ harmful - for example i overlooked them when i reviewed 
>> this patch. I dont like important details obscured - i like them to be apparent. 
>> Again, this is something that some people can parse immediately on the visual level 
>> - me and many others cannot.
> 

No, sorry, this sounds like a personal preference that is well out of
line with the vast majority of C programmers I've ever come across, not
just in the Linux kernel world but outside of it.

> What about:
> 
> int foo(void)
> {
> 	static int bar;
> 
> 	struct thing_struct *thing;
> 	int other_var;
> 	char *p;
> 
> 	...
> }
> 
> I think the visual wrongness of that formatting would be enough for me
> to stop and look twice. Though I guess it doesn't work if you have few,
> or no other variables other than the statics to declare.
> 

I wouldn't object to a convention like that, but let's bloody well
realize that that is a brand new convention, and if this convention is
going to stick at all it needs to be made official and put in CodingStyle.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

