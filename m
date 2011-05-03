Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab1ECRnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:43:31 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:40756 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab1ECRna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:43:30 -0400
Subject: Re: [PATCH V3 2/8] Add a new zerocopy device flag
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: David Miller <davem@davemloft.net>, Eric Dumazet <eric.dumazet@gmail.com>,
        Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110502195302.GA25619@redhat.com>
References: <1303328216.19336.18.camel@localhost.localdomain>
	 <1303328648.19336.24.camel@localhost.localdomain>
	 <20110502104257.GA21625@redhat.com>
	 <1304362028.20660.15.camel@localhost.localdomain>
	 <20110502195302.GA25619@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 May 2011 10:42:50 -0700
Message-ID: <1304444570.20660.32.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-02 at 22:53 +0300, Michael S. Tsirkin wrote:
> On Mon, May 02, 2011 at 11:47:08AM -0700, Shirley Ma wrote:
> > On Mon, 2011-05-02 at 13:42 +0300, Michael S. Tsirkin wrote:
> > > This comment should specify what exactly is the promise the
> > > device makes by setting this flag. Specifically, the
> > > condition is that no skb fragments are used
> > > after the uinfo callback has been called.
> > > 
> > > The way it's implemented, it probably means the device
> > > should not use any of skb_clone, expand head etc.
> > 
> > Agree. Or maybe force a copy when device uses skb_clone, expand
> > head ...?
> > 
> > Thanks
> > Shirley
> 
> Copy from userspace upfront without locking is probably cheaper? 

Better to prevent this kind of skbs to be used in skb_clone, expand head
for now.

Thanks
Shirley

