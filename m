Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab2JZLDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 07:03:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52152 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab2JZLDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 07:03:46 -0400
Date: Fri, 26 Oct 2012 12:03:44 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: ??????? ???????? <dm.leontiev7@gmail.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, dleontie@amd.com
Subject: Re: procfs does not return error code when file name is already in
 use
Message-ID: <20121026110344.GP2616@ZenIV.linux.org.uk>
References: <CA+JonM0vrXtGzhv44o5rOH-3z_BuU52=Nu8WmiMz5m1=ENZ9HA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+JonM0vrXtGzhv44o5rOH-3z_BuU52=Nu8WmiMz5m1=ENZ9HA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 01:57:43PM +0400, ??????? ???????? wrote:
> I'm working a kernel module, and one of my tasks is to disallow a
> process to open my character device(/dev/xxx) more than once. I tried
> to solve this problem by creating /proc/apu directory, and creating a
> /proc/xxx/{pid} file for when process opens /dev/xxx. This file will
> act as per-process mutex, and provide a way to control resource usage.

Whoever had set that "task" upon you deserves to be painfully educated
until they realize that thus stated the limitation is absolutely worthless -
file does not have to be opened by the same process that uses it.  IOW,
limiting opens to one per process does not provide any kind of resource
control - it's trivially bypassed by creating an AF_UNIX socketpair,
then forking children in a loop, each doing open + send SCM_RIGHTS
datagram to parent over that socket with opened fd in it + exit.  And
receiving those datagrams until you get as many opened descriptors for
your device as you wanted.
