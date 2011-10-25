Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab1JYV6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 17:58:10 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36096 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab1JYV6J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 17:58:09 -0400
MIME-Version: 1.0
X-Originating-IP: [85.13.70.251]
In-Reply-To: <4E9DC902.4000204@windriver.com>
References: <1317434037-15343-1-git-send-email-paul.gortmaker@windriver.com>
	<20111018174353.GB16894@breakpoint.cc>
	<4E9DC902.4000204@windriver.com>
Date: Tue, 25 Oct 2011 14:58:08 -0700
Message-ID: <CAOesGMgGKowZa8fZOw5hMG8_u9TYJzoQBfJtfvghEwpxXTgyow@mail.gmail.com>
Subject: Re: [PATCH] irq: don't put module.h into irq.h for tracking irqgen modules.
From: Olof Johansson <olof@lixom.net>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 11:44 AM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> On 11-10-18 01:43 PM, Sebastian Andrzej Siewior wrote:
>> On Fri, Sep 30, 2011 at 09:53:57PM -0400, Paul Gortmaker wrote:
>>> irq/manage.c is now (as of b687380) using try_module_get and
>>> module_put and so it needs module.h (which it already has).
>>>
>>> Also convert the irq_alloc_descs variants to macros, since all
>>> they really do is is call the __irq_alloc_descs primitive.
>>> This avoids including export.h and no debug info is lost.
>>
>> macros, I see. THIS_MODULE is quite simple. What about moving this part from
>> module.h which is hidden behind ifdef MODULE and make it avaiable as a separate
>> headerfile with no children?
>
> Already done.  THIS_MODULE, because of its presence everywhere
> in non modular code is also in the export.h file.

As mentioned separately, this broke at least ARM in latest linux-next:
http://lkml.org/lkml/2011/10/25/396


-Olof
