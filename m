Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab0HWNcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 09:32:07 -0400
Received: from borg.medozas.de ([188.40.89.202]:39052 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998Ab0HWNcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 09:32:05 -0400
Date: Mon, 23 Aug 2010 15:32:03 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Brian Gerst <brgerst@gmail.com>, aijazbaig1@gmail.com,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: help needed with EXPORT_SYMBOL
In-Reply-To: <1282569477.2605.1798.camel@laptop>
Message-ID: <alpine.LNX.2.01.1008231527390.21000@obet.zrqbmnf.qr>
References: <1282373834.4080.79.camel@aijazbaig1-desktop>  <1282540448.4080.86.camel@aijazbaig1-desktop>  <AANLkTimtNOyJCbLxAW8Ebsftb58EWoNFW7Xkevqb6oGo@mail.gmail.com> <1282569477.2605.1798.camel@laptop>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 2010-08-23 15:17, Peter Zijlstra wrote:

>On Mon, 2010-08-23 at 07:48 -0400, Brian Gerst wrote:
>> 
>> Use an exported function pointer in the main kernel as a hook that the
>> module sets when it is loaded.  Note, you must use module_get and
>> module_put around the call to the module to prevent it from unloading
>> while in use. 
>
>Please don't do any such thing, its impossible to use correctly.
>
>Suppose there are two modular users, A and B.

Though in case there is just a single user it can work out.
Just like bridge.c, and the bunch of nf_nat_*.c. :-)
Though yeah. Bad bad.

This is starting to sound pretty much like an XY problem: XY problem: 
You want to do X, but don't know how. You think you can solve it using 
Y, but don't know how to do that, either. You ask about Y, which is a 
strange thing to want to do. Just ask about X.

(And then there is still the "good idea to do X in the first place" 
thing.) Like what's so important to have as a module when you can build 
it in, given that the caller is built-in (obj-y) itself.

>module_init()
>{
>	old_fptr = fptr;
>	fptr = A_func;
>}
>
>Then you load A, load B and unload A, then guess what happens?
>

