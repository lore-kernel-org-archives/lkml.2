Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab2ENTCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 15:02:36 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63876 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757262Ab2ENTCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 15:02:34 -0400
Subject: Re: [PATCH RFC] tun: experimental zero copy tx support
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ian.Campbell@citrix.com,
        kvm@vger.kernel.org
In-Reply-To: <20120514170412.GA17086@redhat.com>
References: <20120513155206.GA26847@redhat.com>
	 <20120514095446.3ce307d2@nehalam.linuxnetplumber.net>
	 <20120514170412.GA17086@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 May 2012 21:02:26 +0200
Message-ID: <1337022146.8512.606.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 20:04 +0300, Michael S. Tsirkin wrote:
> On Mon, May 14, 2012 at 09:54:46AM -0700, Stephen Hemminger wrote:
> > On Sun, 13 May 2012 18:52:06 +0300
> > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > 
> > > +		/* Userspace may produce vectors with count greater than
> > > +		 * MAX_SKB_FRAGS, so we need to linearize parts of the skb
> > > +		 * to let the rest of data to be fit in the frags.
> > > +		 */
> > Rather than complex partial code, just go through slow path for
> > requests with too many frags (or for really small requests).
> > Creating mixed skb's seems too easy to get wrong.
> 
> I don't object in principle but macvtap has same code
> so seems better to stay consistent.
> 

If I remember well, code in vtap was buggy and still is.

Jason Wang fixes are not yet in, so maybe wait a bit, so that we dont
add a pile of new bugs ?




