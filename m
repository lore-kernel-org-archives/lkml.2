Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab1AQIgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 03:36:05 -0500
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:52435 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753100Ab1AQIgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 03:36:03 -0500
Message-ID: <4D33F9DD.2020504@stericsson.com>
Date: Mon, 17 Jan 2011 09:12:13 +0100
From: Linus Walleij <linus.walleij@stericsson.com>
Organization: ST-Ericsson SA
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH] param: add null statement to compiled-in module params
References: <1294230424-4089-1-git-send-email-linus.walleij@stericsson.com> <201101171011.16182.rusty@rustcorp.com.au>
In-Reply-To: <201101171011.16182.rusty@rustcorp.com.au>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2011 12:41 AM, Rusty Russell wrote:
> On Wed, 5 Jan 2011 10:57:04 pm Linus Walleij wrote:
>    
>> Add an unused struct declaration statement requiring a
>> terminating semicolon to the compile-in case to provoke an
>> error if __MODULE_INFO() is used without the terminating
>> semicolon. Previously MODULE_ALIAS("foo") (no semicolon)
>> compiled fine if MODULE was not selected.
>>      
> I really prefer the other way; make everyone use a semicolon.
>    

That's what it does. Currently the kernel allows you to
write MODULE_ALIAS("bar") sans semicolon if you
compile in the module statically...

Or am I getting things wrong?

> Let's look how many we're talking about... hmm, I'm having
> trouble finding any!
>    

There is no module in the kernel doing this, but I
had the issue in the merge window (and fixed it up),
this is to help developers not doing that mistake
again.

> Could you patch this the other way, to make MODULE_ALIAS w/o a
> semicolon always an error?
>    

This is what the patch does... after the patch the
MODULE_ALIAS("foo") without semicolon will throw
a compilation error also on statically linked modules.

Currently it doesn't...

Yours,
Linus Walleij
