Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab2K3Bxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 20:53:45 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53292 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab2K3Bxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 20:53:44 -0500
Date: Thu, 29 Nov 2012 17:53:40 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: Re: [PATCH 187/270] net/wireless: ipw2200: Fix panic occurring in
 ipw_handle_promiscuous_tx()
Message-ID: <20121130015340.GH13478@kroah.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
 <1353949160-26803-188-git-send-email-herton.krzesinski@canonical.com>
 <1354031931.4266.57.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354031931.4266.57.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 03:58:51PM +0000, Ben Hutchings wrote:
> On Mon, 2012-11-26 at 14:57 -0200, Herton Ronaldo Krzesinski wrote:
> > 3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
> > 
> > commit bf11315eeda510ea4fc1a2bf972d8155d31d89b4 upstream.
> > 
> > The driver does not count space of radiotap fields when allocating skb for
> > radiotap packet. This leads to kernel panic with the following call trace:
> > 
> > ...
> > [67607.676067] [<c152f90f>] error_code+0x67/0x6c
> > [67607.676067] [<c142f831>] ? skb_put+0x91/0xa0
> > [67607.676067] [<f8cf5e5b>] ? ipw_handle_promiscuous_tx+0x16b/0x2d0 [ipw2200]
> > [67607.676067] [<f8cf5e5b>] ipw_handle_promiscuous_tx+0x16b/0x2d0 [ipw2200]
> > [67607.676067] [<f8cf899b>] ipw_net_hard_start_xmit+0x8b/0x90 [ipw2200]
> > [67607.676067] [<f8741c5a>] libipw_xmit+0x55a/0x980 [libipw]
> > [67607.676067] [<c143d3e8>] dev_hard_start_xmit+0x218/0x4d0
> > ...
> > 
> > This bug was found by VittGam.
> > https://bugzilla.kernel.org/show_bug.cgi?id=43255
> > 
> > Signed-off-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> 
> This is missing from 3.4; it may just need de-fuzzing to apply.

Odd, it applies just fine, I wonder how I missed it.

thanks,

greg k-h
