Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab1CTLch (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 07:32:37 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44406 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab1CTLce convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 07:32:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FS7wOLAifUJ2FiKplhMC3m0ChawIcnYZPZSiYbtB4W8+enZC6hee4Qcjvrq8uIcIeU
         Xx5eK/Xd03mDgYR5YCA0+WMHC4yHMv5DxIdpBym5Ng6iKRDEHDZNC23XUMGq5oejTJwQ
         AX1OkK43NwZRLovM7LXR9NfC5V/mCnILHzq8w=
MIME-Version: 1.0
In-Reply-To: <AANLkTimdbs2AZ9OE6j+=ziJA1LR2wkZR5qsT8AEq--5x@mail.gmail.com>
References: <1300416744.16880.904.camel@gandalf.stny.rr.com>
	<20110317211548.646b04d2@tpl.lwn.net>
	<1300419170.16880.956.camel@gandalf.stny.rr.com>
	<AANLkTikZK278BR5o1fP_w2u5PUPbgub9QT4XxzSmEhL5@mail.gmail.com>
	<AANLkTi=2d8S_Pi8kuZMXAmNvHa_2KrOs6K+_FF6P7-pU@mail.gmail.com>
	<Pine.LNX.4.64.1103200852080.28495@ask.diku.dk>
	<AANLkTi=MMKvA-9pFiM1K_JSXjS71JLRCem8THnhu-0=N@mail.gmail.com>
	<Pine.LNX.4.64.1103201007430.28495@ask.diku.dk>
	<20110320105412.GA11266@elte.hu>
	<AANLkTimdbs2AZ9OE6j+=ziJA1LR2wkZR5qsT8AEq--5x@mail.gmail.com>
Date: Sun, 20 Mar 2011 12:32:33 +0100
X-Google-Sender-Auth: oX6TteJMslQsbvPyc9oxyDyJN70
Message-ID: <AANLkTi=LHeMPCHARy0GE7u2_q0=sz2jLfpb6a-RU8gLM@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: Test for kmalloc/memset(0) pairs
From: Nicolas Palix <Nicolas.Palix@inria.fr>
To: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Julia Lawall <julia@diku.dk>,
        =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>,
        LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Mar 20, 2011 at 12:06 PM, Pekka Enberg <penberg@kernel.org> wrote:
> Hi,
>
> On Sun, Mar 20, 2011 at 12:54 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>> Indeed that one seems to be quite out of date.  You can get the most
>>> recent version here: https://launchpad.net/~npalix/+archive/coccinelle
>>
>> With tools/coccinelle/ you would never run into such problems of distributing
>> the latest stable version to your fellow kernel developers: it would always be
>> available in tools/coccinelle/.
>>
>> Integration, synergy, availability, distribution and half a dozen other
>> buzzwords come to mind as to why it's a good idea to have kernel-focused
>> tools hosted in the kernel repo :-)

Our usage is mainly kernel-focused but not the tool. It is C-program focused
and we have used it on other programs like Wine, OpenSSL, VLC. Others
use it on other projects like Davecot or close-source projets.
So, IMHO Coccinelle should no be part of Linux.

Integrating kernel-focused SmPL scripts is on the other hand a great idea
to check the kernel and to ease kernel developer life.
It is what have been done so far. It is certainly possible to improve that,
at least by adding more and more scripts.

>>
>> IMO it's an option to consider.
>
> That's my thinking too. Yes, 80 KLOC of OCaml in the kernel tree
> sounds crazy but I think the practical advantages might be enough to
> justify it. Btw, would git-submodule be something to consider here?
>

At every RC, we push the Coccinelle code on github. Using git-submodule
seems the way to go thus. Moreover, it will ease the maintenance of
scripts as we may assume users have one of the latest versions.


-- 
Nicolas Palix
http://sardes.inrialpes.fr/~npalix/
