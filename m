Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab1JZGRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 02:17:00 -0400
Received: from smtp-out.google.com ([216.239.44.51]:11599 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab1JZGQ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 02:16:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Hg5XRgqFbRUOwkVGnIcnvrAEhSxsMgLJfrDOvw4MOmSfT3iy9Jdc9CwCEYo3icUIN
	2+JoLD9zLs/ZbKvXfJJmA==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1110252311030.20273@chino.kir.corp.google.com>
References: <1319524789-22818-1-git-send-email-ccross@android.com>
	<20111025090956.GA10797@suse.de>
	<alpine.DEB.2.00.1110251513520.26017@chino.kir.corp.google.com>
	<CAMbhsRQ3y2SBwEfjiYgfxz2-h0fgn20mLBYgFuBwGqon0f-a8g@mail.gmail.com>
	<alpine.DEB.2.00.1110252244270.18661@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1110252311030.20273@chino.kir.corp.google.com>
Date: Tue, 25 Oct 2011 23:16:55 -0700
X-Google-Sender-Auth: DjXbP0sHUtHwlziRBpC9EzBIrrc
Message-ID: <CAMbhsRS+-jn7d1bTd4F0_RB9860iWjOHLfOkDsqLfWEUbR3TYA@mail.gmail.com>
Subject: Re: [PATCH] mm: avoid livelock on !__GFP_FS allocations
From: Colin Cross <ccross@android.com>
To: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 11:12 PM, David Rientjes <rientjes@google.com> wrote:
> On Tue, 25 Oct 2011, David Rientjes wrote:
>
>> Ok, so __GFP_NORETRY it is.  Just make sure that when
>> pm_restrict_gfp_mask() masks off __GFP_IO and __GFP_FS that it also sets
>> __GFP_NORETRY even though the name of the function no longer seems
>> appropriate anymore.
>>
>
> Or, rather, when pm_restrict_gfp_mask() clears __GFP_IO and __GFP_FS that
> it also has the same behavior as __GFP_NORETRY in should_alloc_retry() by
> setting a variable in file scope.
>

Why do you prefer that over adding a gfp_required_mask?
