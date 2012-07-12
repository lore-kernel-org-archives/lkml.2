Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758478Ab2GLAXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 20:23:38 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:51624 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab2GLAXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 20:23:36 -0400
Message-ID: <4FFE18FF.6080307@linux.vnet.ibm.com>
Date: Wed, 11 Jul 2012 19:23:27 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Nitin Gupta <ngupta@vflare.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] zsmalloc: remove x86 dependency
References: <1341263752-10210-1-git-send-email-sjenning@linux.vnet.ibm.com> <1341263752-10210-2-git-send-email-sjenning@linux.vnet.ibm.com> <4FFDC54F.5030402@vflare.org>	<4FFDE2E2.7050901@linux.vnet.ibm.com> <CAPkvG_fejGCrS9u3Mg-ic1B_ar5qdyCSKSQtweijwaZ5mou=dw@mail.gmail.com>
In-Reply-To: <CAPkvG_fejGCrS9u3Mg-ic1B_ar5qdyCSKSQtweijwaZ5mou=dw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071200-7282-0000-0000-00000AD3FB1F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2012 05:42 PM, Nitin Gupta wrote:
> On Wed, Jul 11, 2012 at 1:32 PM, Seth Jennings
> <sjenning@linux.vnet.ibm.com> wrote:
>> On 07/11/2012 01:26 PM, Nitin Gupta wrote:
<snip>
>>> Now obj-1 lies completely within page-2, so can be kmap'ed as usual. On
>>> zs_unmap_object() we would just do the reverse and restore objects as in
>>> figure-1.
>>
>> Hey Nitin, thanks for the feedback.
>>
>> Correct me if I'm wrong, but it seems like you wouldn't be able to map
>> ob2 while ob1 was mapped with this design.  You'd need some sort of
>> zspage level protection against concurrent object mappings.  The
>> code for that protection might cancel any benefit you would gain by
>> doing it this way.
>>
> 
> Do you think blocking access of just one particular object (or
> blocking an entire zspage, for simplicity) for a short time would be
> an issue, apart from the complexity of implementing per zspage
> locking?

It would only need to prevent the mapping of the temporarily displaced
object, but I said zspage because I don't know how we would do
per-object locking.  I actually don't know how we would do zspage
locking either unless there is a lock in the struct page we can use.

Either way, I think it is a complexity I think we'd be better to avoid
for now.  I'm trying to get zsmalloc in shape to bring into mainline, so
I'm really focusing on portability first and low hanging performance
fruit second. This optimization would be more like top-of-the-tree
performance fruit :-/

However, if you want to try it out, don't let me stop you :)

Thanks,
Seth

