Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935233Ab1IOW1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 18:27:42 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:42891 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935182Ab1IOW1l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 18:27:41 -0400
MIME-Version: 1.0
Message-ID: <504b4342-e6b0-4544-b81c-ca41240ac5bf@default>
Date: Thu, 15 Sep 2011 15:27:07 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Nitin Gupta <ngupta@vflare.org>, Greg KH <greg@kroah.com>, gregkh@suse.de,
        devel@driverdev.osuosl.org, cascardo@holoscopio.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        brking@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com
Subject: RE: [PATCH v2 0/3] staging: zcache: xcfmalloc support
References: <1315404547-20075-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <20110909203447.GB19127@kroah.com> <4E6ACE5B.9040401@vflare.org>
 <4E6E18C6.8080900@linux.vnet.ibm.com> <4E6EB802.4070109@vflare.org>
 <4E6F7DA7.9000706@linux.vnet.ibm.com> <4E6FC8A1.8070902@vflare.org>
 <4E72284B.2040907@linux.vnet.ibm.com>
 <075c4e4c-a22d-47d1-ae98-31839df6e722@default>
 <4E725109.3010609@linux.vnet.ibm.com 1316125062.16137.80.camel@nimitz>
In-Reply-To: <1316125062.16137.80.camel@nimitz>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090204.4E727BD2.00A2,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Dave Hansen [mailto:dave@linux.vnet.ibm.com]
> Subject: Re: [PATCH v2 0/3] staging: zcache: xcfmalloc support
> 
> On Thu, 2011-09-15 at 14:24 -0500, Seth Jennings wrote:
> > How would you suggest that I measure xcfmalloc performance on a "very
> > large set of workloads".  I guess another form of that question is: How
> > did xvmalloc do this?
> 
> Well, it didn't have a competitor, so this probably wasn't done. :)
> 
> I'd like to see a microbenchmarky sort of thing.  Do a million (or 100
> million, whatever) allocations, and time it for both allocators doing
> the same thing.  You just need to do the *same* allocations for both.

One suggestion:  We already know xvmalloc sucks IF the workload has
poor compression for most pages.  We are looking to understand if xcfmalloc
is [very**N] bad when xvmalloc is good.  So please measure BIG-NUMBER
allocations where compression is known to be OK on average (which is,
I think, a large fraction of workloads), rather than workloads where
xvmalloc already sucks.
