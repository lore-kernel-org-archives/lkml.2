Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760377Ab1F1Ru7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 13:50:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760395Ab1F1Rt0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 13:49:26 -0400
MIME-Version: 1.0
In-Reply-To: <201106100355.p5A3t8Aa024924@drepperk.user.openhosting.com>
References: <201106100355.p5A3t8Aa024924@drepperk.user.openhosting.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 28 Jun 2011 10:23:58 -0700
Message-ID: <BANLkTin7wm6m5bN4CfQzhJZuhy3bUrS80A@mail.gmail.com>
Subject: Re: [PATCH] Add cloexec information to fdinfo
To: drepper@akkadia.org
Cc: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        viro@zeniv.linux.org.uk, wilsons@start.ca
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 8:55 PM,  <drepper@akkadia.org> wrote:
> There is one piece of information about a file descriptor which is
> currently not visible from the outside: the close-on-exec flag.  The
> /proc/PID/fdinfo/* files have the mode information but this is
> missing.  Is the following patch acceptable?

The description makes no mention of why this would be needed?

Also, it's by no means the only thing not visible in /proc. Things
like file locking status, leases, file descriptor ownership, signal
number associated with the setown etc.

So the kernel has _lots_ of internal file knowledge, and not all of it
makes sense to export to user space. What is so special about
close-on-exec?

                        Linus
