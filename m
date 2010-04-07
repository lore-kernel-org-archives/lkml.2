Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab0DGWhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 18:37:33 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:41833 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab0DGWh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 18:37:29 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEADelvEurR7H+/2dsb2JhbACbKHGiBpkahQkEgyQ
X-IronPort-AV: E=Sophos;i="4.52,165,1270425600"; 
   d="scan'208";a="179711076"
From: Roland Dreier <rdreier@cisco.com>
To: "L. Alberto =?utf-8?Q?Gim=C3=A9nez?=" <agimenez@sysvalve.es>
Cc: linux-kernel@vger.kernel.org, dgiagio@gmail.com, dborca@yahoo.com,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "David S. Miller" <davem@davemloft.net>,
       Jonas =?utf-8?Q?Sj=C3=B6quist?= <jonas.sjoquist@ericsson.com>,
       Steve Glendinning <steve.glendinning@smsc.com>,
       Torgny Johansson <torgny.johansson@gmail.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Omar Laazimani <omar.oberthur@gmail.com>, linux-usb@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH Resubmission] drivers/net/usb: Add new driver ipheth
References: <1269984864-28159-1-git-send-email-agimenez@sysvalve.es>
	<1270678281-20750-1-git-send-email-agimenez@sysvalve.es>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 07 Apr 2010 15:37:15 -0700
In-Reply-To: <1270678281-20750-1-git-send-email-agimenez@sysvalve.es>
	("L. Alberto =?utf-8?Q?Gim=C3=A9nez=22's?= message of "Thu, 8 Apr 2010
 00:11:20 +0200")
Message-ID: <ada6342zy78.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are a few of the cosmetic issues alluded to, and by no means merge
blockers, but:

 > +	schedule_delayed_work(&dev->carrier_work, IPHETH_CARRIER_CHECK_TIMEOUT);

Seems this might as well be round_jiffies_relative(IPHETH_CARRIER_CHECK_TIMEOUT)
to avoid extra wakeups.

 > +	netdev = alloc_etherdev(sizeof(struct ipheth_device));

This means that the interface will get an ethX name and look to
networkmanager et al like an ethernet device.  Seems we would maybe want
to make this a "wwan" type device (cf drivers/net/usb/usbnet.c and how
it handles FLAG_WWAN)?

 - R.
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
