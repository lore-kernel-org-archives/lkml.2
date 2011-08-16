Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab1HPPfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 11:35:16 -0400
Received: from c60.cesmail.net ([216.154.195.49]:19066 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621Ab1HPPfN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 11:35:13 -0400
Message-ID: <20110816113512.3bhhxdbcsgsow484-cebfxv@webmail.spamcop.net>
Date: Tue, 16 Aug 2011 11:35:12 -0400
From: Pavel Roskin <proski@gnu.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
Subject: Re: Suppressing a plus from setlocalversion
References: <20110815173706.12ccfdd4@mj>
	<alpine.DEB.2.00.1108151600400.22798@chino.kir.corp.google.com>
	<20110815222141.jgw2q59rko0wssoc-cebfxv@webmail.spamcop.net>
	<20110816152458.71b0bd74@stein>
In-Reply-To: <20110816152458.71b0bd74@stein>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stefan Richter <stefanr@s5r6.in-berlin.de>:

> On Aug 15 Pavel Roskin wrote:
>> Quoting David Rientjes <rientjes@google.com>:
>>
>> > On Mon, 15 Aug 2011, Pavel Roskin wrote:
>> >
>> >> Hello!
>> >>
>> >> There is one annoyance in the build system that I cannot work around.
>> >
>> > That's surprising since you actually state the workaround, i.e. using
>> > LOCALVERSION= with make, yourself.
>>
>> OK, I don't consider that an acceptable solution, as it could
>> interfere with other build systems.
>>
>> However, as soon as I posted this message, I found a better solution,
>> namely setting LOCALVERSION= in the environment (both for the normal
>> user and for root).  This is less likely to have unexpected effects,
>> since the environment variables don't override the variables
>> explicitly set in makefiles.
>
> Having this globally as an environment variable seems to be a more
> intrusive alternative; there are no namespaces.

I know, it's not an ideal solution.

> You can wrap the make command lines that you often use into shell
> aliases.  I often use command lines like 'nice make -j8' or
> 'nice make -j8 C=1 CF="-D__CHECK_ENDIAN__"' by alias.

__CHECK_ENDIAN__ is addressed by a separate patch :)

I guess I need to write a wrapper that would be suitable for my needs.  
  Still, I'd prefer the build system do what I want, at least in some  
aspects.

>> > Yes, because the kernel you've produced is no longer 3.1.0-rc2, it is
>> > modified.  If you want to do something else locally, then you can always
>> > use LOCALVERSION=.
>> >
>> > The + was added to stop falsely identifying kernels as a specific version
>> > when they are modified by default.  Sorry if you forget to override it
>> > sometimes.
>
> I for one am glad that I don't have to remember to force a localversion
> all the time.  All of the kernels that I runtime-test have their source
> managed by quilt, not git.  Thankfully, scripts/setlocalversion
> acknowledges that quilt users know what they are doing. :-)

Actually, it's simply unaware of what you are doing.

Also, setlocalversion is unaware that the wireless-testing tree is  
tagged every day.  It doesn't add the plus for the tagged revisions,  
even though they are very different from the version in the source  
Makefile.

But I'd rather not be on the mercy of a script not knowing something.

-- 
Regards,
Pavel Roskin
