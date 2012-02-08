Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab2BHSaB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 13:30:01 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58073 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256Ab2BHS37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 13:29:59 -0500
Message-ID: <4F32BEDC.6030502@linux.vnet.ibm.com>
Date: Wed, 08 Feb 2012 10:28:44 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111109 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Nitin Gupta <ngupta@vflare.org>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] staging: zsmalloc: zsmalloc memory allocation library
References: <1326149520-31720-1-git-send-email-sjenning@linux.vnet.ibm.com> <1326149520-31720-2-git-send-email-sjenning@linux.vnet.ibm.com> <4F21A5AF.6010605@linux.vnet.ibm.com> <4F300D41.5050105@linux.vnet.ibm.com> <4F32A55E.8010401@linux.vnet.ibm.com> <4F32B6A4.8030702@vflare.org>
In-Reply-To: <4F32B6A4.8030702@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020818-5806-0000-0000-000012374A33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2012 09:53 AM, Nitin Gupta wrote:
> vmap() is not just slower but also does memory allocations at various
> places. Under memory pressure, this may cause failure in reading a
> stored object just because we failed to map it. Also, it allocates VA
> region each time its called which is a real big waste when we can simply
> pre-allocate 2 * PAGE_SIZE'ed VA regions (per-cpu).

Yeah, vmap() is a bit heavy-handed.  I'm just loathe to go mucking
around in the low-level pagetables too much.  Just seems like there'll
be a ton of pitfalls, like arch-specific TLB flushing, and it _seems_
like one of the existing kernel mechanisms should work.

I guess if you've exhaustively explored all of the existing kernel
mapping mechanisms and found none of them to work, and none of them to
be in any way suitably adaptable to your use, you should go ahead and
roll your own.  I guess you do at least use alloc_vm_area().  What made
map_vm_area() unsuitable for your needs?  If you're remapping, you
should at least be guaranteed not to have to allocate pte pages.

