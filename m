Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab1EBTxZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 15:53:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771Ab1EBTxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 15:53:24 -0400
Date: Mon, 2 May 2011 22:53:03 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: David Miller <davem@davemloft.net>, Eric Dumazet <eric.dumazet@gmail.com>,
        Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 2/8] Add a new zerocopy device flag
Message-ID: <20110502195302.GA25619@redhat.com>
References: <1303328216.19336.18.camel@localhost.localdomain>
 <1303328648.19336.24.camel@localhost.localdomain>
 <20110502104257.GA21625@redhat.com>
 <1304362028.20660.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304362028.20660.15.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 11:47:08AM -0700, Shirley Ma wrote:
> On Mon, 2011-05-02 at 13:42 +0300, Michael S. Tsirkin wrote:
> > This comment should specify what exactly is the promise the
> > device makes by setting this flag. Specifically, the
> > condition is that no skb fragments are used
> > after the uinfo callback has been called.
> > 
> > The way it's implemented, it probably means the device
> > should not use any of skb_clone, expand head etc.
> 
> Agree. Or maybe force a copy when device uses skb_clone, expand
> head ...?
> 
> Thanks
> Shirley

Copy from userspace upfront without locking is probably cheaper?

-- 
MST
