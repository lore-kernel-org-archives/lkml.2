Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0JDKEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 06:04:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56861 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333Ab0JDKEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 06:04:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hzLIwHsTslDP+GR5HA5HkRHQypbBGULkZH1H22qZqT9kRqoH8JFGLzDmQZUCrQQL1V
         7wtwgtWRON0uchMScn2bmsKvJtbH+cTl0E/i5wm/4tv0qkbwus7hGfZ//a7mX4viRt9c
         tXUaVIfJ6MVxlRbcG0TcQB6QapONosTetp0fc=
Date: Mon, 4 Oct 2010 18:09:20 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Mark Heily <mark@heily.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: setgroups(2) does not update all threads in a process
Message-ID: <20101004100920.GH5189@cr0.nay.redhat.com>
References: <4CA6A2E3.2060306@heily.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA6A2E3.2060306@heily.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 11:11:31PM -0400, Mark Heily wrote:
>
>The setgroups(2) system call does not update the credentials for all
>threads in a process. Instead, it only updates the credentials for
>the currently executing thread. Any threads that were created before
>setgroups() was called are not affected.
>
>This is not the expected behavior according to the manpage, which states:
>
>    "setgroups()  sets  the supplementary group IDs for the calling process."
>
>See below for a small test case that demonstrates the problem. This
>program runs successfully on FreeBSD 8 and Solaris 10, but fails on
>Linux 2.6.32.

I got the following from credentials(7):

       The POSIX threads specification requires that credentials are shared by all of
       the threads in a process.  However, at the kernel level, Linux maintains
       separate user and group credentials for each thread.  The NPTL threading
       implementation does some work to ensure that any change to user or group
       credentials (e.g., calls to setuid(2), setresuid(2), etc.)  is carried through
       to all of the POSIX threads in a process.

Hope it helps.
