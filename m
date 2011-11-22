Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673Ab1KVUkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 15:40:06 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:58301 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165Ab1KVUkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 15:40:04 -0500
Message-ID: <4ECC0880.8050203@linux.vnet.ibm.com>
Date: Tue, 22 Nov 2011 12:39:28 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Robert Love <rlove@google.com>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Eric Anholt <eric@anholt.net>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Johannes Weiner <jweiner@redhat.com>, Jon Masters <jcm@redhat.com>
Subject: Re: [PATCH] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and _NONVOLATILE
 flags
References: <1321932788-18043-1-git-send-email-john.stultz@linaro.org> <4ECB6D60.1010702@redhat.com> <4ECB7D48.6080307@redhat.com>
In-Reply-To: <4ECB7D48.6080307@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11112220-4242-0000-0000-0000002D44B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2011 02:45 AM, Rik van Riel wrote:
> 4) Virtualization.  Marking an object (and its pages)
>     _VOLATILE inside a guest will not be visible on the
>     host side, which means a virtual system may continue
>     to suffer the performance penalty anyway.

Yeah, I guess we still have to communicate it _somehow_.

I guess we could theoretically pass the calls up to the
hypervisor and it could even make its own VOLATILE calls
to the host kernel.  We'd also have to pass back down the
"was this evicted" information during a re-pin. That seems
messy to me.

Is it really any different of a problem than page cache?
The guest has data sitting in RAM that it probably doesn't
need.  If we passed up just the amount of unpinned data back
up to the hypervisor, it would have a decent idea how much
it could balloon the guest, for instance.  That would fit
in well with some of the existing schemes that folks have
and be *much* nicer than what they've got at the moment.

