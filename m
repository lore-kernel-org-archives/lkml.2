Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab1IVE2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 00:28:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:2902 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265Ab1IVE2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 00:28:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,420,1312182000"; 
   d="scan'208";a="52655724"
Subject: Re: [PATCH] acpi: Fix possible recursive locking in hwregs.c
From: Lin Ming <ming.m.lin@intel.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>
In-Reply-To: <CADZ9YHhk0idJ6DQOfGmHJtY2RrHyk=D_m-wcOgN1rPp7_ommBg@mail.gmail.com>
References: <1316628589.7341.11.camel@localhost.localdomain>
	 <CAF1ivSbZf5zgJphyaLeUZfSgz-oPvAY0bG6V2OMeWPS60nsxxQ@mail.gmail.com>
	 <CADZ9YHhk0idJ6DQOfGmHJtY2RrHyk=D_m-wcOgN1rPp7_ommBg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Sep 2011 12:28:07 +0800
Message-ID: <1316665687.9107.10.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-22 at 11:35 +0800, Rakib Mullick wrote:
> On Thu, Sep 22, 2011 at 6:59 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> > On Thu, Sep 22, 2011 at 2:09 AM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> >> Calling pm-suspend might trigger a recursive lock in it's code path. In function acpi_hw_clear_acpi_status,
> >> acpi_os_release_lock holds the lock acpi_gbl_hardware_lock before calling acpi_hw_register_write(), then
> >> without releasing acpi_gbl_hardware_lock, this function calls acpi_ev_walk_gpe_list, which also tries to
> >> hold acpi_gbl_hardware_lock and thus causes possible recursive lock.
> >
> > No, acpi_ev_walk_gpe_list holds acpi_gbl_gpe_lock.
> >
> Yes, right. Actually, acpi_os_release_lock() tries to hold
> acpi_gbl_gpe_lock without releasing acpi_gbl_hardware_lock. Right?

Do you mean "acpi_ev_walk_gpe_list() tries to hold
acpi_gbl_gpe_lock..."?

We have below locks sequence. I don't see the problem.

acpi_hw_clear_acpi_status:

     <acquire acpi_gbl_hardware_lock>

         acpi_ev_walk_gpe_list:
             <acquire acpi_gbl_gpe_lock>
             ...
             <release acpi_gbl_gpe_lock>
         ...
     <release acpi_gbl_hardware_lock>

> 
> Thanks,
> Rakib


