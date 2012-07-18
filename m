Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab2GRXhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 19:37:15 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:29911 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab2GRXhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 19:37:12 -0400
Message-ID: <1342654349.3010.83.camel@misato.fc.hp.com>
Subject: Re: [PATCH 1/4] ACPI: Add acpi_pr_<level>() interfaces
From: Toshi Kani <toshi.kani@hp.com>
To: Joe Perches <joe@perches.com>
Cc: shuah.khan@hp.com, lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, prarit@redhat.com,
        imammedo@redhat.com, vijaymohan.pandarathil@hp.com,
        shuahkhan@gmail.com
Date: Wed, 18 Jul 2012 17:32:29 -0600
In-Reply-To: <1342651781.2215.27.camel@joe2Laptop>
References: <1342644027-19559-1-git-send-email-toshi.kani@hp.com>
	 <1342644027-19559-2-git-send-email-toshi.kani@hp.com>
	 <1342648771.5138.37.camel@lorien2>
	 <1342650386.3010.55.camel@misato.fc.hp.com>
	 <1342651781.2215.27.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-18 at 15:49 -0700, Joe Perches wrote:
> On Wed, 2012-07-18 at 16:26 -0600, Toshi Kani wrote:
> > On Wed, 2012-07-18 at 15:59 -0600, Shuah Khan wrote:
> > > On Wed, 2012-07-18 at 14:40 -0600, Toshi Kani wrote:
> > > > This patch introduces acpi_pr_<level>(), where <level> is a message
> > > > level such as err/warn/info, to support improved logging messages
> > > > for ACPI, esp. in hotplug operations.
> []
> > > > diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
> []
> > > > @@ -454,3 +454,35 @@ acpi_evaluate_hotplug_ost(acpi_handle handle, u32 source_event,
> []
> > > > +	struct acpi_buffer buffer = {ACPI_ALLOCATE_BUFFER};
> []
> > > > +	ret = acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
> > > 
> > > One big problem I see with this approach is now each acpi_printk() will
> > > result in a call to acpi_get_name() which will invoke several ACPI
> > > calls, including a call to acpi_ut_initialize_buffer() which allocates
> > > buffer. Is this really warranted? What is the performance impact of this
> > > change?
> []
> > This interface is intended to be used by acpi_pr_<level>(), which is
> > used for error, warning, debugging, etc.  It is not intended to be used
> > in any performance path.
> 
> While it's not performance critical, perhaps the buffer
> alloc/free could be avoided by using stack. Something like:
> 
> 	char name[ACPI_PATH_SEGMENT_LENGTH * max_segments ? ];
> 	struct acpi_buffer buffer = {
> 		.length = ACPI_PATH_SEGMENT_LENGTH,
> 		.buffer = name,
> 	};
> 

Hi Joe,

I thought about using stack initially, but I too was not sure how big
the buffer size should be, and was a bit afraid of causing kernel stack
overflow potentially.  Since it is mainly used for error paths in ACPI
hotplug handlers, I do not think alloc/free can lead any performance
impact.

Thanks,
-Toshi


