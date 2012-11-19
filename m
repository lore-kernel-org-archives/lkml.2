Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab2KSQZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 11:25:09 -0500
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:41940 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab2KSQZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 11:25:08 -0500
Message-ID: <1353341812.10939.52.camel@misato.fc.hp.com>
Subject: Re: [PATCH v5 RESEND 1/5] ACPI: Add acpi_pr_<level>() interfaces
From: Toshi Kani <toshi.kani@hp.com>
To: Joe Perches <joe@perches.com>
Cc: linux-acpi@vger.kernel.org, rjw@sisk.pl, lenb@kernel.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, vijaymohan.pandarathil@hp.com,
        imammedo@redhat.com, prarit@redhat.com
Date: Mon, 19 Nov 2012 09:16:52 -0700
In-Reply-To: <1353341192.5287.9.camel@joe-AO722>
References: <1352214130-12055-1-git-send-email-toshi.kani@hp.com>
	 <1352214130-12055-2-git-send-email-toshi.kani@hp.com>
	 <1353315374.3129.3.camel@joe-AO722>
	 <1353340280.10939.42.camel@misato.fc.hp.com>
	 <1353341192.5287.9.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-19 at 08:06 -0800, Joe Perches wrote:
> On Mon, 2012-11-19 at 08:51 -0700, Toshi Kani wrote:
> > On Mon, 2012-11-19 at 00:56 -0800, Joe Perches wrote:
> > > is acpi_bus.h really the right file for these prototypes?
> > This interface is limited for ACPI, so it should be declared in a header
> > file under include/acpi.  Among the files in this directory, acpi_bus.h
> > seems to be a good fit as it declares the interfaces provided by ACPI
> > core.
> 
> I'd've put them in acpi.h or maybe created acpi_utils.h 

Hi Joe,

We cannot use acpi.h since it is an ACPICA header.  Creating
acpi_utils.h sounds good idea.  However, in line 40 of acpi_bus.h, it
has the following comment and declares multiple utility interfaces.

====
/* acpi_utils.h */
acpi_status
acpi_extract_package(union acpi_object *package,
                struct acpi_buffer *format, struct acpi_buffer *buffer);
  :
====

This looks to me that there was acpi_utils.h before, but someone had
merged it into acpi_bus.h for some reason.  This change was made before
the initial git repository was created, so I cannot check the change
log.  So, as of today, acpi_bus.h seems to be the place to declare ACPI
utility interfaces for ACPI core.

Thanks,
-Toshi 

