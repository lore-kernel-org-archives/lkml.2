Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab0HWNoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 09:44:30 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59314 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab0HWNo1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 09:44:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lcjEFhN0UDVGDdq4/20/Sp5ed0Bp6Reuv8M0b96K+cLnjsRsNeTJ50gLcjZ5YZtdwI
         5S0lge5iU9RNlheFxwDgutvLxQHKrrOtvcu6ajtIJm1bbFz123uDEIw22vfLh0IeZ5B8
         eURZ+u5mShWr87XO47xZEQEAdCpT/CW16VtME=
MIME-Version: 1.0
In-Reply-To: <1282569477.2605.1798.camel@laptop>
References: <1282373834.4080.79.camel@aijazbaig1-desktop>
	<1282540448.4080.86.camel@aijazbaig1-desktop>
	<AANLkTimtNOyJCbLxAW8Ebsftb58EWoNFW7Xkevqb6oGo@mail.gmail.com>
	<1282569477.2605.1798.camel@laptop>
Date: Mon, 23 Aug 2010 09:44:26 -0400
Message-ID: <AANLkTinq5APN4CXWAGj9sTFiTf4Cn1_mDaJSrAOh=t+N@mail.gmail.com>
Subject: Re: help needed with EXPORT_SYMBOL
From: Brian Gerst <brgerst@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: aijazbaig1@gmail.com, netfilter-devel@vger.kernel.org, jengelh@medozas.de,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 9:17 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-08-23 at 07:48 -0400, Brian Gerst wrote:
>>
>> Use an exported function pointer in the main kernel as a hook that the
>> module sets when it is loaded.  Note, you must use module_get and
>> module_put around the call to the module to prevent it from unloading
>> while in use.
>
> Please don't do any such thing, its impossible to use correctly.
>
> Suppose there are two modular users, A and B.
>
> Both have something like:
>
> extern void (*fptr)(void);
>
> static void (*old_fptr)(void);
>
> static void func(void)
> {
>        /* foo */
>        if (old_fptr)
>                old_fptr();
> }
>
> module_init()
> {
>        old_fptr = fptr;
>        fptr = A_func;
> }
>
> Then you load A, load B and unload A, then guess what happens?
>

The assumption was that there was a single module using that hook.
For multiple users you'd need to use a register function that adds the
module to a linked list.

--
Brian Gerst
