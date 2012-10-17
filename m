Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab2JQXvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 19:51:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39395 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab2JQXvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 19:51:35 -0400
Message-ID: <507F4475.80705@zytor.com>
Date: Wed, 17 Oct 2012 16:51:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        lenb@kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 2/4] xen/lowlevel: Implement pvop call for load_idt (sidt).
References: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com> <1350481786-4969-3-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1350481786-4969-3-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 06:49 AM, Konrad Rzeszutek Wilk wrote:
> In the past it used to point to 'sidt' (native_store_idt) operation
> which is a non-privileged operation. This resulted in the
> 'struct desc_ptr' value containing the address of Xen's IDT table,
> instead of the IDT table that Linux thinks its using. The end result
> is that doing:
>
>    store_idt(&desc);
>    load_idt(&desc);
>
> would blow up b/c xen_load_idt would try to parse the IDT contents
> (desc) and de-reference a virtual address that is outside Linux's
> __va (it is in Xen's virtual address).
>
> With this patch we are providing the last written IDT address.
>

OK... this seems like another excellent set of pvops calls that should 
be nukable to Kingdom Come.  There is no reason, ever, to read the IDT 
and GDT from the kernel... the kernel already knows what they should be!

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

