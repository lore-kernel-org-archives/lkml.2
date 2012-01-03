Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab2ACQNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 11:13:48 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48214 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab2ACQNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 11:13:42 -0500
Message-ID: <1325607218.2320.89.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH] x86: fix and improve cmpxchg_double{,_local}()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@elte.hu, tglx@linutronix.de, Christoph Lameter <cl@linux.com>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        hpa@zytor.com
Date: Tue, 03 Jan 2012 17:13:38 +0100
In-Reply-To: <4F03361C020000780006A3A5@nat28.tlf.novell.com>
References: <4F01F12A020000780006A19B@nat28.tlf.novell.com>
	 <1325602830.2320.69.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1325603714.2320.73.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1325605290.2320.76.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4F03361C020000780006A3A5@nat28.tlf.novell.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 03 janvier 2012 à 16:08 +0000, Jan Beulich a écrit :

> "1" and "672" are both local labels, so both are okay. As long as there's
> no other (colliding) use of 672 anywhere, that would seem to be the
> preferred fix (feel free to put my ack on the patch when you formally
> submit it).

I was referring the use of a label local to the macro itself, with
restricted scope.

following psudi code would trigger an asm error :

	.macro FOO
	.local_label 1
1:	lock
        .section .smp_locks,"a"
        .balign 4
        .long 1b - .
        .previous
	.endm


	FOO
	jne 1b



