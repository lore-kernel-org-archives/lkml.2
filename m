Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab2KFAOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 19:14:52 -0500
Received: from outmail015.snc4.facebook.com ([66.220.144.149]:35341 "EHLO
	intmgw001.snc6.facebook.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753490Ab2KFAOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 19:14:50 -0500
X-Greylist: delayed 1201 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Nov 2012 19:14:49 EST
Date: Mon, 5 Nov 2012 15:54:43 -0800
From: Arun Sharma <asharma@fb.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, John Stultz <john.stultz@linaro.org>,
        Christoph Lameter <cl@linux.com>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, sanjay@google.com,
        David Rientjes <rientjes@google.com>
Subject: Re: [RFC v2] Support volatile range for anon vma
Message-ID: <20121105235443.GA27718@dev3310.snc6.facebook.com>
References: <1351560594-18366-1-git-send-email-minchan@kernel.org>
 <20121031143524.0509665d.akpm@linux-foundation.org>
 <CAPM31RKm89s6PaAnfySUD-f+eGdoZP6=9DHy58tx_4Zi8Z9WPQ@mail.gmail.com>
 <CAHGf_=om34CQoPqgmVE5v8oVxntaJQ-bvFeEPMnfe_R+uvxqrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHGf_=om34CQoPqgmVE5v8oVxntaJQ-bvFeEPMnfe_R+uvxqrQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 06:56:05PM -0400, KOSAKI Motohiro wrote:
> glibc malloc discard freed memory by using MADV_DONTNEED
> as tcmalloc. and it is often a source of large performance decrease.
> because of MADV_DONTNEED discard memory immediately and
> right after malloc() call fall into page fault and pagesize memset() path.
> then, using DONTNEED increased zero fill and cache miss rate.

The memcg based solution that I posted a few months ago is working well
for us. We see significantly less cpu in zero'ing pages.

Not everyone was comfortable with the security implications of recycling
pages between processes in a memcg, although it was disabled by default
and had to be explicitly opted-in.

Also, memory allocators have a second motivation in using madvise: to
create virtually contiguous regions of memory from a fragmented address 
space, without increasing the RSS.

 -Arun
