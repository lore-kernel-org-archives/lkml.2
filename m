Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab2FGXmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 19:42:22 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:57366 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab2FGXmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 19:42:20 -0400
Message-ID: <4FD13C30.2030401@linux.vnet.ibm.com>
Date: Thu, 07 Jun 2012 16:41:36 -0700
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: John Stultz <john.stultz@linaro.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Taras Glek <tgek@mozilla.com>, Mike Hommey <mh@glandium.org>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] [RFC] tmpfs: Add FALLOC_FL_MARK_VOLATILE/UNMARK_VOLATILE
 handlers
References: <1338575387-26972-1-git-send-email-john.stultz@linaro.org> <1338575387-26972-4-git-send-email-john.stultz@linaro.org> <4FC9235F.5000402@gmail.com>	<4FC92E30.4000906@linaro.org> <4FC9360B.4020401@gmail.com>	<4FC937AD.8040201@linaro.org> <4FC9438B.1000403@gmail.com>	<4FC94F61.20305@linaro.org> <4FCFB4F6.6070308@gmail.com>	<4FCFEE36.3010902@linaro.org> <CAO6Zf6D++8hOz19BmUwQ8iwbQknQRNsF4npP4r-830j04vbj=g@mail.gmail.com>
In-Reply-To: <CAO6Zf6D++8hOz19BmUwQ8iwbQknQRNsF4npP4r-830j04vbj=g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060723-4242-0000-0000-000001E7A6E3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2012 03:55 AM, Dmitry Adamushko wrote:
> but maybe we should also purge them before we swap out some non-tmpfs
> pages or drop some file-backed pages?

Sure...  I guess we could kick that from either direct reclaim or from
kswapd.  But, then we're basically back to the places where
shrink_slab() is called.

I think that means that we think it's preferable to integrate this more
directly in the VM instead of sticking it off in the corner of tmpfs
only, or pretending it's a slab.

Dunno...  The slab shrinker one isn't looking _so_ bad at the moment.

