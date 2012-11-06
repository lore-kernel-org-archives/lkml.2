Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab2KFFgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 00:36:45 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50028 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab2KFFgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 00:36:44 -0500
Date: Tue, 6 Nov 2012 13:36:28 +0800
From: Shaohua Li <shli@kernel.org>
To: Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH RFC] mm/swap: automatic tuning for swapin readahead
Message-ID: <20121106053628.GA1539@kernel.org>
References: <506AACAC.2010609@openvz.org>
 <alpine.LSU.2.00.1210031337320.1415@eggly.anvils>
 <506DB816.9090107@openvz.org>
 <alpine.LSU.2.00.1210081451410.1384@eggly.anvils>
 <20121016005049.GA1467@kernel.org>
 <20121022073654.GA7821@kernel.org>
 <alpine.LNX.2.00.1210222141170.1136@eggly.anvils>
 <20121023055127.GA24239@kernel.org>
 <50869E6C.1080907@redhat.com>
 <20121024011356.GA6400@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024011356.GA6400@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 09:13:56AM +0800, Shaohua Li wrote:
> On Tue, Oct 23, 2012 at 09:41:00AM -0400, Rik van Riel wrote:
> > On 10/23/2012 01:51 AM, Shaohua Li wrote:
> > 
> > >I have no strong point against the global state method. But I'd agree making the
> > >heuristic simple is preferred currently. I'm happy about the patch if the '+1'
> > >is removed.
> > 
> > Without the +1, how will you figure out when to re-enable readahead?
> 
> Below code in swapin_nr_pages can recover it.
> +               if (offset == prev_offset + 1 || offset == prev_offset - 1)
> +                       pages <<= 1;
> 
> Not perfect, but should work in some sort. This reminds me to think if
> pagereadahead flag is really required, hit in swap cache is a more reliable way
> to count readahead hit, and as Hugh mentioned, swap isn't vma bound.

Hugh,
ping! Any chance you can check this again?

Thanks,
Shaohua
