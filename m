Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273Ab2FKIar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 04:30:47 -0400
Received: from mga12.intel.com ([143.182.124.36]:15309 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750795Ab2FKIaq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 04:30:46 -0400
MIME-Version: 1.0
In-Reply-To: <8762aziuq6.fsf@rustcorp.com.au>
References: <87ipf73lsi.fsf@rustcorp.com.au>
	<20120522230218.24007.3556.stgit@warthog.procyon.org.uk>
	<26029.1337960539@redhat.com>
	<18581.1338903356@redhat.com>
	<8762aziuq6.fsf@rustcorp.com.au>
Date: Mon, 11 Jun 2012 11:30:33 +0300
Message-ID: <CALLzPKYCZfYm6cKAoM64jODFJDzZTV7gvHUNpF-jOtdZ=aDMsg@mail.gmail.com>
Subject: Re: [PATCH 00/23] Crypto keys and module signing
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>, kyle@mcmartin.ca,
        zohar@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2012 at 8:47 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Tue, 05 Jun 2012 14:35:56 +0100, David Howells <dhowells@redhat.com> wrote:
>> Rusty Russell <rusty@rustcorp.com.au> wrote:
>>
>> > > If you prefer to have userspace extract the module signature and pass it in
>> > > uargs, here's a tree that will do that:
>> > >
>> > >   http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=shortlog;h=refs/heads/modsign-uarg
>> >
>> > OK, there's merit in this approach: it certainly moves the argument
>> > about how to encode the signature out of my backyard :)
>>
>> Not really.  The signature still has to be created by the kernel build.  It's
>> just that you no longer have to care about the trade off when it comes to
>> parsing it.
>
> Yes, exactly.
>
>> > Should we just bite the bullet and create a new syscall:
>> >
>> > SYSCALL_DEFINE5(init_module2, void __user *, umod,
>> >             unsigned long, len, const char __user *, uargs,
>> >                 unsigned int, siglen, const char __user *, sig)
>> >
>> > But I'm easily swayed if you prefer the current approach.
>>
>> "The current approach" being to attach signature to the blob?  Or to pass the
>> signature separately but in the uargs?
>
> The former.
>
>> I would very much prefer to keep the signature in the blob and have the kernel
>> extract it as there's no particular need for it to be detached - even if you
>> are using IMA.
>>
>> However, I don't think an extra syscall would hurt particularly - except that
>> it uses up more space in the syscall table...  It would, however, be smaller
>> in the signature verification department as the signature neither needs
>> decoding from uargs nor extracting from the blob.
>
> Good.  Let's have init_module2(), and let userspace decide where to get
> the signature from.
>

Nice.

> Thanks,
> Rusty.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
