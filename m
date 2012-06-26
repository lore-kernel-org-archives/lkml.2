Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab2FZNqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 09:46:48 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53231 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757036Ab2FZNqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 09:46:46 -0400
Message-ID: <4FE9BB7B.2050009@linux.vnet.ibm.com>
Date: Tue, 26 Jun 2012 08:39:07 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: konrad@darnok.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86: add local_tlb_flush_kernel_range()
References: <1340640878-27536-1-git-send-email-sjenning@linux.vnet.ibm.com> <1340640878-27536-4-git-send-email-sjenning@linux.vnet.ibm.com> <CAPbh3rvkKZOuGh_Pn9WpeV5_=vA=k9=x17oa2GoT8fEgRMr+WQ@mail.gmail.com>
In-Reply-To: <CAPbh3rvkKZOuGh_Pn9WpeV5_=vA=k9=x17oa2GoT8fEgRMr+WQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062613-5930-0000-0000-000009483DFB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2012 06:01 PM, Konrad Rzeszutek Wilk wrote:
> On Mon, Jun 25, 2012 at 12:14 PM, Seth Jennings
> <sjenning@linux.vnet.ibm.com> wrote:
>> This patch adds support for a local_tlb_flush_kernel_range()
>> function for the x86 arch.  This function allows for CPU-local
>> TLB flushing, potentially using invlpg for single entry flushing,
>> using an arch independent function name.
> 
> What x86 hardware did you use to figure the optimal number?

Actually I didn't.  I used Alex Shi's numbers.

https://lkml.org/lkml/2012/6/25/39

"Like some machine in my hands, balance points is 16 entries
on Romely-EP; while it is at 8 entries on Bloomfield NHM-EP;
and is 256 on IVB mobile CPU. but on model 15 core2 Xeon
using invlpg has nothing help.

For untested machine, do a conservative optimization, same
as NHM CPU."

--
Seth

