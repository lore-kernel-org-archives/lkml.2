Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab0HWLsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 07:48:12 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41255 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab0HWLsI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 07:48:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rznph/3GCgg0bnLFg/t6DOsj7mJ+uDKeKeFzbztNFJWMUGZB+zx4tKAm78FKtYMRvi
         uc9pNencxq7tM0WY5w0/wV86yfDG8bFZGbAuiwpx53oSbMyG0dQ9MgmseINZToWkEm3B
         /C5fC2lr6YKoL0jAjivEnQZe9OAA5WrNlEG4Q=
MIME-Version: 1.0
In-Reply-To: <1282540448.4080.86.camel@aijazbaig1-desktop>
References: <1282373834.4080.79.camel@aijazbaig1-desktop>
	<1282540448.4080.86.camel@aijazbaig1-desktop>
Date: Mon, 23 Aug 2010 07:48:06 -0400
Message-ID: <AANLkTimtNOyJCbLxAW8Ebsftb58EWoNFW7Xkevqb6oGo@mail.gmail.com>
Subject: Re: help needed with EXPORT_SYMBOL
From: Brian Gerst <brgerst@gmail.com>
To: aijazbaig1@gmail.com
Cc: netfilter-devel@vger.kernel.org, jengelh@medozas.de,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 1:14 AM, Aijaz Baig <aijazbaig1@gmail.com> wrote:
> Hello,
>
> Yeah I do understand that part, but there has to be a way to do what I
> am trying to do here isn't it?
>
> And can anyone tell me can kallsyms_lookup() be used in such a
> situation? If yes than how do I use it?
>
> Regards,
> Aijaz
>
> On Sat, Aug 21, 2010 at 2:53 PM, Jan  Engelhardt <jengelh@medozas.de>
> wrote:
> On Saturday 2010-08-21 08:57, Aijaz Baig wrote:
>
>>So why is it that when my netfilter module is exporting something to
>>the kernel and im tryin to use it from within a core kernel file, the
>>compiler flags a 'undefined reference to' error?
>
> There, you answered yourself. Exports only go one way. And that is
> core -> module -> module.
>
> On Sat, 2010-08-21 at 12:27 +0530, Aijaz Baig wrote:
>> Hello,
>>
>> Ive been trying to EXPORT a SYMBOL from a netfilter module (actually a
>> hook) to the KERNEL. Various modules seem to export various symbols to
>> the kernel (or so it seems), an example being x_tables which exports a
>> whole lot of functions like xt_register_target and so on and all other
>> netfilter modules which use these functions dont seem to have any
>> problems.
>>
>> So why is it that when my netfilter module is exporting something to the
>> kernel and im tryin to use it from within a core kernel file, the
>> compiler flags a 'undefined reference to' error?
>>
>> I googled and came to the conclusion from the kernelnewbies mailing list
>> that using kallsyms_lookup() seems to be the answer or is it?
>> So, if I do intend to use kallsyms_lookup how do I use it? There aren't
>> so many instances of it being used it seems.
>>
>> Ive seen it being used in dev/core.c like so:
>> symname = kallsyms_lookup((unsigned long)sym, &symsize,&offset,&modname,
>> namebuf);
>>
>> I am basically trying to call a function that MY module EXPORTs inside
>> one of the core linux routines. This would also mean that my netfilter
>> module must be compiled (and linked also maybe?..not so sound with link
>> time stuff) before the address becomes visible so that kallsyms_lookup
>> can find it. So do I really shd be using it and if so, how?
>>
>> Any input is appreciated.
>>
>> Regards,
>> Aijaz Baig.
>>
>>

Use an exported function pointer in the main kernel as a hook that the
module sets when it is loaded.  Note, you must use module_get and
module_put around the call to the module to prevent it from unloading
while in use.

--
Brian Gerst
