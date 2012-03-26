Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab2CZCAT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 22:00:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:23636 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754315Ab2CZCAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 22:00:16 -0400
X-IronPort-AV: E=Sophos;i="4.75,317,1330876800"; 
   d="scan'208";a="4616033"
Message-ID: <4F6FCDAD.4060701@cn.fujitsu.com>
Date: Mon, 26 Mar 2012 10:00:13 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 6/6] workqueue: use kmalloc_align() instead of hacking
References: <1332238884-6237-1-git-send-email-laijs@cn.fujitsu.com> <1332238884-6237-7-git-send-email-laijs@cn.fujitsu.com> <20120320154619.GA5684@google.com> <4F6944D9.5090002@cn.fujitsu.com> <alpine.DEB.2.00.1203210842200.20382@router.home>
In-Reply-To: <alpine.DEB.2.00.1203210842200.20382@router.home>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-26 09:52:45,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-26 09:52:50,
	Serialize complete at 2012-03-26 09:52:50
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2012 09:45 PM, Christoph Lameter wrote:
> On Wed, 21 Mar 2012, Lai Jiangshan wrote:
> 
>> Yes, I don't want to build a complex kmalloc_align(). But after I found
>> that SLAB/SLUB's kmalloc-objects are natural/automatic aligned to
>> a proper big power of two. I will do nothing if I introduce kmalloc_align()
>> except just care the debugging.
> 
> They are not guaranteed to be aligned to the big power of two! There are
> kmalloc caches that are not power of two. Debugging and other
> necessary meta data may change alignment in both SLAB and SLUB. SLAB needs
> a metadata structure in each page even without debugging that may cause
> alignment issues.

"Debugging and other necessary meta data" are handled in special way in my patches.
(You have already checked the patches.)

Normally, as I said, SLAB/SLUB's kmalloc-objects are natural/automatic aligned,
and my patch does not touch the general cases. Sorry for my bad reply.


> 
>> And kmalloc_align() can be used in the following case:
>> o	a type object need to be aligned with cache-line for it contains a frequent
>> 	update-part and a frequent read-part.
>> o	The total number of these objects in a given type is not much, creating
>> 	a new slab cache for a given type will be overkill.
>>
>> This is a RFC patch and it seems mm gurus don't like it. I'm sorry I
>> bother all of you.
> 
> Ideas are always welcome. Please do not get offended by our problems with
> your patch.
> 
> 
> 

