Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab1G0OC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 10:02:28 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51823 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab1G0OCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 10:02:25 -0400
Date: Wed, 27 Jul 2011 09:53:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: hubert Liao <liao.hubertt@gmail.com>
Cc: wlanfae@realtek.com, Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Oops when insmod rtl8192ce
Message-ID: <20110727135353.GA16431@tuxdriver.com>
References: <CAMzZzFGqPv6Nbw8J8JGNKcLA76sAs3oD6+hH9NPCjwA33fYpOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMzZzFGqPv6Nbw8J8JGNKcLA76sAs3oD6+hH9NPCjwA33fYpOQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 05:20:15PM +0800, hubert Liao wrote:
> Hi,
> 
> We got an oops when insmod rtl8192ce module (the board is an ARM soc),
> accroding the oops message, find it's because in rtl_pci_probe() called
> _rtl_pci_find_adapter(),
> in this funcation, the  pdev->bus->self is a NULL pointer .
> 
> static boot _rtl_pci_find_adapter(strcut pci_dev *dev,
>               struct ieee80211_hw *hw)
> {
> 
> struct pci_dev *bridge_pdev = pdev->bus->self;   //line 1601
> ...
> 
> pcipriv->ndis_adapter.pcibridge_vendorid = bridge_pdev->vendor; <-- [oops
> here] line 1700
> 
> ...
> }
> 
> here, I just want to know why the bus->self  is NULL?

pdev is coming straight from what is passed to the PCI probe routine.
It seems like pdev->bus->self should already be set before that
happens.

Please open a bug at bugzilla.kernel.org to help us keep track of
this -- thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
