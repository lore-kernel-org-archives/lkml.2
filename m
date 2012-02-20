Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab2BTSDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 13:03:46 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62714 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab2BTSDp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 13:03:45 -0500
MIME-Version: 1.0
In-Reply-To: <tip-45d5a1683c04be28abdf5c04c27b1417e0374486@git.kernel.org>
References: <1329687817.1561.27.camel@acer.local.home> <tip-45d5a1683c04be28abdf5c04c27b1417e0374486@git.kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 20 Feb 2012 10:03:24 -0800
X-Google-Sender-Auth: CH6dpLMgPNMA46S9dnBwbID0Wj4
Message-ID: <CA+55aFxfAn9MWRgS3O5k2tqN5ys1XrhSFVO5_9ZAoZKDVgNfGA@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86/nmi: Test saved %cs in NMI to determine
 nested NMI case
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, stable@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 3:47 AM, tip-bot for Steven Rostedt
<rostedt@goodmis.org> wrote:
>        /*
> +        * If %cs was not the kernel segment, then the NMI triggered in user
> +        * space, which means it is definitely not nested.
> +        */
> +       cmp $__KERNEL_CS, 16(%rsp)
> +       jne first_nmi

I don't like how you wrote 'cmp' without a size, especially with none
of the arguments then giving a size either. Usually there's a register
name or something that gives you the size, but not here.

I guess there is some default size that gas will use, but at least
some versions of gas have traditionally errored out instead of
guessing on sizes. Maybe x86-64 doesn't use those gas versions any
more, but still..

                                        Linus
