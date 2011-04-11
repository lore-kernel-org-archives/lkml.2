Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab1DKKUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 06:20:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43462 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab1DKKUx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 06:20:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=H0ylrGsDT5hCSB68bdFQnj1HwznaCsb9e2/7VN+lhkBe++8gV6mGoZvSomWGi6eHz8
         Um1wfYIzirZtQ40i1Nndum/AqWaqfoM4Lic3XiJaU+NziktJHD8TDltzB32n+lQzuX3z
         aQVQy1p8xlP8UPgPEQExk6IBsGxreNlUzXr7s=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <mnazarewicz@gmail.com>,
        "Dave Hansen" <dave@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, "Johannes Weiner" <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] break out page allocation warning code
References: <20110408202253.6D6D231C@kernel>
 <BANLkTi=OnDX53nOZcaaMmqXRBcWicam0xg@mail.gmail.com>
 <1302296522.7286.1197.camel@nimitz>
Date: Mon, 11 Apr 2011 12:20:49 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vtrq0zac3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1302296522.7286.1197.camel@nimitz>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Apr 8, 2011 10:23 PM, "Dave Hansen" <dave@linux.vnet.ibm.com> wrote:
>>> +       if (fmt) {
>>> +               printk(KERN_WARNING);
>>> +               va_start(args, fmt);
>>> +               r = vprintk(fmt, args);
>>> +               va_end(args);
>>> +       }

> On Fri, 2011-04-08 at 22:54 +0200, Michał Nazarewicz wrote:
>> Could we make the "printk(KERN_WARNING);" go away and require caller
>> to specify level?

On Fri, 08 Apr 2011 23:02:02 +0200, Dave Hansen wrote:
> The core problem is this: I want two lines of output: one for the
> order/mode gunk, and one for the user-specified message.
>
> If we have the user pass in a string for the printk() level, we're stuck
> doing what I have here.  If we have them _prepend_ it to the "fmt"
> string, then it's harder to figure out below.  I guess we could fish in
> the string for it.

This is a bit unfortunate, but that's what I was worried anyway.  I guess
creating a macro which automatically prepends format  with KERN_WARNING
would solve the issue but that's probably not the most elegant solution.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
