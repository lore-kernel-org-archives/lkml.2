Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965096Ab0COOtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 10:49:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36659 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965030Ab0COOtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 10:49:16 -0400
Message-ID: <4B9E489F.6040709@zytor.com>
Date: Mon, 15 Mar 2010 07:47:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: david@lang.hm, Arnd Bergmann <arnd@arndb.de>, Tejun Heo <tj@kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org> <201003150326.22262.vda.linux@googlemail.com> <alpine.DEB.2.00.1003142216380.15263@asgard.lang.hm> <201003151056.05833.vda.linux@googlemail.com>
In-Reply-To: <201003151056.05833.vda.linux@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2010 02:56 AM, Denys Vlasenko wrote:
> I think Linux already is doing this. The problem is, in many cases
> OS can't possibly do this, short of using a specially designed
> filesystem.
> 
> If you untar a Linux kernel source tarball on a seriously
> fragmented ext2 filesystem, there will be a lot of discontiguous
> and/or misaligned writes smaller than 256K.
> Only smart firmware can help in this case.

Yes, but guess what... there is a lot of stupid firmware out there, and
there are lots of RAID arrays, and so on.

"Seriously fragmented" means you have already lost in the first place.

This doesn't change the fact that this is a real issue and that that is
the major reason why aligning to 63*4K is a bad idea.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

