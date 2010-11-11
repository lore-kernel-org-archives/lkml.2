Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab0KKMZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 07:25:09 -0500
Received: from smtp-out.google.com ([216.239.44.51]:6261 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299Ab0KKMZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:25:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=g3CTlrkNnvQSJHOlKIkICBJhpysOsVPzDbrABqVW873rBt6v6gxDY11lj/CHwBNqVG
         JVdA9iHSYR0r9CNkQWUQ==
MIME-Version: 1.0
In-Reply-To: <20101111121545.GF19679@csn.ul.ie>
References: <20101111121545.GF19679@csn.ul.ie>
Date: Thu, 11 Nov 2010 04:25:00 -0800
Message-ID: <AANLkTinxYntXjK7V8W3+3j7m0xQUVpB1eeysSE0ifO1k@mail.gmail.com>
Subject: Re: [BUG] Commit d065bd81 severely regresses huge page allocation
 success rates
From: Michel Lespinasse <walken@google.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>, Wu Fengguang <fengguang.wu@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ying Han <yinghan@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 4:15 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> When testing 2.6.37-rc1, I noticed that huge page allocation success
> rates were severely impaired. Bisection showed that commit [d065bd81: mm:
> retry page fault when blocking on disk transfer] was the biggest factor.
> Reverting the patch confirmed this. Here are the results of a high-order
> allocation stress test. The vanilla kernel is 2.6.37-rc1 and the revert
> kernel has this commit removed with minor conflicts cleaned up.
[...]
> I have not digested what the patch is doing but am reporting it in case
> people familiar with the patch spot the problem quickly.

There was a bug in that commit, which was fixed in
d88c0922fa0e2c021a028b310a641126c6d4b7dc

I think this may explain the issue; compaction won't work well if
extra references are kept :/

Can you check that this indeed solves your test case ?

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
