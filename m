Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab1F3X2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 19:28:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53751 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab1F3X2l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 19:28:41 -0400
MIME-Version: 1.0
Message-ID: <3b67511f-bad9-4c41-915b-1f6e196f4d43@default>
Date: Thu, 30 Jun 2011 16:28:14 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Marcus Klemm <marcus.klemm@googlemail.com>, kvm@vger.kernel.org,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        devel@linuxdriverproject.org
Subject: RE: [PATCH v2] staging: zcache: support multiple clients, prep for
 KVM and RAMster
References: <1d15f28a-56df-4cf4-9dd9-1032f211c0d0@default
 20110630224019.GC2544@shale.localdomain>
In-Reply-To: <20110630224019.GC2544@shale.localdomain>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090209.4E0D06A3.00B1:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	for (i = 0; i <= NCHUNKS - 1; i++) {
> 
> It's more common to write the condition as:  i < NCHUNKS.
> 
> > +		n = zv_curr_dist_counts[i];
> 
> zv_curr_dist_counts has NCHUNKS + 1 elements so we never print
> display the final element.  I don't know this coe, so I could be
> wrong but I think that we could make zv_curr_dist_counts only hold
> NCHUNKS elements.
> 
> > +	for (i = 0; i <= NCHUNKS - 1; i++) {
> 
> Same situation.

Hi Dan --

Thanks for the careful review.  You're right... some
of this was leftover from debugging an off-by-one error,
though the code as is still works.

OTOH, there's a good chance that much of this sysfs
code will disappear before zcache would get promoted
out of staging, since it is to help those experimenting
with zcache to get more insight into what the underlying
compression/accept-reject algorithms are doing.

So I hope you (and GregKH) are OK that another version is
not necessary at this time to fix these.

Thanks,
Dan
