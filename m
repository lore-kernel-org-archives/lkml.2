Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab2C0WBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 18:01:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33566 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180Ab2C0WBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 18:01:14 -0400
Date: Tue, 27 Mar 2012 15:01:08 -0700
From: Tejun Heo <tj@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 2/2] firmware_class: Move request_firmware_nowait() to
 workqueues
Message-ID: <20120327220108.GB22371@google.com>
References: <201203260000.34377.rjw@sisk.pl>
 <1332883710-7486-2-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332883710-7486-2-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 02:28:30PM -0700, Stephen Boyd wrote:
> Oddly enough a work_struct was already part of the firmware_work
> structure but nobody was using it. Instead of creating a new
> kthread for each request_firmware_nowait() call just schedule the
> work on the long system workqueue. This should avoid some overhead
> in forking new threads when they're not strictly necessary.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
> 
> Is it better to use alloc_workqueue() and not put these on the system
> long workqueue?

No, just use schedule_work() unless there are specific requirements
which can't be fulfilled that way (e.g. it's on memory allocation
path, may consume large amount of cpu cycles, ...)

Thanks.

-- 
tejun
