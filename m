Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab0I2Obm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 10:31:42 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:40602 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab0I2Obk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 10:31:40 -0400
Subject: Re: [RFC PATCH 2/2] macvtap: TX zero copy between guest and host
 kernel
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Avi Kivity <avi@redhat.com>,
        "Xin, Xiaohui" <xiaohui.xin@intel.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100929081645.GA21195@redhat.com>
References: <1284483745.13351.71.camel@localhost.localdomain>
	 <20100914182707.GB15549@redhat.com>
	 <1284490143.13351.82.camel@localhost.localdomain>
	 <20100914190156.GA16037@redhat.com>
	 <1284492983.13351.95.camel@localhost.localdomain>
	 <20100915051241.GA25340@redhat.com>
	 <1284531675.24603.259.camel@localhost.localdomain>
	 <20100915101000.GB28016@redhat.com>
	 <1284562354.2573.12.camel@localhost.localdomain>
	 <1285730669.31343.7.camel@localhost.localdomain>
	 <20100929081645.GA21195@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Sep 2010 07:31:29 -0700
Message-ID: <1285770689.31343.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-29 at 10:16 +0200, Michael S. Tsirkin wrote:
> If you look at dev_hard_start_xmit you will see a call
> to skb_orphan_try which often calls the skb destructor.
> So I suspect this is almost equivalent to your original patch,
> and has the same correctness issue.

I forgot to mention, in skb_orphan_try, I still kept the skb->sk
reference to sk, I assign skb->sk to NULL when the DMA done.

Thanks
Shirley

