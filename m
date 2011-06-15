Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab1FOKAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 06:00:10 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:38238 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209Ab1FOKAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 06:00:05 -0400
Message-ID: <25c1ce98c838621aeb514e6e0e843949.squirrel@webmail.sf-mail.de>
In-Reply-To: <20110615081317.GL8141@htj.dyndns.org>
References: <20110614070732.GA3355@maxin>
    <20110614071540.GE8141@htj.dyndns.org>
    <BANLkTimHjVX6ymALT-ZBeSs1S+PRDRwQaQ@mail.gmail.com>
    <20110615081317.GL8141@htj.dyndns.org>
Date: Wed, 15 Jun 2011 12:00:02 +0200
Subject: Re: [PATCH] [RESEND] devres: Fix possible use after free
From: "Rolf Eike Beer" <eike-kernel@sf-tec.de>
To: "Tejun Heo" <tj@kernel.org>
Cc: "Maxin B John" <maxin.john@gmail.com>, akpm@linux-foundation.org,
        segooon@gmail.com, jkosina@suse.cz, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello, Maxin.
>
> On Tue, Jun 14, 2011 at 03:09:34PM +0100, Maxin B John wrote:
>> You are right. I shouldn't have mentioned it as dangerous. I was trying
>> to
>> make this patch description similar to the description present in the
>> previous patch:
>> http://www.spinics.net/lists/mm-commits/msg84313.html
>>
>> This patch silences the Coverity Prevent's complains about this as
>> use-after-free bug. Please let me know if the updated patch description
>> is OK.
>>
>> "
>> A freed pointer is passed as an argument to the function
>> "devres_destroy()" in
>> "kernel/irq/devres.c" and "lib/devres.c". This patch fixes the possible
>> use
>> after free.
>> The change silences the static analysis tool (Coverity Prevent)
>> complains
>> about this as use-after-free bug.
>> "
>
> Yeap, sounds mostly okay but there's no 'possible use after free'.
> Maybe something like, "devres uses the pointer value as key after it's
> freed, which is safe but triggers spurious use-after-free warnings on
> some static analysis tools.  Rearrange code to avoid such warnings".

Sounds good. And please merge both patches together.

Eike
