Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab1FSIA4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 04:00:56 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42483 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab1FSIAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 04:00:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=w2OAVpvPnTfjGUho4sf9jSTEj9I99T00eIjtVN3gFGcsRx0Z0UQ1mAlX966ODOmrNn
         w1dz9pwcWmP4//PR/V6fWaKu9d9nixkzdFaSojDbfPyR7/HwTdWuISHeDRVTghsGfVqc
         FT0aFpTsEzO1Dl2q55BB2+oWwaG2hXJkBSvi8=
Subject: Re: tracing kernel panics
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shane <software.research.development@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTik3iseHFah_s=NNasQ22NtA+9zLWA@mail.gmail.com>
References: <BANLkTik3iseHFah_s=NNasQ22NtA+9zLWA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Jun 2011 10:00:47 +0200
Message-ID: <1308470447.3539.66.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 18 juin 2011 à 19:12 -0500, Shane a écrit :
> Anyone offer advice on how I should go about tracking down this kernel
> panic? Apologies if I've got the wrong list, let me know.
> 
> I'm developing a networking module, my own protocol over TCP. I load
> my module, I make a network connection, and then I close it. I do
> nothing more, then after about 1-2 minutes, it throws this panic
> output and none of it seems to come from my module code. I know my
> code is the problem, and if I don't run my modules, I never get
> panics. But nothing in the stack trace I recognize from my code and
> I'm having a very hard time find where in my code I've gone wrong. I
> run my kernel modules in a VM as a guest OS which connects to another
> guest OS (currently using 2.6.36-r5).
> 
> I've read how to analyze an OOPS, but ... here I can't even find the
> file that this might belong to so as to disassemble it, or understand
> what device this is. Any suggestions/pointers/advice much appreciated?

General kernel programming advices ...

It seems you have bugs in your module, maybe something like freeing
memory twice, or memory you dont own, or manipulating some data without
taking the associated lock protecting it.

tcp sockets are protected by RCU and various locks, getting them used
right is not an easy task.

You should take a look at various options in "Kernel hacking"
(some of them cannot be used together)

1) Using SLUB debug and "slub_debug=FZPU"
2) CONFIG_DEBUG_KMEMLEAK
3) CONFIG_PROVE_LOCKING
4) CONFIG_PROVE_RCU
5) debug linked list manipulations

and so on.



