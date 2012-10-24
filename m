Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935012Ab2JXOfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 10:35:14 -0400
Received: from mx2.parallels.com ([64.131.90.16]:43206 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934968Ab2JXOfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 10:35:11 -0400
Message-ID: <5087FC97.6080100@parallels.com>
Date: Wed, 24 Oct 2012 18:35:03 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: <andi@firstfloor.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Joonsoo Kim <js1304@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH v2 1/2] kmem_cache: include allocators code directly into
 slab_common
References: <1351087158-8524-1-git-send-email-glommer@parallels.com> <1351087158-8524-2-git-send-email-glommer@parallels.com> <0000013a932d456c-8f0cbbce-e3f7-4f2a-b051-7b093a8cfc7e-000000@email.amazonses.com>
In-Reply-To: <0000013a932d456c-8f0cbbce-e3f7-4f2a-b051-7b093a8cfc7e-000000@email.amazonses.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 06:29 PM, Christoph Lameter wrote:
> On Wed, 24 Oct 2012, Glauber Costa wrote:
> 
>> Because of that, we either have to move all the entry points to the
>> mm/slab.h and rely heavily on the pre-processor, or include all .c files
>> in here.
> 
> Hmm... That is a bit of a radical solution. The global optimizations now
> possible with the new gcc compiler include the ability to fold functions
> across different linkable objects. Andi, is that usable for kernel builds?
> 

In general, it takes quite a lot of time to take all those optimizations
for granted. We still live a lot of time with multiple compiler versions
building distros, etc, for quite some time.

I would expect the end result for anyone not using such a compiler to be
a sudden performance drop when using a new kernel. Not really pleasant.

