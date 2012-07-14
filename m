Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab2GNOWi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 10:22:38 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38277 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab2GNOWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 10:22:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAHdPZaM8Vnfkkon_vCF-jPQLq6WH482ozhH3U08hF30bOMr7Ow@mail.gmail.com>
References: <CAHdPZaM8Vnfkkon_vCF-jPQLq6WH482ozhH3U08hF30bOMr7Ow@mail.gmail.com>
Date: Sat, 14 Jul 2012 16:22:28 +0200
Message-ID: <CAFLxGvzkx6e19Gj=vKj3yjW3Yjj3eBx1SbGkmdbTMK6WMtX5Bg@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
 0000000000000010 on 3.5-rc6
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: "devendra.aaru" <devendra.aaru@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Jiri Kosina <jkosina@suse.cz>, Darren Hart <dvhart@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, a.p.zijlstra@chello.nl
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 2:11 PM, devendra.aaru <devendra.aaru@gmail.com> wrote:
> 3.5-rc6 with git head at fdb1335a82e. (from Torvald's branch)

CC'in futex guys...

> dmesg:
>
> [43610.535421] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000010

Is this the first error message in dmesg?
IOW no WARNING before the BUG?

Looks like futex_wait_requeue_pi() was called before  pi_state->pi_mutex got
initialized.

-- 
Thanks,
//richard
