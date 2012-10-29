Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552Ab2J2Rc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:32:59 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:56103 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab2J2Rc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:32:58 -0400
Date: Mon, 29 Oct 2012 20:30:31 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] zram: handle mem suffixes in disk size zram_sysfs
 parameter
Message-ID: <20121029173031.GB3706@swordfish.minsk.epam.com>
References: <20121027160347.GB4771@swordfish>
 <508EBB1E.9060400@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508EBB1E.9060400@vflare.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (10/29/12 10:21), Nitin Gupta wrote:
> >+#include <linux/kernel.h>
> >
> >  #include "zram_drv.h"
> >
> >@@ -54,13 +55,12 @@ static ssize_t disksize_show(struct device *dev,
> >  static ssize_t disksize_store(struct device *dev,
> >  		struct device_attribute *attr, const char *buf, size_t len)
> >  {
> >-	int ret;
> >  	u64 disksize;
> >  	struct zram *zram = dev_to_zram(dev);
> >
> >-	ret = kstrtoull(buf, 10, &disksize);
> >-	if (ret)
> >-		return ret;
> >+	disksize = memparse(buf, NULL);
> >+	if (disksize < 1)
> >+		return -EINVAL;
> >
> 
> or, just: if (!disksize) ...
> 

will resend shortly.

	-ss
