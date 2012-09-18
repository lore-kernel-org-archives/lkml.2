Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301Ab2IRP2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 11:28:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756946Ab2IRP2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 11:28:30 -0400
Date: Tue, 18 Sep 2012 17:30:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>,
        "Jonathan M. Foote" <jmfoote@cert.org>,
        Roland McGrath <roland@hack.frob.com>, Pedro Alves <palves@redhat.com>
Subject: Re: [PATCH -mm v2 2/2] coredump: add a new elf note with siginfo
	of the signal
Message-ID: <20120918153027.GA21612@redhat.com>
References: <1347979995-1452-1-git-send-email-vda.linux@googlemail.com> <1347979995-1452-3-git-send-email-vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347979995-1452-3-git-send-email-vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18, Denys Vlasenko wrote:
>
> +static void fill_siginfo_note(struct memelfnote *note, siginfo_t *csigdata, siginfo_t *siginfo)
> +{
> +	mm_segment_t old_fs = get_fs();
> +	set_fs(KERNEL_DS);
> +	copy_siginfo_to_user((siginfo_t __user *) csigdata, siginfo);
> +	set_fs(old_fs);
> +	fill_note(note, "CORE", NT_SIGINFO, sizeof(*csigdata), csigdata);
> +}

OK, I think this is fine.

But, somehow I forgot about compat tasks when we discussed this before.
Perhaps the code above should do

	if (is_compat_task())
		copy_siginfo_to_user32(...);
	else
		copy_siginfo_to_user(...);

?

Oleg.

