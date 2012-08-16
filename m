Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab2HPMiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 08:38:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62786 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab2HPMiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 08:38:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 16/31] arm64: ELF definitions
Date: Thu, 16 Aug 2012 12:37:53 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <201208151415.39570.arnd@arndb.de> <20120816102300.GG31784@mudshark.cambridge.arm.com>
In-Reply-To: <20120816102300.GG31784@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208161237.53594.arnd@arndb.de>
X-Provags-ID: V02:K0:U34WyDebidwvn+VW4XCt/ZOgyygVkCzV6tr9Wdupv8U
 0R64lNt4E2OhnOJeIsvwpcFCGUdLb+jjyCUnYASMhafq53seXY
 sIwbhMWsJODdceUoE9RgJS4LkXb9/iLkqYWPs26uA97tH7e80x
 hJJplw10enkwdL80q4EsAebFFsAtqRFVIfPNQATtL9BcrmnMOj
 RTHDHc4uFyOD6+IxqFhNqoONN/9Ok3DCUFp+rU6VUH8mQXnJjD
 vpEDeS4HeonjNOS2moQa8yTcVHPMXXDo/t16lsueqRNsHRnC0M
 /0Omc+vAazJrtQzGJgZrweG7qDepwUlfhmFydr/f67CpzRJt53
 +/RTfkRyrYafq0o5Sjs8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 August 2012, Will Deacon wrote:
> > This looks wrong: PER_LINUX/PER_LINUX32 decides over the output of the
> > uname system call, while TIF_32BIT decides over the instruction set
> > when returning to user space. You definitely should not set the personality
> > to the value you pass from the elf loader. Instead, just do
> > 
> > #define SET_PERSONALITY(ex) clear_thread_flag(TIF_32BIT);
> > #defined COMPAT_SET_PERSONALITY(ex) set_thread_flag(TIF_32BIT);
> 
> In this case, won't uname be incorrect (aarch64l) for aarch32 tasks (which
> expect something like armv8l)?

No, the uname output is meant to tell you about the system, not the
instruction set that you are using (you already know that in compiled
code).

The main use case is to fool stuff like autoconf into assuming your
architecture is the other one, e.g. when building a 32 bit package
on using a 64 bit /bin/bash to run ./configure or vice versa.

	Arnd
