Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab2DRRYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 13:24:39 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:48595 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab2DRRXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 13:23:53 -0400
Date: Wed, 18 Apr 2012 19:23:49 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Lasse Collin <lasse.collin@tukaani.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@xenotime.net>,
        qasdfgtyuiop <qasdfgtyuiop@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, alain@knaff.lu,
        albin.tonnerre@free-electrons.com
Subject: Re: [PATCH] kconfig: update compression algorithm info
Message-ID: <20120418172349.GA6165@x4>
References: <CAMtaSwTi=7rmG8diJ+K0c_CcV=0TcgXDjRFEdZGGiKE2K5x89A@mail.gmail.com>
 <4F8DF90B.1090002@xenotime.net>
 <20120418194055.2d929e58@tukaani.org>
 <4F8EEFB5.8040604@zytor.com>
 <20120418200929.086ce3a7@tukaani.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120418200929.086ce3a7@tukaani.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.04.18 at 20:09 +0300, Lasse Collin wrote:
> On 2012-04-18 H. Peter Anvin wrote:
> > On 04/18/2012 09:40 AM, Lasse Collin wrote:
> > >   - LZO should give the fastest boot from a hard disk (desktop
> > >     systems where file size doesn't matter much).
> > 
> > That really depends on the speed of your disk vs CPU.
> 
> Yes. Maybe it isn't good to give so clear recommendation for LZO over
> gzip here.
> 
> I think it is still safe to say that gzip and LZO are better than
> bzip2, XZ, or LZMA for compressing a kernel that will be loaded from a
> normal hard disk. It would be unusual if reading the disk was so slow
> that e.g. XZ would make the booting faster than gzip.

When btrfs will finally implement LZ4 compression this would be the obvious
candidate for the fastest boot algo, because its decompression speed is
amazing.

For example here is a comparison with LZO on boot/compressed/vmlinux.bin:

memcpy               = 75 ms (10251 MB/s), 13436968->13436968
Codec         version    args       Size (Ratio)    C.Speed      D.Speed
LZ4               r59      12    4952064 (x 2.71)   C: 518 MB/s  D:1472 MB/s
LZO              2.05     1x1    4825088 (x 2.78)   C: 472 MB/s  D: 504 MB/s

-- 
Markus
