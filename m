Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab2KHRMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 12:12:44 -0500
Received: from [204.155.152.216] ([204.155.152.216]:44897 "EHLO shutemov.name"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751267Ab2KHRMn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 12:12:43 -0500
Date: Thu, 8 Nov 2012 19:14:22 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Mel Gorman <mgorman@suse.de>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, linux-man@vger.kernel.org
Subject: Re: [RFC 1/3] mm: Add VM pressure notifications
Message-ID: <20121108171421.GA4824@shutemov.name>
References: <20121107105348.GA25549@lizard>
 <20121107110128.GA30462@lizard>
 <20121108170124.GB8218@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20121108170124.GB8218@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2012 at 05:01:24PM +0000, Mel Gorman wrote:
> (Sorry about being very late reviewing this)
> 
> On Wed, Nov 07, 2012 at 03:01:28AM -0800, Anton Vorontsov wrote:
> > This patch introduces vmpressure_fd() system call. The system call creates
> > a new file descriptor that can be used to monitor Linux' virtual memory
> > management pressure. There are three discrete levels of the pressure:
> > 
> 
> Why was eventfd unsuitable? It's a bit trickier to use but there are
> examples in the kernel where an application is required to do something like
> 
> 1. open eventfd
> 2. open a control file, say /proc/sys/vm/vmpressure or if cgroups
>    /sys/fs/cgroup/something/vmpressure
> 3. write fd_event fd_control [low|medium|oom]. Can be a binary structure
>    you write
> 
> and then poll the eventfd. The trickiness is awkward but a library
> implementation of vmpressure_fd() that mapped onto eventfd properly should
> be trivial.
> 
> I confess I'm not super familiar with eventfd and if this can actually
> work in practice

You've described how it works for memory thresholds and oom notifications
in memcg. So it works. I also prefer this kind of interface.

See Documentation/cgroups/cgroups.txt section 2.4 and
Documentation/cgroups/memory.txt sections 9 and 10.

-- 
 Kirill A. Shutemov
