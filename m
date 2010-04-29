Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab0D3Qze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:55:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757992Ab0D3QzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:55:11 -0400
Message-ID: <4BD9A84C.3050709@redhat.com>
Date: Thu, 29 Apr 2010 11:39:56 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH -v3] take all anon_vma locks in anon_vma_lock
References: <1272403852-10479-1-git-send-email-mel@csn.ul.ie>	 <20100428153525.GR510@random.random>	 <20100428155558.GI15815@csn.ul.ie>	 <20100428162305.GX510@random.random>	 <20100428134719.32e8011b@annuminas.surriel.com>	 <20100428142510.09984e15@annuminas.surriel.com>	 <20100428161711.5a815fa8@annuminas.surriel.com>	 <20100428165734.6541bab3@annuminas.surriel.com>	 <y2s28c262361004281728we31e3b9fsd2427aacdc76a9e7@mail.gmail.com>	 <4BD8EA85.2000209@redhat.com> <z2g28c262361004281955h29bc20edndb8da9c7cb5ff1db@mail.gmail.com>
In-Reply-To: <z2g28c262361004281955h29bc20edndb8da9c7cb5ff1db@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2010 10:55 PM, Minchan Kim wrote:

> When you tried anon_vma_chain patches as I pointed out, what I have a
> concern is parent's vma not child's one.
> The vma of parent still has N anon_vma.

No, it is the other way around.

The anon_vma of the parent is also present in all of the
children, so the parent anon_vma is attached to N vmas.

However, the parent vma only has 1 anon_vma attached to
it, and each of the children will have 2 anon_vmas.

That is what should keep any locking overhead with this
patch minimal.

Yes, a deep fork bomb can slow itself down.  Too bad,
don't do that :)

-- 
All rights reversed
