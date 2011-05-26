Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758505Ab1EZU2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 16:28:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757300Ab1EZU2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 16:28:43 -0400
Date: Thu, 26 May 2011 23:28:36 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: David Miller <davem@davemloft.net>, Eric Dumazet <eric.dumazet@gmail.com>,
        Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V6 0/4 net-next] macvtap/vhost TX zero-copy support
Message-ID: <20110526202836.GA1951@redhat.com>
References: <1306440020.5180.47.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306440020.5180.47.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 01:00:20PM -0700, Shirley Ma wrote:
> 3. Add sleep in vhost shutting down instead of busy-wait for outstanding
>    DMAs.

I still think this is not much better. We need to use a
completion structure and wait on it instead.
If this gets blocked thinkably a tx watchdog can fire and save us
from blocking forver :)
