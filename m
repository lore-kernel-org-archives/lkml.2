Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933405Ab0J2IEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 04:04:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137Ab0J2IDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 04:03:53 -0400
Date: Fri, 29 Oct 2010 10:03:47 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] vhost: TX used buffer guest signal accumulation
Message-ID: <20101029080347.GA22688@redhat.com>
References: <1288216693.17571.38.camel@localhost.localdomain>
 <1288240804.14342.1.camel@localhost.localdomain>
 <20101028052021.GD5599@redhat.com>
 <1288294355.11251.20.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288294355.11251.20.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 12:32:35PM -0700, Shirley Ma wrote:
> On Thu, 2010-10-28 at 07:20 +0200, Michael S. Tsirkin wrote:
> > My concern is this can delay signalling for unlimited time.
> > Could you pls test this with guests that do not have
> > 2b5bbe3b8bee8b38bdc27dd9c0270829b6eb7eeb
> > b0c39dbdc204006ef3558a66716ff09797619778
> > that is 2.6.31 and older? 
> 
> The patch only induces delay signaling unlimited time when there is no
> TX packet to transmit. I thought TX signaling only noticing guest to
> release the used buffers, anything else beside this?

Right, that's it I think. For newer kernels we orphan the skb
on xmit so we don't care that much about completing them.
This does rely on an undocumented assumption about guest
behaviour though.

> I tested rhel5u5 guest (2.6.18 kernel), it works fine. I checked the two
> commits log, I don't think this patch could cause any issue w/o these
> two patches.
> 
> Also I found a big TX regression for old guest and new guest. For old
> guest, I am able to get almost 11Gb/s for 2K message size, but for the
> new guest kernel, I can only get 3.5 Gb/s with the patch and same host.
> I will dig it why.
> 
> thanks
> Shirley
