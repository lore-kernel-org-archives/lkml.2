Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab1I2RsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 13:48:11 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42110 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755197Ab1I2RsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 13:48:06 -0400
Message-ID: <4E84AF30.30402@linux.vnet.ibm.com>
Date: Thu, 29 Sep 2011 12:47:28 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: gregkh@suse.de, dan.magenheimer@oracle.com, ngupta@vflare.org,
        cascardo@holoscopio.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, rdunlap@xenotime.net, linux-mm@kvack.org,
        rcj@linux.vnet.ibm.com, dave@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com
Subject: Re: [PATCH v2 0/3] staging: zcache: xcfmalloc support
References: <1315404547-20075-1-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1315404547-20075-1-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11092917-6078-0000-0000-0000014B8456
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2011 09:09 AM, Seth Jennings wrote:
> 
> I did some quick tests with "time" using the same program and the
> timings are very close (3 run average, little deviation):
> 
> xvmalloc:
> zero filled	0m0.852s
> text (75%)	0m14.415s
> 
> xcfmalloc:
> zero filled	0m0.870s
> text (75%)	0m15.089s
> 
> I suspect that the small decrease in throughput is due to the
> extra memcpy in xcfmalloc.  However, these timing, more than 
> anything, demonstrate that the throughput is GREATLY effected
> by the compressibility of the data.

This is not correct.  I found out today that the reason text
compressed so much more slowly is because my test program
was inefficiently filling text filled pages.

With my corrected test program:
xvmalloc:
zero filled	0m0.751s
text (75%)	0m2.273s

It is still slower on less compressible data but not to the
degree previously stated.

I don't have the xcfmalloc numbers yet, but I expect they are
almost the same.

--
Seth

