Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab2DDVWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 17:22:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54122 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943Ab2DDVW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 17:22:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] More power management updates for 3.4
Date: Wed, 4 Apr 2012 23:26:47 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201204010836.30707.rjw@sisk.pl>
In-Reply-To: <201204010836.30707.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204042326.47683.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday, April 01, 2012, Rafael J. Wysocki wrote:
> Hi Linus,
> 
> I prepared this on Friday with the hope to send the pull request before the end
> of the merge window, but then I had to go to San Francisco (for the LFCS) and
> missed the opportunity.  That said, this includes fixes mostly (and -stable
> ones for that matter), so I think it's appropriate for the -rc1 time frame too. 
> 
> Please pull additional power management updates for 3.4 since commit
> 735e941caa9a35f933297af0ab1e0ad6447411c4:
> 
>     Merge tag 'common-clk-api' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
> 
> with top-most commit c4772d192c70b61d52262b0db76f7abd8aeb51c6:
> 
>     PM / QoS: add pm_qos_update_request_timeout() API
> 
> from the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-for-3.4-part-2

Given the lack of feedback and the fact that you don't seem to have pulled this,
I wonder if there's anything wrong with the changes or am I simply supposed to
queue them up for 3.5?

Or would you like me to prepare another pull request without the top-most
commit that doesn't count as a fix (I rather won't be able to prepare it
before -rc2 is out, though, due to travel-related limitations)?

Rafael


> This mostly consists of fixes and changes requisite for those fixes, with the
> exception of the last commit, which is a new feature.  However, that new
> feature is reasonably isolated and very unlikely to cause any regressions to
> happen, although it is necessary for some future changes in the works now.
> Included are:
> 
> * Patch series that hopefully fixes races between the freezer and request_firmware()
>   and request_firmware_nowait() for good, with two cleanups from Stephen Boyd on top.
> 
> * Runtime PM fix from Alan Stern preventing tasks from getting stuck indefinitely
>   in the runtime PM wait queue.
> 
> * Device PM QoS update from MyungJoo Ham introducing a new variant of
>   pm_qos_update_request() allowing the callers to specify a timeout.
> 
> Thanks!
> 
> 
>  drivers/base/firmware_class.c |  208 +++++++++++++++++++++--------------------
>  drivers/base/power/runtime.c  |    3 +-
>  include/linux/kmod.h          |   27 +++++-
>  include/linux/pm_qos.h        |    4 +
>  kernel/kmod.c                 |  117 +++++++++++++++++------
>  kernel/power/hibernate.c      |   18 +---
>  kernel/power/process.c        |    8 ++
>  kernel/power/qos.c            |   50 ++++++++++
>  kernel/power/suspend.c        |    7 --
>  kernel/power/user.c           |   10 +--
>  10 files changed, 284 insertions(+), 168 deletions(-)
> 
> ---------------
> 
> Alan Stern (1):
>       PM / Runtime: don't forget to wake up waitqueue on failure
> 
> MyungJoo Ham (1):
>       PM / QoS: add pm_qos_update_request_timeout() API
> 
> Rafael J. Wysocki (6):
>       firmware_class: Rework usermodehelper check
>       firmware_class: Split _request_firmware() into three functions, v2
>       firmware_class: Do not warn that system is not ready from async loads
>       PM / Hibernate: Disable usermode helpers right before freezing tasks
>       PM / Sleep: Move disabling of usermode helpers to the freezer
>       PM / Sleep: Mitigate race between the freezer and request_firmware()
> 
> Stephen Boyd (2):
>       firmware_class: Reorganize fw_create_instance()
>       firmware_class: Move request_firmware_nowait() to workqueues
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

