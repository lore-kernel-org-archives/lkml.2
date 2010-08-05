Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605Ab0HEPkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:40:43 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40151 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab0HEPkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:40:40 -0400
Date: Thu, 5 Aug 2010 11:39:43 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>, josef@redhat.com,
        Valdis.Kletnieks@vt.edu,
        Michael Monnerie <michael.monnerie@is.it-management.at>,
        Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: direct-io regression [Was: How to track down abysmal
 performance ata - raid1 - crypto - vg/lv - xfs]
Message-ID: <20100805153943.GO29846@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>, josef@redhat.com,
	Valdis.Kletnieks@vt.edu,
	Michael Monnerie <michael.monnerie@is.it-management.at>,
	Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
	xfs@oss.sgi.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com
References: <20100805123649.GA18672@dhcp231-156.rdu.redhat.com>
 <20100805113240.GA29846@think>
 <20100805153519.GA7242@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100805153519.GA7242@comet.dominikbrodowski.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4C5ADB55.007B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 05:35:19PM +0200, Dominik Brodowski wrote:
> Hey,
> 
> On Thu, Aug 05, 2010 at 07:32:40AM -0400, Chris Mason wrote:
> > But, I'm surprised your drive is doing 8K dio reads at 16MB/s, that
> > seems a little high.  
> 
> Well, that's what it does:
> 
> # $ dd if=/dev/mapper/vg0-home_crypt of=/dev/zero iflag=direct bs=8k count=131072 seek=131072
> # 131072+0 records in
> # 131072+0 records out
> # 1073741824 bytes (1.1 GB) copied, 62.0177 s, 17.3 MB/s

Can I ask you to do the test directly to the real honest to goodness
drive?   If it were an SSD I'd be less surprised, but then the extra
submits shouldn't hurt the ssd that much either.

Thanks for testing the patch, I'll send it in.

-chris
