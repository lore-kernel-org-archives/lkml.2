Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab2G0TWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 15:22:36 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25864 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab2G0TWf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 15:22:35 -0400
MIME-Version: 1.0
Message-ID: <b95aec06-5a10-4f83-bdfd-e7f6adabd9df@default>
Date: Fri, 27 Jul 2012 12:21:50 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nitin Gupta <ngupta@vflare.org>,
        Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: RE: [PATCH 0/4] promote zcache from staging
References: <<1343413117-1989-1-git-send-email-sjenning@linux.vnet.ibm.com>>
In-Reply-To: <<1343413117-1989-1-git-send-email-sjenning@linux.vnet.ibm.com>>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6661.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Subject: [PATCH 0/4] promote zcache from staging
> 
> zcache is the remaining piece of code required to support in-kernel
> memory compression.  The other two features, cleancache and frontswap,
> have been promoted to mainline in 3.0 and 3.5.  This patchset
> promotes zcache from the staging tree to mainline.
> 
> Based on the level of activity and contributions we're seeing from a
> diverse set of people and interests, I think zcache has matured to the
> point where it makes sense to promote this out of staging.

Hi Seth --

Per offline communication, I'd like to see this delayed for three
reasons:

1) I've completely rewritten zcache and will post the rewrite soon.
   The redesigned code fixes many of the weaknesses in zcache that
   makes it (IMHO) unsuitable for an enterprise distro.  (Some of
   these previously discussed in linux-mm [1].)
2) zcache is truly mm (memory management) code and the fact that
   it is in drivers at all was purely for logistical reasons
   (e.g. the only in-tree "staging" is in the drivers directory).
   My rewrite promotes it to (a subdirectory of) mm where IMHO it
   belongs.
3) Ramster heavily duplicates code from zcache.  My rewrite resolves
   this.  My soon-to-be-post also places the re-factored ramster
   in mm, though with some minor work zcache could go in mm and
   ramster could stay in staging.

Let's have this discussion, but unless the community decides
otherwise, please consider this a NACK.

Thanks,
Dan

[1] http://marc.info/?t=133886706700002&r=1&w=2
