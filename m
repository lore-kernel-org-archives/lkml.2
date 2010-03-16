Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937414Ab0CPCbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 22:31:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:41204 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937358Ab0CPCbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 22:31:39 -0400
Message-ID: <4B9EED55.10201@kernel.org>
Date: Tue, 16 Mar 2010 11:30:45 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: Arnd Bergmann <arnd@arndb.de>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org> <201003100046.24695.arnd@arndb.de> <1158166a1003100114j6ea329fbh84bfad65dcac90bf@mail.gmail.com>
In-Reply-To: <1158166a1003100114j6ea329fbh84bfad65dcac90bf@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Mar 2010 02:30:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/10/2010 06:14 PM, Denys Vlasenko wrote:
> 63s/255h is more or less "standard" now.
> 
> Alignment issues can be solved by picking a good multiple of
> _heads_ or _cylinders_:

I've got a couple of comments stating that picking a good geometry
parameters can resolve the whole issue but I simply fail to see how it
could.  We can pick any parameter we wish, but there is no reliable
way to communicate the custom geometry parameters to others.

Geometry is determined by two parameters sec/trk and heads/cyl.  You
can punch in those numbers if the BIOS has a menu for it (many don't
these days).  Or hope that BIOS can somehow figure it out from the
partition table which some BIOSs actually try to do.  The problem is
that to determine the two parameters you need to equations matching
CHSs and LBAs and that's available iff the first partition ends before
CHS addressing limit according to the custom geometry, which usually
is not the case.

So, custom geometry is only useful to trick partitioners which align
using cylinders into using better alignments but doesn't help anything
for compatibility as no one can determine the used geometry reliably
after the partitioning is complete.  With compatibility benefit gone,
there simply is no reason to stick to the cylinder abstraction at all.

Am I missing something?

Thanks.

-- 
tejun
