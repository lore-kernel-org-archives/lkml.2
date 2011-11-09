Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab1KIRCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 12:02:55 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:52516 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab1KIRCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 12:02:54 -0500
Date: Wed, 9 Nov 2011 09:02:48 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrea Arcangeli <aarcange@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@suse.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] thp: reduce khugepaged freezing latency
Message-ID: <20111109170248.GD1260@google.com>
References: <4EB8E969.6010502@suse.cz>
 <1320766151-2619-1-git-send-email-aarcange@redhat.com>
 <1320766151-2619-2-git-send-email-aarcange@redhat.com>
 <4EB98A83.3040101@linux.vnet.ibm.com>
 <4EBA75F2.4080800@linux.vnet.ibm.com>
 <20111109155342.GA1260@google.com>
 <20111109165201.GI5075@redhat.com>
 <20111109165925.GC1260@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111109165925.GC1260@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 08:59:25AM -0800, Tejun Heo wrote:
> Freezer depends on the usual "set_current_state(INTERRUPTIBLE); check
> freezing; schedule(); check freezing" construct and sends
> INTERRUPTIBLE wake up after setting freezing state.  The
> synchronization hasn't been completely clear but recently been cleaned
> up, so as long as freezing condition is tested after INTERRUPTIBLE is
> set before going to sleep, the event won't go missing.

Just in case, it's scheduled for the next merge window but TIF_FREEZE
is gone now.  There is freezing() helper which tests all pending
freezing conditions and the freezer guarantees there's mb between
assertion of freezing() and sending interruptible wakeups to target
tasks.

Thanks.

-- 
tejun
