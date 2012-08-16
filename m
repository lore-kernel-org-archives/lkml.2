Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964807Ab2HPOFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:05:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964792Ab2HPOFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:05:42 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.5.1: WARNING: at include/linux/iocontext.h:140 copy_process.part.56+0x1041/0x1190()
References: <CAO9zADxc3fVUwRhxzbirQvjVLjun3_Dt150KYakoCUOzB3aksg@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 16 Aug 2012 10:05:39 -0400
In-Reply-To: <CAO9zADxc3fVUwRhxzbirQvjVLjun3_Dt150KYakoCUOzB3aksg@mail.gmail.com>
	(Justin Piszcz's message of "Wed, 15 Aug 2012 20:04:12 -0400")
Message-ID: <x498vdf7wzw.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz <jpiszcz@lucidpixels.com> writes:

> Hi,
>
> Kernel: 3.5.1 x86_64
> Just FYI, this may have been due to an NFS issue (remote host turned
> off during dump possibly) but reporting just incase:
>
> [41793.725267] ------------[ cut here ]------------
> [41793.725273] WARNING: at include/linux/iocontext.h:140
> copy_process.part.56+0x1041/0x1190()
> [41793.725274] Hardware name: X9SCL/X9SCM
> [41793.725276] Pid: 20378, comm: dump Not tainted 3.5.1 #2
> [41793.725276] Call Trace:
> [41793.725279]  [<ffffffff8102f0d5>] warn_slowpath_common+0x75/0xb0
> [41793.725280]  [<ffffffff8102f1e5>] warn_slowpath_null+0x15/0x20
> [41793.725282]  [<ffffffff8102e371>] copy_process.part.56+0x1041/0x1190
> [41793.725283]  [<ffffffff8102e62b>] do_fork+0x13b/0x2f0
> [41793.725285]  [<ffffffff8103cc02>] ? recalc_sigpending+0x12/0x30
> [41793.725287]  [<ffffffff8103f4aa>] ? __set_current_blocked+0x3a/0x60
> [41793.725290]  [<ffffffff8100a1e3>] sys_clone+0x23/0x30
> [41793.725293]  [<ffffffff815c0a33>] stub_clone+0x13/0x20
> [41793.725294]  [<ffffffff815c07e6>] ? system_call_fastpath+0x1a/0x1f
> [41793.725295] ---[ end trace 6afd1df8f82f60e4 ]---

This should be fixed by the following:

commit 4638a83e8615de9c16c39dfed234951d0f468cf1
Author: Olof Johansson <olof@lixom.net>
Date:   Wed Aug 1 12:17:27 2012 +0200

    block: uninitialized ioc->nr_tasks triggers WARN_ON
