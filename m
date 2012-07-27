Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab2G0AiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 20:38:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38796 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab2G0AiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 20:38:24 -0400
MIME-Version: 1.0
In-Reply-To: <20120726194324.GG5637@redhat.com>
References: <1343191185-7746-1-git-send-email-ming.lei@canonical.com>
	<20120726194324.GG5637@redhat.com>
Date: Fri, 27 Jul 2012 08:38:21 +0800
Message-ID: <CACVXFVPdKzHXE=mV=FOx8xV4BLUEo_Ey9p6e9CkSOHxxYBfVgA@mail.gmail.com>
Subject: Re: [PATCH] kernel/watchdog.c : fix smp_processor_id() warning
From: Ming Lei <ming.lei@canonical.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Sameer Nanda <snanda@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 3:43 AM, Don Zickus <dzickus@redhat.com> wrote:
> On Wed, Jul 25, 2012 at 12:39:45PM +0800, Ming Lei wrote:
>> Use raw_smp_processor_id in lockup_detector_bootcpu_resume()
>> because it is enough when non-boot CPUs are offline.
>>
>> This patch fixes the following warning when DEBUG_PREEMPT
>> is enabled.
>
> Is this patched on top of linux-next?

Yes.

The warning is introduced by the commit below:

      7fb860ff90ae970cf62cf676dfc1addcf8415674
      (NMI watchdog: fix for lockup detector breakage on resume)


> It seems right based on the code usage.  Though it makes me sad the resume
> code has to hack into the cpu notifiers like that.

Thanks,
--
Ming Lei
