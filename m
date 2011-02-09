Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab1BIQD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 11:03:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752121Ab1BIQD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 11:03:57 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTimGH5mU+OLRKb=H3WgLXPZaSc5heR+4w5gj2aD4@mail.gmail.com>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
 <m1hbce46fw.fsf@fess.ebiederm.org> <AANLkTikJL_4-7F_2oSuefSpL7ak3+OWLk7F+bDqWT8XJ@mail.gmail.com>
 <m1bp2ly41q.fsf@fess.ebiederm.org> <AANLkTimGH5mU+OLRKb=H3WgLXPZaSc5heR+4w5gj2aD4@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 9 Feb 2011 08:02:58 -0800
Message-ID: <AANLkTikj-ZTS58uAqUmKQEWzdD3f5DJeox=gOJ9z8rSb@mail.gmail.com>
Subject: Re: Heads up Linux 2.6.38-rc4 compile problems.
To: Alex Riesen <raa.lkml@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 9, 2011 at 6:59 AM, Alex Riesen <raa.lkml@gmail.com> wrote:
>
> Maybe some files (stdlib.h or malloc.h) return no data when read?
> Then, gcc still
> "compiles" them, but all the declarations are missing. And I would expect gcc
> to complain if zero blocks returned, and truncated files are very likely to
> abort compilation.

Well, the thing is, Eric said he was using ext4.

And there are absolutely no changes I can see after -rc3 that would
affect anything like this. No VFS layer changes that look at all
likely, there are no ext4 changes at all, and the VM changes there are
look rather unlikely too (ie they are about corner cases in page
migration and transparent hugepage support - not to mention that it's
almost certainly not some VM race or whatever if they are
deterministic).

The only unusual thing in Eric's setup is the mount namespace usage,
but nothing has changed wrt that, at least since -rc3.

                         Linus
