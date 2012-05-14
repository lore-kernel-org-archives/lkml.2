Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab2ENQyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:54:54 -0400
Received: from mail.vyatta.com ([76.74.103.46]:45651 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757251Ab2ENQyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:54:49 -0400
Date: Mon, 14 May 2012 09:54:46 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ian.Campbell@citrix.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFC] tun: experimental zero copy tx support
Message-ID: <20120514095446.3ce307d2@nehalam.linuxnetplumber.net>
In-Reply-To: <20120513155206.GA26847@redhat.com>
References: <20120513155206.GA26847@redhat.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2012 18:52:06 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> +		/* Userspace may produce vectors with count greater than
> +		 * MAX_SKB_FRAGS, so we need to linearize parts of the skb
> +		 * to let the rest of data to be fit in the frags.
> +		 */
Rather than complex partial code, just go through slow path for
requests with too many frags (or for really small requests).
Creating mixed skb's seems too easy to get wrong.
