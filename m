Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933809Ab2LHAuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 19:50:08 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:57192 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932316Ab2LHAuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 19:50:07 -0500
Message-ID: <50C28EB4.6030505@linaro.org>
Date: Fri, 07 Dec 2012 16:49:56 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Christoph Lameter <cl@linux.com>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC v2] Support volatile range for anon vma
References: <1351560594-18366-1-git-send-email-minchan@kernel.org> <50AD739A.30804@linaro.org> <50B6E1F9.5010301@linaro.org> <20121204000042.GB20395@bbox> <50BD4A70.9060506@linaro.org> <20121204072207.GA9782@blaptop> <50BE4B64.6000003@linaro.org> <20121205041855.GB9782@blaptop>
In-Reply-To: <20121205041855.GB9782@blaptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120800-7182-0000-0000-000003A1CF1D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2012 08:18 PM, Minchan Kim wrote:
> On Tue, Dec 04, 2012 at 11:13:40AM -0800, John Stultz wrote:
>> I don't think the problem is when vmas being marked VM_VOLATILE are
>> being merged, its that when we mark the vma as *non-volatile*, and
>> remove the VM_VOLATILE flag we merge the non-volatile vmas with
>> neighboring vmas. So preserving the purged flag during that merge is
>> important. Again, the example I used to trigger this was an
>> alternating pattern of volatile and non volatile vmas, then marking
>> the entire range non-volatile (though sometimes in two overlapping
>> passes).
> Understood. Thanks.
> Below patch solves your problems? It's simple than yours.

Yea, this is nicer then my fix.
Although I still need the purged handling in the vma merge code for me 
to see the behavior I expect in my tests.

I've integrated your patch and repushed my queue here:
http://git.linaro.org/gitweb?p=people/jstultz/android-dev.git;a=shortlog;h=refs/heads/dev/minchan-anonvol

git://git.linaro.org/people/jstultz/android-dev.git dev/minchan-anonvol

> Anyway, both yours and mine are not right fix.
> As I mentioned, locking scheme is broken.
> We need anon_vma_lock to handle purged and we should consider fork
> case, too.
Hrm. I'm sure you're right, as I've not yet fully grasped all the 
locking rules here.  Could you clarify how it is broken? And why is the 
anon_vma_lock needed to manage the purged state that is part of the vma 
itself?

thanks
-john

