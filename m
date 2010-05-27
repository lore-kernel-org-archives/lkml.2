Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151Ab0E0OTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 10:19:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:46979 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339Ab0E0OTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 10:19:52 -0400
Date: Thu, 27 May 2010 07:22:07 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Len Brown <lenb@kernel.org>, x86@kernel.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 8/8] intel_idle: create a native cpuidle driver for
 select intel processors
Message-ID: <20100527072207.2e783b1e@infradead.org>
In-Reply-To: <87ljb5l9d5.fsf@deeprootsystems.com>
References: <1274928151-30919-1-git-send-email-lenb@kernel.org>
	<e099975ca65a7f6ac7f8bc3fee84d3e03893aa31.1274926772.git.len.brown@intel.com>
	<198450ec1600d9a7f55270dd4d44d6b55bc5b184.1274926772.git.len.brown@intel.com>
	<87ljb5l9d5.fsf@deeprootsystems.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010 07:14:46 -0700
Kevin Hilman <khilman@deeprootsystems.com> wrote:

> Len Brown <lenb@kernel.org> writes:
> 
> > From: Len Brown <len.brown@intel.com>
> >
> > This EXPERIMENTAL driver supersedes acpi_idle
> > on modern Intel processors. (Nehalem and Atom Processors).
> >
> > For CONFIG_INTEL_IDLE=y, intel_idle probes before acpi_idle,
> > no matter if CONFIG_ACPI_PROCESSOR=y or =m.
> >
> > Boot with "intel_idle.max_cstate=0" to disable the driver
> > and to fall back on ACPI.
> >
> > CONFIG_INTEL_IDLE=m is not recommended unless the system
> > has a method to guarantee intel_idle loads before ACPI's
> > processor_idle.
> >
> > This driver does not yet know about cpu online/offline
> > and thus will not yet play well with cpu-hotplug.
> >
> > Signed-off-by: Len Brown <len.brown@intel.com>
> > ---
> >  MAINTAINERS                     |    7 +
> >  drivers/Makefile                |    2 +-
> >  drivers/acpi/processor_driver.c |    6 +-
> >  drivers/idle/Kconfig            |   11 +
> >  drivers/idle/Makefile           |    1 +
> >  drivers/idle/intel_idle.c       |  446
> > +++++++++++++++++++++++++++++++++++++++
> 
> Any reason this arch-specific driver needs to be in drivers/idle
> instead of under a platform specific dir like arch/x86?
> 
> On embedded SoCs that have never had ACPI, we have our
> platform-specific CPUidle drivers in with the rest of our platform
> specific code.
> 

it's really inconvenient to have such drivers hidden in the
architecture code; it's much more convenient for cpuidle developers
if they're all in one place.
Think of it this way: you're not putting the NIC driver for your SOC in
a architecture directory either...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
