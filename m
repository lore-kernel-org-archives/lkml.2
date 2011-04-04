Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab1DDDDH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 23:03:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61820 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608Ab1DDDDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 23:03:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Thilo-Alexander Ginkel" <thilo@ginkel.com>
Subject: Re: Soft lockup during suspend since ~2.6.36
Date: Mon, 4 Apr 2011 05:02:52 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <AANLkTim5ctAoaB4+BS7Z-+ARUgTEBO22bkYMUvFtGmoN@mail.gmail.com> <AANLkTimeRFN_5ZFwjtY6+yo0V=VAoX8T_Ju+ceDJnfHv@mail.gmail.com> <AANLkTi=Yusq1TicVCPN9CY2UCZ6jmcp+bw_CunG7uSFh@mail.gmail.com>
In-Reply-To: <AANLkTi=Yusq1TicVCPN9CY2UCZ6jmcp+bw_CunG7uSFh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104040502.52526.arnd@arndb.de>
X-Provags-ID: V02:K0:5Tl0smlzTVTZMSgwTfIlGn0bd3a9dvvl3bdKRLTmjmC
 TB+Va+53+NQ+HgyaCIi7O2x7J+qHEdQRuLZGpxSdYboNXz0rGd
 JwXncZOcLGZyMz5oT63U4TLSScbdqgh7ZEbovgVLAJng7EMNhQ
 BwLLIGqcK/k6Z6uvqoGF0tx9wF0Nxz9+Mxn5/PjQt3tjGHYMOD
 633of87du3DadR6Pi5Rvw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 April 2011, Thilo-Alexander Ginkel wrote:
> Transcript:
> | RIP: _raw_spin_unlock_irqrestore
> | Call Stack:
> |   _set_cpus_allowed_ptr
> |   worker_maybe_bind_and_lock
> |   rescuer_thread
> |   rescuer_thread
> |   kernel_thread_helper
> |   kthread
> |   kernel_thread_helper
> |   kthread
> 
> After some more time, the following backtrace is printed:
>   https://secure.tgbyte.de/dropbox/ueph3Ohm-3.jpg
> 
> Transcript:
> | RIP: worker_maybe_bind_and_lock
> | Call Stack:
> |   rescuer_thread
> |   rescuer_thread
> |   kernel_thread_helper
> |   kthread
> |   kernel_thread_helper
> |   kthread
> 
> From then on these two backtraces are printed in an alternating fashion.
> 
> Unfortunately, the top of the output is missing as it does not fit on
> screen (does someone know an even smaller console font?), but I assume
> it's the deadlock detection.

The interesting thing is that the backtrace is from unlock, not from lock,
so it can't really be a deadlock. However, the _raw_spin_unlock_irqrestore
function calls debug_spin_unlock(), which does a few sanity check. Maybe
one of those got triggered.

The easiest way to get the full output is usually to attach a serial
NULL modem cable and redirect the console to that, so you can get the
output on another machine. Another idea would be to modify the
show_registers function in arch/x86/kernel/dumpstack_64.c so that
it prints less data.

Yet another idea would be to set /sys/kernel/printk_delay so that the
oops gets printed slower.

	Arnd
