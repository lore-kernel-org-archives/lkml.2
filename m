Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567Ab2HHOmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 10:42:37 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49701 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758464Ab2HHOme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 10:42:34 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Muthukumar R <muthur@gmail.com>, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-doc@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Nikolaus Rath <Nikolaus@rath.org>, Liu Yuan <namei.unix@gmail.com>,
        Has-Wen Nienhuys <hanwen@xs4all.nl>
Subject: Re: [PATCH -v2 4/6] fuse: add a sysfs parameter to control the maximum request size
References: <20120719124851.6250.43316.stgit@ltc137.sdl.hitachi.co.jp>
	<20120719124948.6250.8088.stgit@ltc137.sdl.hitachi.co.jp>
Date: Wed, 08 Aug 2012 16:43:54 +0200
In-Reply-To: <20120719124948.6250.8088.stgit@ltc137.sdl.hitachi.co.jp> (Mitsuo
	Hayasaka's message of "Thu, 19 Jul 2012 21:49:48 +0900")
Message-ID: <87fw7xjvf9.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com> writes:

> Add a max_pages_per_req sysfs paramater to limit the maximum
> read/write request size. It can be changed to arbitrary number
> between 32 and the nr_pages equivalent to pipe_max_size, and the
> 32 pages are set by default.
>
> The sysfs parameter control is required, as follows.
>
> * The libfuse should change the current MIN_BUFSIZE limitation
>   according to the current maximum request size in FUSE. If not,
>   the libfuse must always set MIN_BUFSIZE to the maximum request
>   limit (= [nr_pages (equivalent to pipe_max_size) * 4KB + 0x1000]),
>   which leads to waste of memory.

I don't see the purpose of this sysfs parameter.  Userspace can
calculate the needed buffer size from the max_read/max_write parameters,
can't it?

>
> * It is easy to find and set the paramter to the optimized value
>   in order to improve the read/write throughput, since the
>   maximum request limit does not always provides the highest
>   throughput.

So basically this is a global max_read/max_write limit?  For that a
better solution would be to add it to /etc/fuse.conf.

But I have doubts about whether this is useful.

Thanks,
Miklos
