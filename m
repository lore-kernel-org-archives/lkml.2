Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab0GKGKP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 02:10:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51898
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750873Ab0GKGKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 02:10:12 -0400
Date: Sat, 10 Jul 2010 23:10:26 -0700 (PDT)
Message-Id: <20100710.231026.233698429.davem@davemloft.net>
To: joe@perches.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, gregkh@suse.de, James.Bottomley@suse.de,
       matthew@wil.cx, linux-scsi@vger.kernel.org
Subject: Re: [PATCH net-next] drivers/scsi: Remove warnings after vsprintf
 %pV introduction
From: David Miller <davem@davemloft.net>
In-Reply-To: <1278824921.1501.37.camel@Joe-Laptop.home>
References: <1278562423.1712.43.camel@Joe-Laptop>
	<20100710.195210.200371025.davem@davemloft.net>
	<1278824921.1501.37.camel@Joe-Laptop.home>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sat, 10 Jul 2010 22:08:41 -0700

> On Sat, 2010-07-10 at 19:52 -0700, David Miller wrote:
>> Could you take a stab at this and the other scsi bits that
>> trigger this warning?
> 
> Remove warnings introduced by conversions of dev_<level>
> macros to functions.
> 
> Compile tested only.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

SCSI folks, the background is that we have moved the dev_*() printk
macros to external functions, so that the prefixing printf strings
don't get emitting at every call site.

As a consequence, dev_*() calls that try to use an empty string as the
printf format emit a warning from gcc since an empty constant string
is not a valid printf format.

That's what this change is all about.

Anyways:

Acked-by: David S. Miller <davem@davemloft.net>
