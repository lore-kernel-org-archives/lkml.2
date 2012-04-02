Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab2DBAZI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 20:25:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667Ab2DBAZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 20:25:06 -0400
Date: Mon, 2 Apr 2012 02:24:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Extend core dump note section to contain file names of
	mapped files
Message-ID: <20120402002448.GA27179@redhat.com>
References: <CAK1hOcPxVWDCTRLzH6X+88WXuw_Ywzbt+iAJ3QMEfxG22duk9g@mail.gmail.com> <20120401031329.GP17822@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120401031329.GP17822@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01, Andi Kleen wrote:
>
> > I propose to save this information in core dump, as a new note
> > in note segment.
>
> Seems like a good idea but rather than write complicated code

I agree, I feel it can be simplified...

> i would just reuse
> the /proc/*/maps code and dump it in that format?

I must have missed something. Do you really suggest to use
show_pid_map/etc?

If nothing else, this code depends on CONFIG_PROC_FS. But in any
case I think this will only complicate fill_files_note().

coredump is "simple", we are the last thread which can play with
this ->mm. We do not need locks, we do not need the "restart after
we dropped mmap_sem" logic. We know that the task_struct can't go
away. The only problem is rename, that is why we can't allocate the
whole buffer beforehand.

OK, I must have missed something ;)

Oleg.

