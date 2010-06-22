Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab0FVQGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 12:06:37 -0400
Received: from acsinet14.oracle.com ([141.146.126.236]:23926 "EHLO
	acsinet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab0FVQG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 12:06:26 -0400
X-Greylist: delayed 354 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jun 2010 12:06:25 EDT
Date: Tue, 22 Jun 2010 08:59:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 22 (staging/spectra)
Message-Id: <20100622085903.4232617d.randy.dunlap@oracle.com>
In-Reply-To: <20100622083032.8abe1605.randy.dunlap@oracle.com>
References: <20100622160518.2ef7afcc.sfr@canb.auug.org.au>
	<20100622083032.8abe1605.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4C20DE0F.00DE:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jun 2010 08:30:32 -0700 Randy Dunlap wrote:

> On Tue, 22 Jun 2010 16:05:18 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20100621:
> > 
> > My fixes tree contains:
> >       v4l-dvb: update gfp/slab.h includes
> >       arm: update gfp/slab.h includes
> >       davinci: update gfp/slab.h includes
> >       ocfs2: update gfp/slab.h includes
> >       acpi: update gfp/slab.h includes
> 
> 
> drivers/staging/spectra/ffsport.c:307: error: implicit declaration of function 'blk_fs_request'
> 
> Where is this function??

The macro was deleted from include/linux/blkdev.h.  Just change that line to

-	if (!blk_fs_request(req))
+	if (req->cmd_type != REQ_TYPE_FS)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
