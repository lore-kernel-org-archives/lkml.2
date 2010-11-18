Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760026Ab0KRRuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 12:50:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44909 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363Ab0KRRux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 12:50:53 -0500
Message-ID: <4CE5670B.1060300@zytor.com>
Date: Thu, 18 Nov 2010 09:48:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>
CC: michael@ellerman.id.au, Ingo Molnar <mingo@elte.hu>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Milton Miller <miltonm@bga.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] x86: OLPC: speed up device tree creation during boot
 (v2)
References: <20101111214546.4e573cad@queued.net>	<reply-olpc-3-v2@mdm.bga.com>	<20101112002704.50c629e2@queued.net>	<20101114095013.GB24206@elte.hu>	<4CE0B54E.6000101@zytor.com>	<20101115070254.GA25243@elte.hu>	<4CE17133.2050101@zytor.com>	<20101118083420.GC26398@elte.hu>	<1290078135.22575.4.camel@concordia>	<4CE54064.6010702@zytor.com> <20101118094153.4515cbc2@queued.net>
In-Reply-To: <20101118094153.4515cbc2@queued.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 09:41 AM, Andres Salomon wrote:
>>
>> No, sorry, this sounds like a personal preference that is well out of
>> line with the vast majority of C programmers I've ever come across,
>> not just in the Linux kernel world but outside of it.
> 
> 
> This is actually one of the reasons I specifically like initialized
> static variables (inside of functions).  Take the following code:
> 
> int foo(void)
> {
> 	static char *frob = NULL;
> 	int p;
> 
> 	if (frob) {
> 		...
> 	}
> 
> 
> Upon seeing that and thinking "whoa, how could frob be
> initialized and then checked?", I realize that it's either a bug or I
> look back at the initialization and realize that frob is static.  It's
> less obvious (to me) with non-explicit initialization.

I have to agree with this one.  In general I dislike relying on an
implicit (even well-defined) initialized value; unfortunately we ripped
out explicit initializations across the Linux kernel, not due to
readability but due to the fact that long-since-obsolete versions of gcc
would put explicitly-initialized variables in data rather than bss even
if the initial value is zero.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

