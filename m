Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933424Ab0HEPyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:54:15 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:47742 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756454Ab0HEPyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:54:13 -0400
Date: Thu, 5 Aug 2010 17:53:57 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Chris Mason <chris.mason@oracle.com>
Cc: josef@redhat.com, Valdis.Kletnieks@vt.edu,
        Michael Monnerie <michael.monnerie@is.it-management.at>,
        Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: direct-io regression [Was: How to track down abysmal
 performance ata - raid1 - crypto - vg/lv - xfs]
Message-ID: <20100805155357.GA8245@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Chris Mason <chris.mason@oracle.com>, josef@redhat.com,
	Valdis.Kletnieks@vt.edu,
	Michael Monnerie <michael.monnerie@is.it-management.at>,
	Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
	xfs@oss.sgi.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com
References: <20100805123649.GA18672@dhcp231-156.rdu.redhat.com>
 <20100805113240.GA29846@think>
 <20100805153519.GA7242@comet.dominikbrodowski.net>
 <20100805153943.GO29846@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100805153943.GO29846@think>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 11:39:43AM -0400, Chris Mason wrote:
> On Thu, Aug 05, 2010 at 05:35:19PM +0200, Dominik Brodowski wrote:
> > On Thu, Aug 05, 2010 at 07:32:40AM -0400, Chris Mason wrote:
> > > But, I'm surprised your drive is doing 8K dio reads at 16MB/s, that
> > > seems a little high.  
> > 
> > Well, that's what it does:
> > 
> > # $ dd if=/dev/mapper/vg0-home_crypt of=/dev/zero iflag=direct bs=8k count=131072 seek=131072
> > # 131072+0 records in
> > # 131072+0 records out
> > # 1073741824 bytes (1.1 GB) copied, 62.0177 s, 17.3 MB/s
> 
> Can I ask you to do the test directly to the real honest to goodness
> drive?   If it were an SSD I'd be less surprised, but then the extra
> submits shouldn't hurt the ssd that much either.

>From lower the chain up to the device:

# LANG=EN dd if=/dev/mapper/vg0-root_crypt of=/dev/zero bs=8k count=131072 seek=393300 iflag=direct
131072+0 records in
131072+0 records out
1073741824 bytes (1.1 GB) copied, 63.1217 s, 17.0 MB/s

# LANG=EN dd if=/dev/mapper/vg0-root of=/dev/zero bs=8k count=131072 seek=393300 iflag=direct
131072+0 records in
131072+0 records out
1073741824 bytes (1.1 GB) copied, 43.2335 s, 24.8 MB/s

# LANG=EN dd if=/dev/sda5 of=/dev/zero bs=8k count=131072 seek=393300 iflag=direct
131072+0 records in
131072+0 records out
1073741824 bytes (1.1 GB) copied, 42.0868 s, 25.5 MB/s

Best,
	Dominik
