Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630Ab1COU7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 16:59:50 -0400
Received: from mail.atheros.com ([12.19.149.2]:37184 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758289Ab1COU7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 16:59:49 -0400
Date: Tue, 15 Mar 2011 13:59:46 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bob Copeland <me@bobcopeland.com>
CC: Christoph Lameter <cl@linux.com>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Nick Piggin <npiggin@kernel.dk>, "Dave Chinner" <dchinner@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "Jiri Slaby" <jirislaby@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        "Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: <IRQ> [<ffffffff810c9204>] ? __alloc_pages_nodemask+0x622/0x696
Message-ID: <20110315205946.GL11878@tux>
References: <AANLkTikaLb_xan2ePfo9JCZ1w7RZ76wF8NUT2tYr0ZD=@mail.gmail.com>
 <alpine.DEB.2.00.1103051847100.8779@chino.kir.corp.google.com>
 <4D770178.9070908@gmail.com>
 <alpine.DEB.2.00.1103091254540.13353@chino.kir.corp.google.com>
 <4D77EEB4.9090404@gmail.com>
 <alpine.DEB.2.00.1103091549020.16989@router.home>
 <20110310000502.GA13763@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110310000502.GA13763@hash.localnet>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 04:05:02PM -0800, Bob Copeland wrote:
> On Wed, Mar 09, 2011 at 03:54:24PM -0600, Christoph Lameter wrote:
> > [ 7419.322770] wlan0: associated
> > [ 7427.161366] ath: Failed to stop TX DMA in 100 msec after killing last frame
> > [ 7427.161432] ath: Failed to stop TX DMA!
> > [ 7434.492398] ath: Failed to stop TX DMA in 100 msec after killing last frame
> > [ 7434.492462] ath: Failed to stop TX DMA!
> > [ 7603.339047]
> > =============================================================================
> > [ 7603.339053] BUG radix_tree_node: Padding overwritten. 0xffff88000008fe00-0xffff88000008fe32
> 
> > Could the ath driver corrupt memory if the TX DMA cannot be stopped?

Yes, this is why we have had a series of patches to address this upstream,
the latest one was for RX DMA failing to stop but Felix found a fix for that.
Apart from that I am not aware of more issues. Can you please try with
wireless-testing.git ?

  Luis
