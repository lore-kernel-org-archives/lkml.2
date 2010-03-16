Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966466Ab0CPPCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 11:02:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34767 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966452Ab0CPPCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 11:02:42 -0400
Subject: Re: ATA 4 KiB sector issues.
From: James Bottomley <James.Bottomley@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Arnd Bergmann <arnd@arndb.de>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
In-Reply-To: <4B9F9AAF.6080709@kernel.org>
References: <4B947393.2050002@kernel.org> <201003100046.24695.arnd@arndb.de>
	 <1158166a1003100114j6ea329fbh84bfad65dcac90bf@mail.gmail.com>
	 <4B9EED55.10201@kernel.org> <1268720060.21384.10.camel@mulgrave.site>
	 <4B9F2388.2030803@kernel.org> <1268745897.21384.14.camel@mulgrave.site>
	 <4B9F8E1A.2020608@kernel.org> <1268749297.21384.15.camel@mulgrave.site>
	 <4B9F9AAF.6080709@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 08:02:28 -0700
Message-ID: <1268751748.21384.18.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 23:50 +0900, Tejun Heo wrote:
> e.g.  If the first partition begins at CHS 0/32/33 and ends at
> 12/233/19 and the corresponding LBA addresses are 2048 and 206848, you
> can solve the equation and determine that the parameters gotta be 63
> secs/trk and 255 heads/cyl to make those two pairs of addresses match
> each other and in fact some BIOSs try to do this depending on
> configuration (and sometimes falls into infinite loop or causes other
> boot related problems if the parameters are too uncommon).

for an msdos label, this is illegal, that was Arnd's point.  The
partitions have to begin and end on cylinder boundaries*.  Knowing that,
you can deduce the geometry from the last sector entry.

James

* at least if you want to preserve windows compatibility, which is what
most of our partitioning tools seem to do.


