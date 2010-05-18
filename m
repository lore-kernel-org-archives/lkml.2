Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab0ERU5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 16:57:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48467 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982Ab0ERU5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 16:57:32 -0400
Message-ID: <4BF2FF26.9050701@zytor.com>
Date: Tue, 18 May 2010 13:57:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, avi@redhat.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/fpu] x86: Add new static_cpu_has() function using alternatives
References: <1273135546-29690-2-git-send-email-avi@redhat.com>	 <tip-a3c8acd04376d604370dcb6cd2143c9c14078a50@git.kernel.org> <1274213443.2485.3.camel@edumazet-laptop>
In-Reply-To: <1274213443.2485.3.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2010 01:10 PM, Eric Dumazet wrote:
> # gcc -v
> Reading specs from /usr/lib/gcc/i386-redhat-linux/3.4.6/specs
> Configured with: ../configure --prefix=/usr --mandir=/usr/share/man
> --infodir=/usr/share/info --enable-shared --enable-threads=posix
> --disable-checking --with-system-zlib --enable-__cxa_atexit
> --disable-libunwind-exceptions --enable-java-awt=gtk
> --host=i386-redhat-linux
> Thread model: posix
> gcc version 3.4.6 20060404 (Red Hat 3.4.6-10)

I just implemented a fallback for gcc 3, but the real question is to
which degree we still care about gcc 3 support for x86 specifically
(other architectures might have other needs, but this is x86-specific code.)

Lately the number of issues with gcc 3 support seems to have gone way
up, and at some point we're going to have to cut it loose -- when would
depend largely on what the usage case is; e.g. why are you, yourself,
using gcc 3.4 to compile a state of the art kernel?

	-hpa
