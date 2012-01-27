Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab2A0UyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:54:25 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59059 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab2A0UyX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:54:23 -0500
MIME-Version: 1.0
In-Reply-To: <20120127182016.GA15705@infradead.org>
References: <1327688098-10159-1-git-send-email-geert@linux-m68k.org>
	<20120127182016.GA15705@infradead.org>
Date: Fri, 27 Jan 2012 21:54:22 +0100
X-Google-Sender-Auth: QiBlXd7JMbKZ_sFrfQciSsHOqbo
Message-ID: <CAMuHMdUbesGLdWSh3+JnM2GH_T4TeD3SD-Tb6pwEzYWL4k0g-g@mail.gmail.com>
Subject: Re: [PATCH] uml/hostfs: Propagate dirent.d_type to filldir()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Fri, Jan 27, 2012 at 19:20, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Jan 27, 2012 at 07:14:58PM +0100, Geert Uytterhoeven wrote:
>> Currently the (optional) d_type member in struct dirent is always
>> DT_UNKNOWN on hostfs, which may confuse buggy software using readdir().
>> Make sure to propagate its value from the underlying filesystem if it's
>> available there.
>
> What software would that be?  We have lots of filesystems not filling

Something proprietary, which got fixed in the mean time.

> in d_type, and several operating systems don't have it at all.

Almost all filesystems on a typical Ubuntu desktop or Android device fill it in.
Iso9660 is the notable exception.

Several of the more exotic ones probably don't support it. E.g. affs
fills it in for
directories only.

>From getdents(2):
       The d_type field is implemented since Linux 2.6.4.  It occupies a space
       that was previously a zero-filled  padding  byte  in  the  linux_dirent
       structure.   Thus,  on  kernels before 2.6.3, attempting to access this
       field always provides the value 0 (DT_UNKNOWN).

       Currently, only some file systems (among them: Btrfs, ext2,  ext3,  and
       ext4)  have  full  support  for returning the file type in d_type.  All
       applications must properly handle a return of DT_UNKNOWN.

If it's there, it saves lots of stat calls.
So I take it it's a good thing if it gets fixed?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
