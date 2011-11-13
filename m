Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab1KMLLQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 06:11:16 -0500
Received: from smtprelay.restena.lu ([158.64.1.62]:38404 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab1KMLLO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 06:11:14 -0500
Date: Sun, 13 Nov 2011 12:11:05 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [resolved] Filesystem (directory) permissions meaning
 difference for x86_64 and x86 for 3.1?
Message-ID: <20111113121105.1092d733@neptune.home>
In-Reply-To: <20111109215125.7c1c3d3a@neptune.home>
References: <20111109215125.7c1c3d3a@neptune.home>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 November 2011 Bruno Prémont wrote:
> On a x86_64 system I'm getting permission denied when trying to chdir()
> into a directory where I have only 'x' permissions (be it with unix
> permissions or with posix ACLs).
> For the same layout of directory I can successfully chdir() on x86 as I
> can with older kernels of 2.6 series.
> 
> In both cases the filesystem is tmpfs with support for posix ACLs and
> kernel is 3.1.0.
> 
> 
> Directory layout:
> drwx--x---  3 root test   60 Nov  9 21:14 /tmp/btest
> drwxrwx---  2 root test   40 Nov  9 21:14 /tmp/btest/subtest
> drwxr-x---+ 3 root root   60 Nov  9 21:10 /tmp/test
> drwxrwx---+ 2 root root   40 Nov  9 21:10 /tmp/test/subtest
> 
> Posix ACLs
> # file: /tmp/test
> # owner: root
> # group: root
> user::rwx
> group::r-x
> group:test:--x
> mask::r-x
> other::---
> 
> # file: test/subtest/
> # owner: root
> # group: root
> user::rwx
> group::r-x
> group:test:rwx
> mask::rwx
> other::---
> 
> 
> When executing as user test (with test as only group), on x86_64 I get
> EPERM on chdir(X) where X is any one of the 4 directories above.
> 
> On x86 I can chdir() into the directory without issue (as expected),
> and when in /tmp/test (or /tmp/btest) I get EPERM when trying to list
> contents - expected as well. Under subtest I can list content.
> 
> The same results are obtained on XFS filesystem.
> 
> Any idea what's wrong?

The issue was two entries in /etc/group for the same group name but with
two distinct GIDs :/
This explains why I could not reproduce on a different system!

Bruno
