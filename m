Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab1HKOSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:18:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54548 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab1HKOSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 10:18:42 -0400
Date: Thu, 11 Aug 2011 07:16:04 -0700
From: Greg KH <gregkh@suse.de>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Raja Mani <rmani@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree
 (wireless & staging trees related)
Message-ID: <20110811141604.GA14763@suse.de>
References: <20110811155529.e5f47afa0504c4ddef58ab37@canb.auug.org.au>
 <4E438D56.5020801@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E438D56.5020801@qca.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 11:05:42AM +0300, Kalle Valo wrote:
> Hi Stephen,
> 
> On 08/11/2011 08:55 AM, Stephen Rothwell wrote:
> > After merging the final tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> > 
> > drivers/staging/built-in.o: In function `aggr_recv_delba_req_evt':
> > (.opd+0x23a60): multiple definition of `aggr_recv_delba_req_evt'
> > drivers/net/built-in.o:(.opd+0x79980): first defined here
> > drivers/staging/built-in.o: In function `.wlan_node_reclaim':
> > (.text+0x303360): multiple definition of `.wlan_node_reclaim'
> > drivers/net/built-in.o:(.text+0xdd0618): first defined here
> > drivers/staging/built-in.o: In function `aggr_init':
> > (.opd+0x23a00): multiple definition of `aggr_init'
> > drivers/net/built-in.o:(.opd+0x79968): first defined here
> > drivers/staging/built-in.o: In function `.aggr_recv_delba_req_evt':
> > (.text+0x302614): multiple definition of `.aggr_recv_delba_req_evt'
> > drivers/net/built-in.o:(.text+0xdc8b60): first defined here
> > drivers/staging/built-in.o: In function `.wlan_node_table_cleanup':
> > (.text+0x303888): multiple definition of `.wlan_node_table_cleanup'
> > drivers/net/built-in.o:(.text+0xdd0a6c): first defined here
> > 
> > You get the idea. :-(  So, the ath6kl driver now exists in the wireless
> > tree and the staging tree.
> > 
> > I applied this patch for today (I have elided the part from "rm -rf
> > drivers/staging/ath6kl"):
> 
> Oh man, sorry about this (again). I did compile both drivers at the same
> time, but only as modules and didn't realise the conflicts also with the
> staging driver.
> 
> Yes, the cleaned up version of ath6kl is now in wireless-next and the
> staging version can be removed in 3.2. Greg, how do you want to handle
> removal of the staging version? Should I send a patch to you removing
> it? Or should I send the patch to John?

Just tell me.  Should I really delete drivers/staging/ath6kl/ for the
3.2 kernel release?  If so, I'll gladly do so in my tree so linux-next
will be fine for issues like this in the future.

greg k-h
