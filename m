Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab1I0Xbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 19:31:42 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:64432 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab1I0Xbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 19:31:41 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MWyCknNH3xmVmbJJu+w9ugNc3e4K3e3_6cY1RAy4ynJCQ@mail.gmail.com>
References: <CA+55aFwdm3n+xehYc1cronkcwLE79ZYtr96LiVWD2WjKkaZ5DA@mail.gmail.com>
 <CACqU3MXzUbQS9fy0Etgt2GcgwRoXfihhmw-aWjrCFbzvmDM7yg@mail.gmail.com>
 <CA+55aFwKyd5fuyxu2tGDbQ8gKiEj=z7uYdBRg9O46WN0sTeNTQ@mail.gmail.com>
 <CACqU3MU8jkysNxFasdfy9ksqSo2ojiZ5LUwfcfX13MMRgVx2Xw@mail.gmail.com> <CACqU3MWyCknNH3xmVmbJJu+w9ugNc3e4K3e3_6cY1RAy4ynJCQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 27 Sep 2011 16:31:20 -0700
X-Google-Sender-Auth: umKEY7AYNj2QhiesjX-u2k-Ixtk
Message-ID: <CA+55aFxp8bNhLs+v69gp7XxBGq6wkmLkZKjB2_09H3qsZC_pzw@mail.gmail.com>
Subject: Re: Linux 3.1-rc7
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 4:25 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>
> What is strange is that I moved from -rc7 to -rc8 with:
>
> % git reset --hard v3.1-rc8

Git optimizes all the filesystem operations heavily. That means that
files that have not changed between two releases and are clean (and
match) in the index are not re-written by a git reset.

You can obviously always force a re-write by removing all files and
then doing the reset, but it should never be necessary under normal
circumstances.

> which should have reset the corrupted file. FYI, the machine is
> running 2.6.35.13-91.fc14.x86_64. Something's smelly with that kernel
> :-/

More likely something is smelly with your filesystem or memory. A few
bits flipped on disk or in the page cache would do it, and git has
caught corruption like that before.

Do you still have the bad tree around? Because it migth be interesting
to see what the corruption pattern is if you do.

                       Linus
