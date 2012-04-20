Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab2DTPQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:16:28 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:6683 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab2DTPQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:16:26 -0400
Message-ID: <4F9167A4.80305@tilera.com>
Date: Fri, 20 Apr 2012 15:41:56 +0200
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Pawel Moll <pawel.moll@arm.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] init: fix bug where environment vars can't be passed
 via boot args
References: <201204061711.q36HBpAh015060@lab-41.internal.tilera.com> <20120419151746.8c765ea7.akpm@linux-foundation.org>
In-Reply-To: <20120419151746.8c765ea7.akpm@linux-foundation.org>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/20/2012 12:17 AM, Andrew Morton wrote:
> On Fri, 6 Apr 2012 12:53:50 -0400
> Chris Metcalf <cmetcalf@tilera.com> wrote:
>
>> Commit 026cee0086f had the side-effect of dropping the '=' from
>> the unknown boot arguments that are passed to init as environment
>> variables.  This is because parse_args() puts a NUL in the string
>> where the '=' was when it passes the "param" and "val" pointers
>> to the parsing subfunctions.  Previously, unknown_bootoption() was
>> the last parse_args() subfunction to run, and it carefully put back
>> the '=' character.  Now ignore_unknown_bootoption() is the last
>> one to run, and it wasn't doing the necessary repair, so the
>> envp params ended up with the embedded NUL and were no longer
>> seen as valid environment variables by init.
> This patch has been stuck in your tree for a week or two.  The copy
> there is missing Woody's Tested-by and (I suspect) his Reported-by and
> Pawel's Acked-by.

I pushed it by accident - sorry.  I'll double-check my pending changes more
carefully in the future.  I meant for that tree only to hold tile-specific
stuff, but I had the boot-argument change in my tree so I could do more
effective testing.  I'm on vacation till Tuesday in Croatia, unfortunately,
so I don't really want to try to do more than email.

> And because that patch is already in linux-next, I can't (or rather
> don't want to) merge it myself.
>
> It needs to be merged into 3.4.  Please fix up the changelog data and
> send it in?

I will either fix it up and move it to my stable tree for 3.4 on Wednesday
when I'm back in the office, and ask Linus to pull it, or if you want to
push it, presumably it shouldn't conflict much for linux-next.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

