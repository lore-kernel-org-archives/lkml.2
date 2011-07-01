Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab1GAVdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 17:33:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33499 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757806Ab1GAVdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 17:33:41 -0400
Message-ID: <4E0E3B83.3000403@zytor.com>
Date: Fri, 01 Jul 2011 14:26:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>
CC: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Brian Gerst <brgerst@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86: add missing verify_cpu to 32bit wakeup
References: <20110701211943.GA7042@outflux.net>
In-Reply-To: <20110701211943.GA7042@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2011 02:19 PM, Kees Cook wrote:
> Some BIOSes will reset the Intel XD_DISABLE MSR bit when resuming from S3,
> which can interact poorly with ebba638ae723d8a8fc2f7abce5ec18b688b791d7.
> In 32bit PAE mode, this can lead to a fault when EFER is restored by
> the kernel wakeup routines, due to it setting the NX bit for a CPU
> that (thanks to the BIOS reset) now incorrectly thinks it lacks the NX
> feature. 64bit wakeup already handled this through its common call path
> that would hit verify_cpu(). 32bit has a separate path for restoring
> CPU state on S3 wakeup, and needed to call verify_cpu() to handle this
> situation.

For S3, we should save/restore MISC_ENABLE instead... in fact, we
already save it, we just restore it too late.

	-hpa
