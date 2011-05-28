Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab1E1SHZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 14:07:25 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35815 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144Ab1E1SHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 14:07:24 -0400
Subject: Re: [PATCH V6 0/4 net-next] macvtap/vhost TX zero-copy support
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: David Miller <davem@davemloft.net>, Eric Dumazet <eric.dumazet@gmail.com>,
        Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1306441885.5180.52.camel@localhost.localdomain>
References: <1306440020.5180.47.camel@localhost.localdomain>
	 <20110526202836.GA1951@redhat.com>
	 <1306441885.5180.52.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 28 May 2011 11:07:03 -0700
Message-ID: <1306606023.5180.67.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 13:31 -0700, Shirley Ma wrote:
> On Thu, 2011-05-26 at 23:28 +0300, Michael S. Tsirkin wrote:
> > On Thu, May 26, 2011 at 01:00:20PM -0700, Shirley Ma wrote:
> > > 3. Add sleep in vhost shutting down instead of busy-wait for
> > outstanding
> > >    DMAs.
> > 
> > I still think this is not much better. We need to use a
> > completion structure and wait on it instead.
> > If this gets blocked thinkably a tx watchdog can fire and save us
> > from blocking forver :) 
> 
> Ok, I can add a completion structure here. 

The code here doesn't block forever during shutdown, it will release all
outstanding userspace buffers anyway, see vhost_zerocopy_signal_used()
shutdown case.

Thanks
Shirley

