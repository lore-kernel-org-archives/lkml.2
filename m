Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553Ab2BHXHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 18:07:23 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:40460 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983Ab2BHXHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 18:07:21 -0500
Message-ID: <4F33001E.50600@linux.vnet.ibm.com>
Date: Wed, 08 Feb 2012 15:07:10 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111109 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, Greg KH <greg@kroah.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] staging: zsmalloc: zsmalloc memory allocation library
References: <1326149520-31720-1-git-send-email-sjenning@linux.vnet.ibm.com> <1326149520-31720-2-git-send-email-sjenning@linux.vnet.ibm.com> <4F21A5AF.6010605@linux.vnet.ibm.com> <4F300D41.5050105@linux.vnet.ibm.com> <4F32A55E.8010401@linux.vnet.ibm.com> <4F32B6A4.8030702@vflare.org> <4F32BEDC.6030502@linux.vnet.ibm.com> <4F32E1D2.4010809@vflare.org> <52f90b19-84b5-4e97-952a-373bdfeaa77d@default>
In-Reply-To: <52f90b19-84b5-4e97-952a-373bdfeaa77d@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020823-2398-0000-0000-0000040F7D80
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2012 01:39 PM, Dan Magenheimer wrote:
>> > map_vm_area() needs 'struct vm_struct' parameter but for mapping kernel
>> > allocated pages within kernel, what should we pass here?  I think we can
>> > instead use map_kernel_range_noflush() -- surprisingly
>> > unmap_kernel_range_noflush() is exported but this one is not.
> Creating a dependency on a core kernel change (even just an EXPORT_SYMBOL)
> is probably not a good idea.  Unless Dave vehemently objects, I'd suggest
> implementing it both ways, leaving the method that relies on the
> kernel change ifdef'd out, and add this to "the list of things that
> need to be done before zcache can be promoted out of staging".

Seems like a sane approach to me.

