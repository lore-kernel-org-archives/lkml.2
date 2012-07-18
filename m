Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab2GRWPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 18:15:51 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:9682 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab2GRWPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 18:15:50 -0400
Message-ID: <1342649467.3010.50.camel@misato.fc.hp.com>
Subject: Re: [PATCH 1/4] ACPI: Add acpi_pr_<level>() interfaces
From: Toshi Kani <toshi.kani@hp.com>
To: Joe Perches <joe@perches.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, prarit@redhat.com,
        imammedo@redhat.com, vijaymohan.pandarathil@hp.com
Date: Wed, 18 Jul 2012 16:11:07 -0600
In-Reply-To: <1342649174.2215.19.camel@joe2Laptop>
References: <1342644027-19559-1-git-send-email-toshi.kani@hp.com>
	 <1342644027-19559-2-git-send-email-toshi.kani@hp.com>
	 <1342646876.2215.6.camel@joe2Laptop>
	 <1342647716.3010.40.camel@misato.fc.hp.com>
	 <1342649174.2215.19.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-18 at 15:06 -0700, Joe Perches wrote:
> On Wed, 2012-07-18 at 15:41 -0600, Toshi Kani wrote:
> > On Wed, 2012-07-18 at 14:27 -0700, Joe Perches wrote:
> > > On Wed, 2012-07-18 at 14:40 -0600, Toshi Kani wrote:
> > > > This patch introduces acpi_pr_<level>(), where <level> is a message
> > > > level such as err/warn/info, to support improved logging messages
> > > > for ACPI, esp. in hotplug operations.
> > > 
> > > One more note:
> > > 
> > > > diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
> > > []
> > > > @@ -454,3 +454,35 @@ acpi_evaluate_hotplug_ost(acpi_handle handle, u32 source_event,
> > > []
> > > > +void
> > > > +acpi_printk(const char *level, acpi_handle handle, const char *fmt, ...)
> > > []
> > > > +	struct acpi_buffer buffer = {ACPI_ALLOCATE_BUFFER};
> > > []
> > > > +	ret = acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
> > > []
> > > > +	kfree(buffer.pointer);
> > > 
> > > There's a failure mode here because buffer.pointer
> > > isn't guaranteed to be initialized or set to NULL.
> > 
> > Hi Joe,
> > 
> > Yes, I thought that check was necessary as well.  However, to my
> > surprise, such check caused the following warning message from
> > patchcheck.pl.  So, I deleted the check...
> 
> checkpatch ain't very bright.
> 
> Because buffer is an automatic not a static,
> buffer.pointer needs to be set to NULL.
> 
> 	struct acpi_buffer buffer = {
> 		.length = ACPI_ALLOCATE_BUFFER,
> 		.pointer = NULL,
> 	};
> 
> then the kfree is fine.

Hi Joe,

Very good point!  I will update with the change.


Thanks,
-Toshi


> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


