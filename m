Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab2LBQeb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 11:34:31 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:42867 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab2LBQe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 11:34:29 -0500
Date: Mon, 3 Dec 2012 00:34:50 +0800
From: Wang YanQing <udknight@gmail.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: nic_swsd@realtek.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3]realtek:r8169: Bugfix or workaround for missing
 extended GigaMAC registers settings
Message-ID: <20121202163449.GA20796@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Francois Romieu <romieu@fr.zoreil.com>, nic_swsd@realtek.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20121130232152.GA10960@udknight>
 <20121201114401.GA3989@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121201114401.GA3989@electric-eye.fr.zoreil.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 01, 2012 at 12:44:01PM +0100, Francois Romieu wrote:
> Wang YanQing <udknight@gmail.com> :
> > +	/*
> > +	 *This is a fix for BIOS forget to set
> > +	 *extend GigaMAC registers
> > +	 *Wang YanQing 12/1/2012
> > +	 */
> 
> This part will go into the changelog.
I think brevity comment in code is good for
code's readableness. We read out the MAC{0,4},
and write them back in next line to call rtl_rar_set,
it don't have obvious sense for new readers, so I think 
the brevity comment is good. Could you consider remaining
the comment except the no sense line "Wang YanQing 12/1/2012"?

> 
> > +	if (tp->mac_version == RTL_GIGA_MAC_VER_34) {
> > +	    rtl_rar_set(tp, dev->dev_addr);
> > +	}
> 
> rtl_rar_set already includes a RTL_GIGA_MAC_VER_34 test and non-8168evl
> devices are already able to stand an extra MAC{0, 4} write. I'll check
> it does not hurt on different 81xx devices and submit an update.
I add the test code to ignore the an extra MAC{0,4} write for non-8168evl
devices, and if you think it is not a issue, then I agree with you to remove 
the test code.

Thanks.

