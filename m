Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab2DBQmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 12:42:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333Ab2DBQmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 12:42:07 -0400
Message-ID: <4F79D925.7070900@redhat.com>
Date: Mon, 02 Apr 2012 12:51:49 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: "Luca Porzio (lporzio)" <lporzio@micron.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Alex Lemberg <alex.lemberg@sandisk.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Saugata Das <saugata.das@linaro.org>,
        Venkatraman S <venkat@linaro.org>, Yejin Moon <yejin.moon@samsung.com>,
        Hyojin Jeong <syr.jeong@samsung.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>
Subject: Re: swap on eMMC and other flash
References: <201203301744.16762.arnd@arndb.de> <201203301850.22784.arnd@arndb.de> <alpine.LSU.2.00.1203311230490.10965@eggly.anvils> <26E7A31274623843B0E8CF86148BFE326FB55F8B@NTXAVZMBX04.azit.micron.com> <alpine.LSU.2.00.1204020754180.1847@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1204020754180.1847@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2012 10:58 AM, Hugh Dickins wrote:
> On Mon, 2 Apr 2012, Luca Porzio (lporzio) wrote:
>>
>> Great topics. As per one of Rik original points:
>>
>>> 4) skip writeout of zero-filled pages - this can be a big help
>>>      for KVM virtual machines running Windows, since Windows zeroes
>>>      out free pages;   simply discarding a zero-filled page is not
>>>      at all simple in the current VM, where we would have to iterate
>>>      over all the ptes to free the swap entry before being able to
>>>      free the swap cache page (I am not sure how that locking would
>>>      even work)
>>>
>>>      with the extra layer of indirection, the locking for this scheme
>>>      can be trivial - either the faulting process gets the old page,
>>>      or it gets a new one, either way it'll be zero filled
>>>
>>
>> Since it's KVMs realm here, can't KSM simply solve the zero-filled pages problem avoiding unnecessary burden for the Swap subsystem?
>
> I would expect that KSM already does largely handle this, yes.
> But it's also quite possible that I'm missing Rik's point.

Indeed, KSM handles it already.

However, it may be worthwhile for non-KVM users of transparent
huge pages to discard zero-filled parts of pages (allocated by
the kernel to the process, but not used memory).

Not just because it takes up swap space (writing to swap is
easy, space is cheap), but because not swapping that memory
back in later (because it is not used) will prevent us from
re-building the transparent huge page...

