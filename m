Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab1GAIjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 04:39:37 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63433 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab1GAIjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 04:39:35 -0400
Date: Fri, 1 Jul 2011 11:38:50 +0300
From: Dan Carpenter <error27@gmail.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Marcus Klemm <marcus.klemm@googlemail.com>, kvm@vger.kernel.org,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        devel@linuxdriverproject.org
Subject: Re: [PATCH v2] staging: zcache: support multiple clients, prep for
 KVM and RAMster
Message-ID: <20110701083850.GE2544@shale.localdomain>
References: <1d15f28a-56df-4cf4-9dd9-1032f211c0d0@default20110630224019.GC2544@shale.localdomain>
 <3b67511f-bad9-4c41-915b-1f6e196f4d43@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b67511f-bad9-4c41-915b-1f6e196f4d43@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 04:28:14PM -0700, Dan Magenheimer wrote:
> Hi Dan --
> 
> Thanks for the careful review.  You're right... some
> of this was leftover from debugging an off-by-one error,
> though the code as is still works.
> 
> OTOH, there's a good chance that much of this sysfs
> code will disappear before zcache would get promoted
> out of staging, since it is to help those experimenting
> with zcache to get more insight into what the underlying
> compression/accept-reject algorithms are doing.
> 
> So I hope you (and GregKH) are OK that another version is
> not necessary at this time to fix these.

Off by one errors are kind of insidious.  People cut and paste them
and they spread.  If someone adds a new list of chunks then there
are now two examples that are correct and two which have an extra
element, so it's 50/50 that he'll copy the right one.

Btw, looking at it again, this seems like maybe a similar issue in
zbud_evict_zbpg():

   515          /* now try freeing unbuddied pages, starting with least space avail */
   516          for (i = 0; i < MAX_CHUNK; i++) {
   517  retry_unbud_list_i:


MAX_CHUNKS is NCHUNKS - 1.  Shouldn't that be i < NCHUNKS so that we
reach the last element in the list?

regards,
dan carpenter

