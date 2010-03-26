Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab0CZMp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 08:45:26 -0400
Received: from e208.rev.megiteam.pl ([77.79.226.8]:58056 "EHLO
	vadmin.megiteam.com.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab0CZMpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 08:45:25 -0400
Date: Fri, 26 Mar 2010 13:45:22 +0100
From: Grzegorz Nosek <root@localdomain.pl>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Testing lxc 0.6.5 in Fedora 13
Message-ID: <20100326124522.GD17113@megiteam.pl>
References: <20100321195044.GA23757@megiteam.pl> <20100323212834.GH20796@count0.beaverton.ibm.com> <20100325213356.GB20541@megiteam.pl> <20100326111131.GA8604@redhat.com> <20100326115357.GA3345@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100326115357.GA3345@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 04:53:57AM -0700, Matt Helsley wrote:
> Yup. strace would need to be modified to use that. I tried that and it still
> won't work -- I seem to recall it didn't work because strace uses pid values
> obtained from the wait syscall too. To make it work we'd need to be able to
> translate those pids in userspace. That's do-able from userspace if you trace
> all forks descending from the pidns init task. But it's not do-able for
> simple attaches. That's why I was thinking Eric's setns() might be able to
> help if strace used it to enter the tracee's pid namespace whenever we need to.
> 
> gdb often doesn't use the same methods but has similar problems with pid
> namespaces.

Hmm, is there a good reason why strace does not use the data explicitly
provided by the kernel but instead second-guesses it from syscall return
values? I don't know anything about ptrace, really, but I'd expect the
kernel to provide the tracer with out-of-band information otherwise
taken from clone/waitpid/other syscalls?

Best regards,
 Grzegorz Nosek
