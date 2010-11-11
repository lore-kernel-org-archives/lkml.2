Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab0KKJvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 04:51:54 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56304 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab0KKJvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 04:51:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SgG0KYH07AlVDwgUJmUlcJobFQujf9Bs3FjqGybbKJsXdxXGuIDCSimIcewHaOV5GC
         TNeHEv2Ws328clCAtgYO7QswikebpWhZiKnFs3M258LpEZj+oimh55hYVG9WCw0x3TO/
         dJTyLVUwAsZUijUVsfkza2SZyXsmMY78V8Mlk=
Subject: Re: [PATCH] x86: avoid calling arch_trigger_all_cpu_backtrace() at
 the same time on SMP
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dongdong Deng <dongdong.deng@windriver.com>, dzickus@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101111092301.GD18789@elte.hu>
References: <1289442042-2515-1-git-send-email-dongdong.deng@windriver.com>
	 <20101111092301.GD18789@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 10:51:44 +0100
Message-ID: <1289469104.17691.1025.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 11 novembre 2010 à 10:23 +0100, Ingo Molnar a écrit :

> Also, variables that cmpxchg or test_and_set operates on need to be long, not int.

Hmm, ok for test_and_set(), it operates on a long.

cmpxchg() is ok on an int AFAIK. If not we have to make some changes :(

btrfs_orphan_cleanup() for example does this :

	if (cmpxchg(&root->orphan_cleanup_state, 0, ORPHAN_CLEANUP_STARTED))
		...


Same in build_ehash_secret() (net/ipv4/af_inet.c)

	cmpxchg(&inet_ehash_secret, 0, rnd);

