Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385Ab2LHARw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 19:17:52 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:35958 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104Ab2LHARv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 19:17:51 -0500
Message-ID: <50C28720.3070205@linux.vnet.ibm.com>
Date: Fri, 07 Dec 2012 16:17:36 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: add node physical memory range to sysfs
References: <1354919696.2523.6.camel@buesod1.americas.hpqcorp.net> <20121207155125.d3117244.akpm@linux-foundation.org>
In-Reply-To: <20121207155125.d3117244.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120800-7182-0000-0000-000003A1883C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2012 03:51 PM, Andrew Morton wrote:
>> > +static ssize_t node_read_memrange(struct device *dev,
>> > +				  struct device_attribute *attr, char *buf)
>> > +{
>> > +	int nid = dev->id;
>> > +	unsigned long start_pfn = NODE_DATA(nid)->node_start_pfn;
>> > +	unsigned long end_pfn = start_pfn + NODE_DATA(nid)->node_spanned_pages;
> hm.  Is this correct for all for
> FLATMEM/SPARSEMEM/SPARSEMEM_VMEMMAP/DISCONTIGME/etc?

It's not _wrong_ per se, but it's not super precise, either.

The problem is, it's quite valid to have these node_start/spanned ranges
overlap between two or more nodes on some hardware.  So, if the desired
purpose is to map nodes to DIMMs, then this can only accomplish this on
_some_ hardware, not all.  It would be completely useless for that
purpose for some configurations.

Seems like the better way to do this would be to expose the DIMMs
themselves in some way, and then map _those_ back to a node.

