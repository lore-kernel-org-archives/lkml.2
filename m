Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab0FOEXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 00:23:35 -0400
Received: from ozlabs.org ([203.10.76.45]:45563 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab0FOEXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 00:23:33 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH for-2.6.35] virtio_net: fix oom handling on tx
Date: Tue, 15 Jun 2010 13:53:29 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Stephen Hemminger <shemminger@vyatta.com>,
       Sridhar Samudrala <sri@us.ibm.com>,
       virtualization@lists.linux-foundation.org,
       Jiri Pirko <jpirko@redhat.com>, Shirley Ma <xma@us.ibm.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100610152041.GA3480@redhat.com> <20100610104653.1aed2ecc@nehalam> <20100610190343.GC4044@redhat.com>
In-Reply-To: <20100610190343.GC4044@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006151353.30529.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 04:33:43 am Michael S. Tsirkin wrote:
> On Thu, Jun 10, 2010 at 10:46:53AM -0700, Stephen Hemminger wrote:
> > It makes more sense to have the device increment tx_droppped, 
> > and return NETDEV_TX_OK. Skip the message (or make it a pr_debug()). 
> > Network devices do not guarantee packet delivery, and if out of
> > resources then holding more data in the
> > queue is going to hurt not help the situation.

Yes, actually oom should be a ratelimited message and TX_OK, the other
case is a "should never happen" logic bug which warrants an error and
I don't care what it returns (whatever's easiest).

Please fix both at once since you're touching it.

Thanks,
Rusty.
