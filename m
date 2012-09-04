Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab2IDQgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 12:36:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932302Ab2IDQgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 12:36:11 -0400
Message-ID: <50462DF5.1000806@redhat.com>
Date: Tue, 04 Sep 2012 19:36:05 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Sasha Levin <levinsasha928@gmail.com>, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 2/2] virtio-ring: Allocate indirect buffers from cache
 when possible
References: <1346325718-11151-1-git-send-email-levinsasha928@gmail.com> <1346325718-11151-2-git-send-email-levinsasha928@gmail.com> <20120830133820.GC21132@redhat.com> <50408587.5030603@gmail.com> <20120831095628.GB24244@redhat.com> <50462D8B.7040004@redhat.com>
In-Reply-To: <50462D8B.7040004@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2012 07:34 PM, Avi Kivity wrote:
> On 08/31/2012 12:56 PM, Michael S. Tsirkin wrote:
>> On Fri, Aug 31, 2012 at 11:36:07AM +0200, Sasha Levin wrote:
>>> On 08/30/2012 03:38 PM, Michael S. Tsirkin wrote:
>>> >> +static unsigned int indirect_alloc_thresh = 16;
>>> > Why 16?  Please make is MAX_SG + 1 this makes some sense.
>>> 
>>> Wouldn't MAX_SG mean we always allocate from the cache? Isn't the memory waste
>>> too big in this case?
>> 
>> Sorry. I really meant MAX_SKB_FRAGS + 1. MAX_SKB_FRAGS is 17 so gets us
>> threshold of 18. It is less than the size of an skb+shinfo itself so -
>> does it look too big to you? Also why do you think 16 is not too big but
>> 18 is?  If there's a reason then I am fine with 16 too but then please
>> put it in code comment near where the value is set.
>> 
>> Yes this means virtio net always allocates from cache
>> but this is a good thing, isn't it? Gets us more consistent
>> performance.
> 
> kmalloc() also goes to a cache.  Is there a measurable difference?
> 
> Ugh, there's an ugly loop in __find_general_cachep(), which really wants
> to be replaced with fls().
> 

Actually, not, as the loop will be very short for small sizes.

-- 
error compiling committee.c: too many arguments to function
