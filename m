Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab2ECIdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 04:33:10 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:51850 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab2ECIdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 04:33:06 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: "Michael Kerrisk \(man-pages\)" <mtk.manpages@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, linux-man@vger.kernel.org,
        viro@zeniv.linux.org.uk, Richard Weinberger <richard@nod.at>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] open(2): document O_PATH
In-Reply-To: <20120430114410.GB28308@thunk.org>
References: <1335669917-23970-1-git-send-email-vapier@gentoo.org> <CAKgNAkgykZJV59WJXW9c9gVwXhn=WNYKxo_W1GM7ocHEEFqEXg@mail.gmail.com> <877gwxacti.fsf@skywalker.in.ibm.com> <20120430114410.GB28308@thunk.org>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 03 May 2012 13:57:21 +0530
Message-ID: <87fwbhhdp2.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12050222-5140-0000-0000-0000012D20CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ted Ts'o <tytso@mit.edu> writes:

> It might also be a good idea to document explicitly whether or not
> things like fstat() and the syscalls to manipulate extended attributes
> are expected to work.
>

fstat won't work, but fstatat with an empty path name would work. O_PATH
descriptors are suppose to be used as "location only descriptors". 
We then extended the *at syscalls to work with EMPTY pathnames so that
O_PATH descriptors can be used with readlink, fchownat and fstatat().
This was done to enable us to do these operation on symlinks.
(65cfc6722361570bfe255698d9cd4dccaf47570d)

Examples for O_PATH and handle syscall can be found in qemu and
handle-test repo 

http://git.qemu.org/?p=qemu.git;a=blob;f=hw/9pfs/virtio-9p-handle.c;h=f96d17a9749a6f672741ff4dcb98da81d1dcc3ce;hb=HEAD
https://github.com/kvaneesh/handle-test/blob/master/handle.h

-aneesh

