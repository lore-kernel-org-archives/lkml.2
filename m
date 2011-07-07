Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab1GGMjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 08:39:07 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60656 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410Ab1GGMjG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 08:39:06 -0400
MIME-Version: 1.0
In-Reply-To: <4E14E1C6.1010202@linux.intel.com>
References: <1309821688.4527.10.camel@vitaliy-Vostro-1400>
	<4E1494A8.7070109@linux.intel.com>
	<1309986669.27362.3.camel@vitaliy-Vostro-1400>
	<4E14E1C6.1010202@linux.intel.com>
Date: Thu, 7 Jul 2011 15:39:04 +0300
Message-ID: <CAGTPOqefJup5Nn0r3z+UYCh-dqPKz0cwDwL2znTRKzLuBSUtZQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] futex: warning corrections
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: Darren Hart <dvhart@linux.intel.com>, Jiri Kosina <jkosina@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "trivial@kernel.org" <trivial@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> From 8eeaa5a97697bcc606aea23d32028aea7b271a96 Mon Sep 17 00:00:00 2001
>> From: Vitaliy Ivanov <vitalivanov@gmail.com>
>> Date: Thu, 7 Jul 2011 00:05:05 +0300
>> Subject: [PATCH] futex: uninitialized warning corrections
>> MIME-Version: 1.0
>> Content-Type: text/plain; charset=UTF-8
>> Content-Transfer-Encoding: 8bit
>>
>> kernel/futex.c: In function ‘fixup_pi_state_owner.clone.17’:
>> kernel/futex.c:1582:6: warning: ‘curval’ may be used uninitialized in this function
>> kernel/futex.c: In function ‘handle_futex_death’:
>> kernel/futex.c:2486:6: warning: ‘nval’ may be used uninitialized in this function
>> kernel/futex.c: In function ‘do_futex’:
>> kernel/futex.c:863:11: warning: ‘curval’ may be used uninitialized in this function
>> kernel/futex.c:828:6: note: ‘curval’ was declared here
>> kernel/futex.c:898:5: warning: ‘oldval’ may be used uninitialized in this function
>> kernel/futex.c:890:6: note: ‘oldval’ was declared here
>>
>> Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
>
> Please include a blurb in the commit message as to why you used
> uninitialized_var() rather than just assigning it. This will save people
> the time of wondering why, and me the time of nacking "it's simpler to
> just initialize to zero" patches :-)
>
> Acked-by: Darren Hart <dvhart@linux.intel.com>

Darren,

Thanks for your comments. I think the description is pretty obvious
here as I don't think any of these variables are affected by cmpxchg.
There is simple assignment at the end. Seems like compiler simply
doesn't follow all the return cases.

Anyway, I'm going to resend patches to Jiri for his trivial-next tree.

Vitaliy
