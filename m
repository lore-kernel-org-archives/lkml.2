Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab2FYRVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 13:21:37 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36197 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757253Ab2FYRVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 13:21:35 -0400
Message-ID: <4FE89BA1.3030709@linux.vnet.ibm.com>
Date: Mon, 25 Jun 2012 12:10:57 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 2/3] zsmalloc: add generic path and remove x86 dependency
References: <1340640878-27536-1-git-send-email-sjenning@linux.vnet.ibm.com> <1340640878-27536-3-git-send-email-sjenning@linux.vnet.ibm.com> <20120625165915.GA20464@kroah.com>
In-Reply-To: <20120625165915.GA20464@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062517-1976-0000-0000-00000E8E913C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2012 11:59 AM, Greg Kroah-Hartman wrote:
> On Mon, Jun 25, 2012 at 11:14:37AM -0500, Seth Jennings wrote:
>> This patch adds generic pages mapping methods that
>> work on all archs in the absence of support for
>> local_tlb_flush_kernel_range() advertised by the
>> arch through __HAVE_LOCAL_TLB_FLUSH_KERNEL_RANGE
> 
> Is this #define something that other arches define now?  Or is this
> something new that you are adding here?

Something new I'm adding.

The precedent for this approach is the __HAVE_ARCH_* defines
that let the arch independent stuff know if a generic
function needs to be defined or if there is an arch specific
function.

You can "grep -R __HAVE_ARCH_* arch/x86/" to see the ones
that already exist.

I guess I should have called it
__HAVE_ARCH_LOCAL_TLB_FLUSH_KERNEL_RANGE though, not
__HAVE_LOCAL_TLB_FLUSH_KERNEL_RANGE.

--
Seth

