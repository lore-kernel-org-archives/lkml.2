Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab0K3SK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 13:10:28 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58201 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844Ab0K3SK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 13:10:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qbYyFdIRosZ5ACnNH6WrmLj/3JPcEmfUzlgUcV9mpjURymPlUn9M5bQuFtSSLZAmNb
         nmiu23e/9CWh+EtB/Khys/n3NlLdBnba2ZRzjpAKE1N5aYm//l9yJUdw4JWCHqdqK5lZ
         id29v1REGzHdw83JN055WhWW1OuoH2N7f1lGU=
Subject: Re: When was ASLR introduced in the Linux kernel?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Victor van der Veen <vvdveen@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1291139457.2701.14.camel@GX620>
References: <1291117660.3206.11.camel@D430>
	 <1291119324.2904.51.camel@edumazet-laptop> <1291139457.2701.14.camel@GX620>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 19:10:19 +0100
Message-ID: <1291140619.2904.144.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 30 novembre 2010 à 18:50 +0100, Victor van der Veen a écrit :

> Thanks, but this was not what I was really looking for. However,
> searching for 'randomize_va_space' led me to a thread on lkml started by
> Arjan van de Ven on January 27th, 2005:
> http://lkml.org/lkml/2005/1/27/56
> 
> It would be great if someone can provide more details on this subject:
>   1) when was randomize_va_space introduced? (probably somewhere in
> 2.6.11.x)

	who cares ?

>   2) when was it enabled by default (2.6.12.? but no announcement in
> changelog?)

commit 42a172a814759a29020e5d1ee580bf4eb86afed2
Author: arjan <arjan>
Date:   Sat Mar 5 17:25:41 2005 +0000

    [PATCH] Randomisation: enable by default
    
    Signed-off-by: Arjan van de Ven <arjan@infradead.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>
    
    BKrev: 4229eb95j12voWjpsZzY2Wlm6P7Mvg

# git describe --contains 42a172a8
v2.6.11.3~887

>   3) which additions were added in later releases? (and when?)


commit 32a932332c8bad842804842eaf9651ad6268e637
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Feb 6 22:39:44 2008 +0100

    brk randomization: introduce CONFIG_COMPAT_BRK
    
    based on similar patch from: Pavel Machek <pavel@ucw.cz>
    
    Introduce CONFIG_COMPAT_BRK. If disabled then the kernel is free
    (but not obliged to) randomize the brk area.
    
    Heap randomization breaks ancient binaries, so we keep COMPAT_BRK
    enabled by default.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

git describe --contains 32a932332c8bad842804842eaf9651ad6268e637
v2.6.25-rc1~513^2~15



