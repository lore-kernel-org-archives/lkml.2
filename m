Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab2EGDlQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 23:41:16 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:58200 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab2EGDlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 23:41:15 -0400
Message-ID: <4FA74089.4080204@linux.vnet.ibm.com>
Date: Mon, 07 May 2012 08:54:57 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411 Thunderbird/11.0.1
MIME-Version: 1.0
To: Sameer Nanda <snanda@chromium.org>
CC: mingo@redhat.com, peterz@infradead.org, len.brown@intel.com, pavel@ucw.cz,
        rjw@sisk.pl, akpm@linux-foundation.org, dzickus@redhat.com,
        msb@chromium.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, olofj@chromium.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] watchdog: fix for lockup detector breakage on resume
References: <1335550240-17765-1-git-send-email-snanda@chromium.org> <1335892956-30606-1-git-send-email-snanda@chromium.org>
In-Reply-To: <1335892956-30606-1-git-send-email-snanda@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12050617-6102-0000-0000-00000163A4B6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 May 2012 10:52 PM, Sameer Nanda wrote:

> On the suspend/resume path the boot CPU does not go though an
> offline->online transition.  This breaks the NMI detector
> post-resume since it depends on PMU state that is lost when
> the system gets suspended.


We should not have allowed the PMU to go with events counting on it across the suspend/resume transition
and find out that the state has been lost. This patch solves the problem of the NMI detector as we restart the
counter again when the boot cpu comes back online during resume. But the original cause (PMU going with
counters into the suspend state) which triggered this problem is still there. May be we should have called
perf_event_exit() on the boot cpu before going into the suspend state. 

Regards
Anshuman

