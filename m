Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab0FNOR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 10:17:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451Ab0FNORz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 10:17:55 -0400
Date: Mon, 14 Jun 2010 17:13:13 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: john.r.fastabend@intel.com, markus@trippelsdorf.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       yanmin_zhang@linux.intel.com, alex.shi@intel.com, tim.c.chen@intel.com
Subject: Re: mpd client timeouts (bisected) 2.6.35-rc3
Message-ID: <20100614141313.GB25547@redhat.com>
References: <20100612.145835.123986343.davem@davemloft.net> <4C149147.3080808@intel.com> <4C15414E.5090201@intel.com> <20100613.171318.193707256.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100613.171318.193707256.davem@davemloft.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 13, 2010 at 05:13:18PM -0700, David Miller wrote:
> From: John Fastabend <john.r.fastabend@intel.com>
> Date: Sun, 13 Jun 2010 13:36:30 -0700
> 
> > Needed to set the wcard bit in copy_skb_header otherwise it will not
> > be cleared when called from skb_clone.  Which then hits the loopback
> > device gets pushed into the rx path and is eventually dropped. The
> > following patch fixes this. Hopefully, this is easy and fast enough
> > for you Dave.
> > 
> > 
> > [PATCH] net: fix deliver_no_wcard regression on loopback device
> > 
> > deliver_no_wcard is not being set in skb_copy_header.
> > In the skb_cloned case it is not being cleared and
> > may cause the skb to be dropped when the loopback device
> > pushes it back up the stack.
> > 
> > Signed-off-by: John Fastabend <john.r.fastabend@intel.com>
> 
> Applied, but your email client corrupted this patch in many
> ways.  Please correct this for next time, thanks.

FWIW:

Tested-by: Michael S. Tsirkin <mst@redhat.com>

-- 
MST
