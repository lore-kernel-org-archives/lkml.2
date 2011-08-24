Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab1HXVRC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:17:02 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:50859 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753706Ab1HXVQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:16:59 -0400
X-Sasl-enc: QIBr0n6ed4MpIsM/T0lsQd8BXZz+nE76RmYj5SPHgXxh 1314220618
Date: Wed, 24 Aug 2011 14:16:46 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        edwin_rong <edwin_rong@realsil.com.cn>
Subject: Re: linux-next: build failure after merge of the final tree (staging
 tree related)
Message-ID: <20110824211646.GB9707@kroah.com>
References: <20110824154741.3cbe03b403b646e2a99d63a2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110824154741.3cbe03b403b646e2a99d63a2@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 03:47:41PM +1000, Stephen Rothwell wrote:
> Hi ,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/staging/rts5139/rts51x_scsi.c: In function 'inquiry':
> drivers/staging/rts5139/rts51x_scsi.c:498:2: error: implicit declaration of function 'vmalloc'
> drivers/staging/rts5139/xd.c: In function 'xd_init_l2p_tbl':
> drivers/staging/rts5139/xd.c:745:2: error: implicit declaration of function 'vmalloc'
> drivers/staging/rts5139/xd.c: In function 'free_zone':
> drivers/staging/rts5139/xd.c:771:3: error: implicit declaration of function 'vfree'
> drivers/staging/rts5139/ms.c: In function 'ms_init_l2p_tbl':
> drivers/staging/rts5139/ms.c:2214:2: error: implicit declaration of function 'vmalloc'
> drivers/staging/rts5139/ms.c:2257:3: error: implicit declaration of function 'vfree'
> 
> Caused by commit 1dac4186bcc6 ("Staging: add driver for Realtek RTS5139
> cardreader").
> 
> I have reverted that commit for today.

To fix it, all we have to do is include linux/vmalloc.h, right?  Or is
ppc "special" in some other way regarding this call?

thanks,

greg k-h
