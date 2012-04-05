Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab2DEKyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 06:54:15 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:16510 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976Ab2DEKyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 06:54:14 -0400
Message-ID: <4F7D79C3.1010306@parallels.com>
Date: Thu, 05 Apr 2012 14:53:55 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Lightning/1.0b2 Thunderbird/3.1.20
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "serge.hallyn@canonical.com" <serge.hallyn@canonical.com>,
        "criu@openvz.org" <criu@openvz.org>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/2] IPC: message queue stealing feature introduced
References: <20120215163203.27978.52494.stgit@localhost6.localdomain6>	<20120215165439.27978.43513.stgit@localhost6.localdomain6> <20120404161224.dea67733.akpm@linux-foundation.org>
In-Reply-To: <20120404161224.dea67733.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

05.04.2012 03:12, Andrew Morton пишет:
>
> I'd be a bit more comfortable if there was some sign that other c/r
> developers have reviewed and tested this and have successfully used it
> in c/r operation testing?
>

We have a user-space test (part of our regression testing test suite) for this 
functionality. Thus we run this test very ofter.

> We've been trying to isolate the c/r-specific functions inside #ifdef
> CONFIG_CHECKPOINT_RESTORE, but this patch doesn't do that.  I have been
> encouraging this isolation so that people who aren't using c/r don't
> have to carry the overhead it adds and so that we can more easily hunt
> down and remove everything if the entire c/r project doesn't work out
> successfully.
>

Sorry. I'll add this ifdef's and send rebased patch set once more.

> This patch modifies the sys_msgrcv() API and so we should update the
> manpage for that syscall.  Please work with Michael on this.
>

Sure.

> What does all the compat fiddling actually do?  I guess it's needed for
> checkpoint and restore of 32-bit userspace on 64-bit kernels?  Does c/r
> as a whole support that?  It should.  How well tested is this?
>

CRIU doesn't support 32-bit processes migration yet. But we are going to add 
this support in future.

-- 
Best regards,
Stanislav Kinsbursky
