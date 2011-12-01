Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab1LAAjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 19:39:48 -0500
Received: from mail.windriver.com ([147.11.1.11]:37201 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab1LAAjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 19:39:46 -0500
Message-ID: <4ED6CCD0.10201@windriver.com>
Date: Wed, 30 Nov 2011 19:39:44 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-security-module@vger.kernel.org>
Subject: Re: [RFC][PATCH] trimming includes from linux/security.h
References: <20111130065000.GT2203@ZenIV.linux.org.uk> <CAP=VYLozbbfO=90GxuGe9k_V6OghwFdR3uVE-=dpX5be4qPhgw@mail.gmail.com> <20111130222903.GX2203@ZenIV.linux.org.uk>
In-Reply-To: <20111130222903.GX2203@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-11-30 05:29 PM, Al Viro wrote:

[...]

> 
> 
> Frankly, I would very much prefer to reduce these 3 functions to one
> (..._mm() variant, sans the WARN_ON()) and had callers pass current->mm
> explicitly.  I.e. something like this (preserving the current behaviour):

I dropped my scattered sched.h additions, and added this in to fix
the current->mm users.

I also had to macro-ize two static inlines in security.h to avoid
needing sched.h for incomplete types on task->real_cred, but that
meant I could drop the add of linux/cred.h to linux/security.h

Found one more trivial build error in selinux/hooks.c needing shm.h
but that was it.  I've got more builds running, but I've already built
a bunch of arm, mips, powerpc, and sparc without seeing any more fallout.

http://git.kernel.org/?p=linux/kernel/git/paulg/linux.git;a=shortlog;h=refs/heads/al-security-Nov30

If you want to squash the security.h commits all into one, change
commit logs, or anything like that, by all means, go ahead.

Paul.
