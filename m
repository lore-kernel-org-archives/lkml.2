Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab0JCLVH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 07:21:07 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38122 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab0JCLVF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 07:21:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ml91aNnBworCdf5bTG25SA0sToTofmBdLCwQ3zYjexR66lmPZ295x+OPcat/9jop7E
         ayn5rbqwZ8yyL6EwOQ6fZem93x+1ChhhsTZSJLgqKdRMkwfPfGooYzpxUZT+7JfOl2Lb
         ZWT6haGHst6MONQAo3w/tG1U60PI6jrz9Yxjk=
MIME-Version: 1.0
In-Reply-To: <20101002165215.GK21129@thunk.org>
References: <MEG5YPP-fxC.A.vnD.So6nMB@chimera>
	<sQALkqF1FWE.A.IiE.Qp6nMB@chimera>
	<20101002165215.GK21129@thunk.org>
Date: Sun, 3 Oct 2010 13:21:03 +0200
Message-ID: <AANLkTimPjz85+N8aiVV3yxz808LMG1-aZKAaO8CwUK=m@mail.gmail.com>
Subject: Re: [Bug #17361] Watchdog detected hard LOCKUP in jbd2_journal_get_write_access
From: Vegard Nossum <vegard.nossum@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Christian Casteyde <casteyde.christian@free.fr>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 October 2010 18:52, Ted Ts'o <tytso@mit.edu> wrote:
> On Sun, Sep 26, 2010 at 10:04:13PM +0200, Rafael J. Wysocki wrote:
>>
>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=17361
>> Subject               : Watchdog detected hard LOCKUP in jbd2_journal_get_write_access
>> Submitter     : Christian Casteyde <casteyde.christian@free.fr>
>> Date          : 2010-08-29 19:59 (29 days old)
>
> See my latest comment here:
>
>    https://bugzilla.kernel.org/show_bug.cgi?id=17361#c14
>
> This subject line is highly misleading, since after -rc4, the stack
> traces are in places all over the kernel, in other places other than
> ext4/jbd2.  So I fear no one is looking at this bug report given the
> highly misleading subject line.
>
> It looks like you have spinlock debugging, and yet there wan't any
> spinlocks listed on the initial ext4 might_sleep() warning.  So
> something looks highly confused.
>
> The fact that you closed other bugs as duplicates of this one that
> relate to kmemcheck makes me wonder if this is really a kmemcheck bug.
> (If so, the subject line here is doubly, doubly misleading.)
>
> Do you see any symptoms if you turn off kmemcheck?  Are you sure this
> isn't just only a kmemcheck bug?

I just had a quick glance at the report, and here's my gut feeling: I
see perf symbols in the stack trace. I don't think kmemcheck and perf
play nicely together (for example if perf uses NMIs to write data to
its buffers, it could get a page fault inside the NMI handler, which
is not so nice, I think).

Isn't this exactly what Frederic Weisbecker tried to detect and warn
about in a patch that I saw recently?

Please do as Ted suggested and try to turn kmemcheck off.


Vegard
