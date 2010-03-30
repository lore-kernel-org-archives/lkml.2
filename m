Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab0C3St2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 14:49:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60499 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab0C3StX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 14:49:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH -next] x86, fs: add sys_compat_write for net/socket.c
Date: Tue, 30 Mar 2010 20:48:58 +0200
User-Agent: KMail/1.13.1 (Linux/2.6.33-00063-g0795fff; KDE/4.4.1; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       x86@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1269971469-1254-1-git-send-email-fw@strlen.de> <4BB23B35.7060401@zytor.com> <20100330181757.GB14721@Chamillionaire.breakpoint.cc>
In-Reply-To: <20100330181757.GB14721@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003302048.59350.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+THJ1W1Jgq1lDDhzhaWVfzp/aACgbDqYAnb6+
 nSYnkmL0msgmhpVzrc8iRkI2LlVhjs0yPq9DgYzhXfoAIrPyeN
 5xihf0Bfm/puISBtnPOjQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 March 2010 20:17:57 Florian Westphal wrote:
> Now, I realize that adding a write compat syscall is borderline
> insanity, and I am open to suggestions.

Another option, which may be marginally better, would be to redefine
the data structures to be compatible, and assign them new numbers,
with kernel compat support for the numbers in x86-32 binaries.

If you manually add padding to the new data structures in the places
that the other architectures have implicit padding, the hack will only
be needed on x86-32 and compat x86-64.

The obvious disadvantage is that you need to recompile the x86-32
binaries to work in compat mode.

	Arnd
