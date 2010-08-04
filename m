Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584Ab0HDLSK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 07:18:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52000 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201Ab0HDLSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 07:18:08 -0400
Date: Wed, 4 Aug 2010 07:18:03 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
        Michael Monnerie <michael.monnerie@is.it-management.at>,
        Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: How to track down abysmal performance ata - raid1 - crypto -
 vg/lv - xfs
Message-ID: <20100804111803.GA32643@infradead.org>
References: <20100804073546.GA7494@comet.dominikbrodowski.net>
 <20100804085039.GA11671@infradead.org>
 <20100804091317.GA27779@isilmar-3.linta.de>
 <20100804092122.GA2998@infradead.org>
 <20100804073546.GA7494@comet.dominikbrodowski.net>
 <201008041116.09822@zmi.at>
 <20100804102526.GB13766@isilmar-3.linta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804102526.GB13766@isilmar-3.linta.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 12:25:26PM +0200, Dominik Brodowski wrote:
> Hey,
> 
> many thanks for your feedback. It seems the crypto step is the culprit:
> 
> Reading 1.1 GB with dd, iflag=direct, bs=8k:
> 
> /dev/sd*                35.3 MB/s       ( 90 %)
> /dev/md*                39.1 MB/s       (100 %)
> /dev/mapper/md*_crypt    3.9 MB/s       ( 10 %)
> /dev/mapper/vg1-*        3.9 MB/s       ( 10 %)
> 
> The "good" news: it also happens on my notebook, even though it has a
> different setup (no raid, disk -> lv/vg -> crypt). On my notebook, I'm
> more than happy to test out different kernel versions, patches etc.
> 
> /dev/sd*                17.7 MB/s       (100 %)
> /dev/mapper/vg1-*       16.2 MB/s       ( 92 %)
> /dev/mapper/*_crypt      3.1 MB/s       ( 18 %)

The good news is that you have it tracked down, the bad news is that
I know very little about dm-crypt.  Maybe the issue is the single
threaded decryption in dm-crypt?  Can you check how much CPU time
the dm crypt kernel thread uses?

