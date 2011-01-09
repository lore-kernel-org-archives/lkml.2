Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab1AIMxG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 07:53:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:50862 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab1AIMxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 07:53:05 -0500
Message-Id: <1bdc18$j72i3m@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,296,1291622400"; 
   d="scan'208";a="644958326"
Date: Sun, 09 Jan 2011 12:52:50 +0000
To: "Carlos R. Mafra" <crmafra2@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.37: *ERROR* Attempting to mmap a purgeable buffer
In-Reply-To: <20110109124423.GA9131@Pilar.site>
References: <20110109124423.GA9131@Pilar.site>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Jan 2011 13:44:23 +0100, "Carlos R. Mafra" <crmafra2@gmail.com> wrote:
> Is there something else I can do to help? Is this something fixable in the
> kernel or was it an error with my hardware? Suddenly being kicked out of X is 
> quite bad, so I hope this can be fixed :-)

It's a use after free bug in the ddx, presumably. I haven't worked out how
yet since all active buffers should be appropriately marked. So either
there is a race in marking the buffer, or we failed to handle an error
appropriately or there is a real use-after-free. The kernel is being
gracious enough to warn you why userspace just crashed.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
