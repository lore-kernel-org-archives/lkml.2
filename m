Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954Ab2EJUfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 16:35:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:50804 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872Ab2EJUfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 16:35:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="139237180"
Message-ID: <4FAC26A5.3050606@intel.com>
Date: Thu, 10 May 2012 13:35:49 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Jonathan Nieder <jrnieder@gmail.com>
CC: David Miller <davem@davemloft.net>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, stephen.s.ko@intel.com,
        jeffrey.t.kirsher@intel.com
Subject: Re: [ 33/52] net: Fix issue with netdev_tx_reset_queue not resetting
 queue from XOFF state
References: <20120510173135.772550373@linuxfoundation.org> <4FAC0EA7.3000100@intel.com> <20120510.145510.1040533529305157641.davem@davemloft.net> <20120510194658.GA9858@burratino>
In-Reply-To: <20120510194658.GA9858@burratino>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2012 12:46 PM, Jonathan Nieder wrote:
> David Miller wrote:
>> From: Alexander Duyck <alexander.h.duyck@intel.com>
>>> All of the changes in igb are unnecessary.  I think they can be dropped
>>> from the patch as they have already been reverted from the latest
>>> net-next.  The only change that is really needed is the piece in
>>> netdevice.h below.
>> Does it hurt?  If not, just let it be.
> Based on the commit description for dad8a3b3eaa0 ("igb, ixgbe:
> netdev_tx_reset_queue incorrectly called from tx init path"), yes, it
> hurts.  I don't know if it hurts enough to justify holding up this
> patch until dad8a3b3eaa0 hits mainline.
>
> |                            this sort of works in most cases except
> | when the number of real tx queues changes. When the number of real
> | tx queues changes netdev_tx_reset_queue() only gets called on the
> | new number of queues so when we reduce the number of queues we risk
> | triggering the watchdog timer and repeated device resets.
> |
> | So this is not only a cosmetic issue but causes real bugs. For
> | example enabling/disabling DCB or FCoE in ixgbe will trigger this.
I'm fairly certain we really shouldn't make the changes to igb.  I would
say to just modify the existing patch by just dropping the igb portion
of it and it would be fine.

Thanks,

Alex
