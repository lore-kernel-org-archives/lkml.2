Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab1BARlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 12:41:06 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53737 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab1BARlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:41:04 -0500
Date: Tue, 1 Feb 2011 12:41:02 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Anthony Liguori <aliguori@linux.vnet.ibm.com>
Cc: Cong Wang <amwang@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jamie Lokier <jamie@shareable.org>, Thomas Weber <swirl@gmx.li>,
        Ben Hutchings <ben@decadent.org.uk>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Andy Fleming <afleming@freescale.com>,
        "David S. Miller" <davem@davemloft.net>,
        Neil Horman <nhorman@redhat.com>
Subject: Re: [RFC Patch] virtio: export model and type in /sys
Message-ID: <20110201174102.GB18526@infradead.org>
References: <1296442381-21652-1-git-send-email-amwang@redhat.com>
 <201101311435.24531.rusty@rustcorp.com.au>
 <4D464C6F.7010601@redhat.com>
 <4D46C0EB.9000505@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D46C0EB.9000505@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 08:02:19AM -0600, Anthony Liguori wrote:
> Uniquely identify the disk or identify the class of disk?
> 
> If it's the former, would serial be a better attribute to key off of?

It wouldn't just be the better way but the only working way.  

>From one of my test systems:

$ for i in /sys/block/*/device; do echo "vendor = $(cat $i/vendor) model = $(cat $i/model) type = $(cat $i/type)"; done
vendor = ServeRA  model = RAID 1           type = 0
vendor = HP       model = MSA2012fc        type = 0
vendor = HP       model = MSA2012fc        type = 0
vendor = HP       model = MSA2012fc        type = 0
vendor = HP       model = MSA2012fc        type = 0
vendor = NETAPP   model = LUN              type = 0
vendor = NETAPP   model = LUN              type = 0
vendor = MATSHITA model = UJDA780 DVD/CDRW type = 5

