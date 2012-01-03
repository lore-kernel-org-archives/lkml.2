Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab2ACVj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 16:39:58 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:37194 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab2ACVj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 16:39:56 -0500
Date: Tue, 3 Jan 2012 16:38:12 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Brian King <brking@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH] staging: zcache: fix serialization bug in zv stats
Message-ID: <20120103213812.GL17472@phenom.dumpdata.com>
References: <1325263335-16254-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <d9558871-53ec-4d49-8df4-c09bee100a49@default>
 <4EFDF671.7020101@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EFDF671.7020101@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F0375A3.0080,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 30, 2011 at 11:35:45AM -0600, Seth Jennings wrote:
> On 12/30/2011 11:02 AM, Dan Magenheimer wrote:
> >> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> >> Sent: Friday, December 30, 2011 9:42 AM
> >> To: Greg Kroah-Hartman
> >> Cc: Seth Jennings; Dan Magenheimer; Brian King; devel@driverdev.osuosl.org; linux-
> >> kernel@vger.kernel.org
> >> Subject: [PATCH] staging: zcache: fix serialization bug in zv stats
> >>
> >> In a multithreaded workload, the zv_curr_dist_counts
> >> and zv_cumul_dist_counts statistics are being corrupted
> >> because the increments and decrements in zv_create
> >> and zv_free are not atomic.
> >>
> >> This patch converts these statistics and their corresponding
> >> increments/decrements/reads to atomic operations.
> >>
> >> Based on v3.2-rc7
> >>
> >> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> > 
> > I'm inclined to nack this change, at least unless inside an #ifdef DEBUG,
> 
> I guess I didn't respond to this suggestion.  We could put #ifdef DEBUG
> around the updates in zv_create and zv_free and around the two sysfs
> *_show functions.  Kinda messy though.  I guess it might not matter
> if we'll be re-evaluating this whole thing soon.

Perhaps also add in the TODO file that we want to move the stats collection
out of the code and only be enabled if CONFIG_DEBUGFS is set? (Which granted means
we need to implement the stats output in debugfs instead of sysfs).
