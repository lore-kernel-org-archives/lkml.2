Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933739Ab0HEQfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 12:35:33 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:49184 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933152Ab0HEQf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 12:35:29 -0400
Date: Thu, 5 Aug 2010 18:35:19 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Chris Mason <chris.mason@oracle.com>, josef@redhat.com,
        Valdis.Kletnieks@vt.edu,
        Michael Monnerie <michael.monnerie@is.it-management.at>,
        Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: direct-io regression [Was: How to track down abysmal
 performance ata - raid1 - crypto - vg/lv - xfs]
Message-ID: <20100805163519.GA6604@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Chris Mason <chris.mason@oracle.com>, josef@redhat.com,
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small correction:

On Thu, Aug 05, 2010 at 05:35:19PM +0200, Dominik Brodowski wrote:
> With this fix, I get proper speeds when doing dio reads from
> /dev/mapper/vg0-*_crypt; see the 17.3 MB/s above. Most strangely,
> also accesing /dev/mapper/vg0-* (un-encrypted) and the raw
> device at /dev/sda* speeds up (to up to 28 MB/s). Was only seeing around
> 16 to 18 MB/s without this patch for unencrypted access.

The speed-up of the unencrypted access (18 -> 28 MB/s) is caused by using a
different configuration for kernel 2.6.35; and seems to be unrelated to your
patch. Will try to track down which config option is the culprit.


kernel, dmcrypt?	| good config | bad config
-------------------------------------------------
patched 2.6.35, dmcrypt	  ~ 18 MB/s	~ 13 MB/s
patched 2.6.35		  ~ 28 MB/s	~ 18 MB/s
-------------------------------------------------
plain 2.6.35, dmcrypt	  ~  3 MB/s	~  3 MB/s
plain 2.6.35		  <not tested>	~ 16 MB/s	


Best,
	Dominik
