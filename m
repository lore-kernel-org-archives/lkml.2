Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab1D0JLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 05:11:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49704 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab1D0JLD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 05:11:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=Q7EFOQ4ReVg4tWWe+ZD2BsGJBncXGK7CKdmlizDprqoajUCwrsB6HKpkpaY2r0lw7X
         ifb/BbsBZ3gQMt/ClzMvM8uKgjhcjFRxa5A5WPMyvkaPZkLjkkNmw4ezaZUFHVzVQmiZ
         YbAZCwAXVxNgBA47/fMrHgTwnhFgzgnYv0MgU=
MIME-Version: 1.0
In-Reply-To: <20110427085910.GA1749@linux.betterlinux.com>
References: <1303853727-21444-1-git-send-email-andrea@betterlinux.com>
 <20110427001453.GD12436@dastard> <20110427085910.GA1749@linux.betterlinux.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Wed, 27 Apr 2011 05:10:41 -0400
X-Google-Sender-Auth: N10fQ2YHsD3VhZIJiTDon2k3gRM
Message-ID: <BANLkTimrpNOHVfnund7uc=thf-c3_HxyYQ@mail.gmail.com>
Subject: Re: [RFC] [PATCH] drop_pagecache syscall
To: Andrea Righi <andrea@betterlinux.com>
Cc: Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 05:01, Andrea Righi wrote:
> On Wed, Apr 27, 2011 at 10:14:53AM +1000, Dave Chinner wrote:
>> On Tue, Apr 26, 2011 at 11:35:27PM +0200, Andrea Righi wrote:
>> > This functionality can be used by all the applications that want to have a
>> > better control over the page cache management (for example to immediately drop
>> > pages that for sure will not be reused in the near future, without calling
>> > posix_fadvise() for all the files they've touched), or to provide a more fine
>> > grained debugging feature usable by the filesystem benchmarks.
>> >
>> > The system call does not require root privileges and it can be called by any
>> > unprivileged application. For example, we can write a userspace tool to run
>> > something like this:
>> >
>> >   $ drop-pagecache /path/file_or_dir
>>
>> That's a potential DOS vector, I think. Drop the pagecache in a hard
>> loop on the root fs of a busy server and watch it crawl...
>
> Yes, probably we could allow only the CAP_SYS_ADMIN tasks to execute
> this syscall.

if /proc/sys/vm/drop_caches has any checks other than file permission
checks (i.e. UID==0), it'd probably be better to copy those rather
than picking something different.
