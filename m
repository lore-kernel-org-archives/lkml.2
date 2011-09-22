Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab1IVDfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 23:35:25 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36659 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab1IVDfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 23:35:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAF1ivSbZf5zgJphyaLeUZfSgz-oPvAY0bG6V2OMeWPS60nsxxQ@mail.gmail.com>
References: <1316628589.7341.11.camel@localhost.localdomain>
	<CAF1ivSbZf5zgJphyaLeUZfSgz-oPvAY0bG6V2OMeWPS60nsxxQ@mail.gmail.com>
Date: Thu, 22 Sep 2011 09:35:23 +0600
Message-ID: <CADZ9YHhk0idJ6DQOfGmHJtY2RrHyk=D_m-wcOgN1rPp7_ommBg@mail.gmail.com>
Subject: Re: [PATCH] acpi: Fix possible recursive locking in hwregs.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 6:59 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> On Thu, Sep 22, 2011 at 2:09 AM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
>> Calling pm-suspend might trigger a recursive lock in it's code path. In function acpi_hw_clear_acpi_status,
>> acpi_os_release_lock holds the lock acpi_gbl_hardware_lock before calling acpi_hw_register_write(), then
>> without releasing acpi_gbl_hardware_lock, this function calls acpi_ev_walk_gpe_list, which also tries to
>> hold acpi_gbl_hardware_lock and thus causes possible recursive lock.
>
> No, acpi_ev_walk_gpe_list holds acpi_gbl_gpe_lock.
>
Yes, right. Actually, acpi_os_release_lock() tries to hold
acpi_gbl_gpe_lock without releasing acpi_gbl_hardware_lock. Right?

Thanks,
Rakib
