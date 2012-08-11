Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab2HKA6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 20:58:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962Ab2HKA6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 20:58:32 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <andi.kleen@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Rik van Riel <riel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/3] HWPOISON: undo memory error handling for dirty pagecache
Date: Fri, 10 Aug 2012 20:58:11 -0400
Message-Id: <1344646691-17662-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <m2a9y2cpj7.fsf@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Fri, Aug 10, 2012 at 04:09:48PM -0700, Andi Kleen wrote:
> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:
> 
> > Current memory error handling on dirty pagecache has a bug that user
> > processes who use corrupted pages via read() or write() can't be aware
> > of the memory error and result in discarding dirty data silently.
> >
> > The following patch is to improve handling/reporting memory errors on
> > this case, but as a short term solution I suggest that we should undo
> > the present error handling code and just leave errors for such cases
> > (which expect the 2nd MCE to panic the system) to ensure data consistency.
> 
> Not sure that's the right approach. It's not worse than any other IO 
> errors isn't it? 

Right, in current situation both memory errors and other IO errors have
the possibility of data lost in the same manner.
I thought that in real mission critical system (for which I think
HWPOISON feature is targeted) closing dangerous path is better than
keeping waiting for someone to solve the problem in more generic manner.

But if we start with Fengguang's approach at first as you replied to
patch 3, this patch is not necessary.

Naoya
