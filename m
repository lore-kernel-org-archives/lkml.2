Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab0LHQU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 11:20:28 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39081 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab0LHQU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 11:20:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HarfgKiPB4W9D022qA+VnbXxGAGTVVkiLJFDebCj6f4BcZxDwW4yB/1ahfjJ8YU9b6
         LtzpxHqAhOkwb3x3YzjwhxM0sAfuh8g5qmDyQYV5/N32PjVX/64CkU18JoXa9kDVf0uv
         UrV1/Afpgz/vjuLgNxldTmpqeI/CF3tzVLazw=
Subject: Re: [PATCH 1/3] [SCSI] dpt_i2o: fix compiler warning on dptids
From: Namhyung Kim <namhyung@gmail.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1291742693.1638.22.camel@leonhard>
References: <1291735896-14541-1-git-send-email-namhyung@gmail.com>
	 <1291737421.17668.5.camel@mulgrave.site> <1291738348.1638.9.camel@leonhard>
	 <1291739449.17668.9.camel@mulgrave.site>
	 <1291742693.1638.22.camel@leonhard>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 01:20:20 +0900
Message-ID: <1291825220.1741.9.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-12-08 (수), 02:24 +0900, Namhyung Kim:
> 2010-12-07 (화), 10:30 -0600, James Bottomley:
> > On Wed, 2010-12-08 at 01:12 +0900, Namhyung Kim wrote:
> > > MODULE_DEVICE_TABLE expands to nop when !MODULE (not !CONFIG_MODULE) so
> > > allyesconfig build always emits the warnings. Possible patch for this
> > > would be wraping it up in #ifdefs but when I sent a same patch to Greg
> > > KH he didn't want to add more #ifdefs in .c files.
> > 
> > I didn't mean changing any c files.  I meant fixing the module include
> > to make the table used even in the !MODULE case.  That way we only alter
> > one file instead of a significant proportion of the drivers.
> > 
> 
> It would not be a _significant_ proportion because normal drivers may
> refer the table in their driver struct. :)
> 
> Anyway the patch below looks good to me. I'll happily drop my patches if
> you apply this in your tree.
> 

Hi,

As akpm told me, using DEFINE_PCI_DEVICE_TABLE could also remove the
warnings (probably by making the table const) but it still requires
modifying .c files. What do you think?


-- 
Regards,
Namhyung Kim


