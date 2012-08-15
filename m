Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab2HOOdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:33:16 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59626 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab2HOOdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:33:14 -0400
Message-ID: <502BB125.7030607@linux.vnet.ibm.com>
Date: Wed, 15 Aug 2012 09:24:37 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Kurt Hackel <kurt.hackel@oracle.com>
Subject: Re: [PATCH 0/4] promote zcache from staging
References: <1343413117-1989-1-git-send-email-sjenning@linux.vnet.ibm.com> <5021795A.5000509@linux.vnet.ibm.com> <5024067F.3010602@linux.vnet.ibm.com> <2e9ccb4f-1339-4c26-88dd-ea294b022127@default> <50254F69.2000409@linux.vnet.ibm.com> <20120815093828.GB2865@phenom.dumpdata.com>
In-Reply-To: <20120815093828.GB2865@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081514-7182-0000-0000-0000024A863A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2012 04:38 AM, Konrad Rzeszutek Wilk wrote:
> On Fri, Aug 10, 2012 at 01:14:01PM -0500, Seth Jennings wrote:
>> On 08/09/2012 03:20 PM, Dan Magenheimer wrote
>>> I also wonder if you have anything else unusual in your
>>> test setup, such as a fast swap disk (mine is a partition
>>> on the same rotating disk as source and target of the kernel build,
>>> the default install for a RHEL6 system)?
>>
>> I'm using a normal SATA HDD with two partitions, one for
>> swap and the other an ext3 filesystem with the kernel source.
>>
>>> Or have you disabled cleancache?
>>
>> Yes, I _did_ disable cleancache.  I could see where having
>> cleancache enabled could explain the difference in results.
> 
> Why did you disable the cleancache? Having both (cleancache
> to compress fs data) and frontswap (to compress swap data) is the
> goal - while you turned one of its sources off.

I excluded cleancache to reduce interference/noise from the
benchmarking results. For this particular workload,
cleancache doesn't make a lot of sense since it will steal
pages that could otherwise be used for storing frontswap
pages to prevent swapin/swapout I/O.

In a test run with both enabled, I found that it didn't make
much difference under moderate to extreme memory pressure.
Both resulted in about 55% I/O reduction.  However, on light
memory pressure with 8 and 12 threads, it lowered the I/O
reduction ability of zcache to roughly 0 compared to ~20%
I/O reduction without cleancache.

In short, cleancache only had the power to harm in this
case, so I didn't enable it.

Seth

