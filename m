Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab0HVK2C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 06:28:02 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44813 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab0HVK16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 06:27:58 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 4/4] writeback: Reporting dirty thresholds in /proc/vmstat
Cc: kosaki.motohiro@jp.fujitsu.com, Michael Rubin <mrubin@google.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, fengguang.wu@intel.com, jack@suse.cz,
        riel@redhat.com, akpm@linux-foundation.org, david@fromorbit.com,
        npiggin@kernel.dk, hch@lst.de, axboe@kernel.dk
In-Reply-To: <20100820190603.6003.A69D9226@jp.fujitsu.com>
References: <1282296689-25618-5-git-send-email-mrubin@google.com> <20100820190603.6003.A69D9226@jp.fujitsu.com>
Message-Id: <20100822192710.6018.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun, 22 Aug 2010 19:27:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The kernel already exposes the user desired thresholds in /proc/sys/vm
> > with dirty_background_ratio and background_ratio. But the kernel may
> > alter the number requested without giving the user any indication that
> > is the case.
> > 
> > Knowing the actual ratios the kernel is honoring can help app developers
> > understand how their buffered IO will be sent to the disk.
> > 
> > 	$ grep threshold /proc/vmstat
> > 	nr_dirty_threshold 409111
> > 	nr_dirty_background_threshold 818223
> > 
> > Signed-off-by: Michael Rubin <mrubin@google.com>
> 
> Looks good to me.
> 	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

sorry, this is mistake. Wu pointed out this patch is unnecessary.


Wu wrote: 
> I realized that the dirty thresholds has already been exported here:
> 
> $ grep Thresh  /debug/bdi/8:0/stats
> BdiDirtyThresh:     381000 kB
> DirtyThresh:       1719076 kB
> BackgroundThresh:   859536 kB
> 
> So why not use that interface directly?



