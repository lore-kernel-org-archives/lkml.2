Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161022Ab2EKR1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 13:27:30 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:9042 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600Ab2EKR12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 13:27:28 -0400
Message-ID: <1336757092.16730.250.camel@misato.fc.hp.com>
Subject: Re: [PATCH v3 0/7] ACPI: Add _OST support for ACPI hotplug
From: Toshi Kani <toshi.kani@hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, bhelgaas@google.com,
        shuahkhan@gmail.com, liuj97@gmail.com, linux-kernel@vger.kernel.org
Date: Fri, 11 May 2012 11:24:52 -0600
In-Reply-To: <m2vck2lk4t.fsf@firstfloor.org>
References: <1336754223-5346-1-git-send-email-toshi.kani@hp.com>
	 <m2vck2lk4t.fsf@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-11 at 10:09 -0700, Andi Kleen wrote:
> Toshi Kani <toshi.kani@hp.com> writes:
> 
> > This patchset supports ACPI OSPM Status Indication (_OST) method for
> > ACPI CPU/memory/container hotplug operations and sysfs eject. After
> > ACPI hotplug operation has completed, OSPM calls _OST to indicate the
> > result of the operation to the platform. If _OST is not present, this
> > patchset has no effect on the platform.
> >
> > This _OST support can be enabled or disabled with a new config option
> > CONFIG_ACPI_HOTPLUG_OST. This option is disabled by default. When
> > this option is disabled, this patchset has no effect on the platform.
> 
> Does that control compiling in/out significant sized code?
> 
> Controlling code behaviour by CONFIG option has been long deprecated.
> This is always better done as a runtime option.
> 
> Just think what should a distribution who wants to use the same binary
> on all systems set.

Good question.  The OS needs to tell the platform if it supports _OST at
boot-time, and has to stick with it.  Therefore, this feature may not be
enabled/disabled during run-time.  Another reason is that this feature
depends on ACPI_HOTPLUG_CPU, ACPI_HOTPLUG_MEMORY and ACPI_CONTAINER
config options in order to provide consistent behavior among multiple
hotplug operations with regarding the _OST support.

Thanks,
-Toshi

