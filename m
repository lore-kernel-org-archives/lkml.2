Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab0INTUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:20:47 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:50608 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab0INTUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:20:45 -0400
Subject: Re: [RFC PATCH 2/2] macvtap: TX zero copy between guest and host
 kernel
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Avi Kivity <avi@redhat.com>,
        "Xin, Xiaohui" <xiaohui.xin@intel.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100914190156.GA16037@redhat.com>
References: <1284410580.13351.10.camel@localhost.localdomain>
	 <4C8F3C77.7010302@redhat.com>
	 <1284476719.13351.35.camel@localhost.localdomain>
	 <201009141721.13202.arnd@arndb.de> <20100914152231.GA13105@redhat.com>
	 <1284480025.13351.49.camel@localhost.localdomain>
	 <20100914162952.GB13560@redhat.com>
	 <1284483745.13351.71.camel@localhost.localdomain>
	 <20100914182707.GB15549@redhat.com>
	 <1284490143.13351.82.camel@localhost.localdomain>
	 <20100914190156.GA16037@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Sep 2010 12:20:29 -0700
Message-ID: <1284492029.13351.88.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-14 at 21:01 +0200, Michael S. Tsirkin wrote:
> On Tue, Sep 14, 2010 at 11:49:03AM -0700, Shirley Ma wrote:
> > On Tue, 2010-09-14 at 20:27 +0200, Michael S. Tsirkin wrote:
> > > As others said, the harder issues for TX are in determining that
> it's
> > > safe
> > > to unpin the memory, and how much memory is it safe to pin to
> beging
> > > with.  For RX we have some more complexity.
> > 
> > I think unpin the memory is in kfree_skb() whenever the last
> reference
> > is gone for TX. What we discussed about here is when/how vhost get
> > notified to update ring buffer descriptors. Do I misunderstand
> something
> > here? 
> 
> Right, that's a better way to put it. 

That's how this macvtap patch did. For how much pinned pages,it is
limited by sk_wmem_alloc size in this patch.

thanks
Shirley

