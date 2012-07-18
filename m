Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab2GRWto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 18:49:44 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46942 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751986Ab2GRWtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 18:49:41 -0400
Message-ID: <1342651781.2215.27.camel@joe2Laptop>
Subject: Re: [PATCH 1/4] ACPI: Add acpi_pr_<level>() interfaces
From: Joe Perches <joe@perches.com>
To: Toshi Kani <toshi.kani@hp.com>
Cc: shuah.khan@hp.com, lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, prarit@redhat.com,
        imammedo@redhat.com, vijaymohan.pandarathil@hp.com,
        shuahkhan@gmail.com
Date: Wed, 18 Jul 2012 15:49:41 -0700
In-Reply-To: <1342650386.3010.55.camel@misato.fc.hp.com>
References: <1342644027-19559-1-git-send-email-toshi.kani@hp.com>
	 <1342644027-19559-2-git-send-email-toshi.kani@hp.com>
	 <1342648771.5138.37.camel@lorien2>
	 <1342650386.3010.55.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-18 at 16:26 -0600, Toshi Kani wrote:
> On Wed, 2012-07-18 at 15:59 -0600, Shuah Khan wrote:
> > On Wed, 2012-07-18 at 14:40 -0600, Toshi Kani wrote:
> > > This patch introduces acpi_pr_<level>(), where <level> is a message
> > > level such as err/warn/info, to support improved logging messages
> > > for ACPI, esp. in hotplug operations.
[]
> > > diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
[]
> > > @@ -454,3 +454,35 @@ acpi_evaluate_hotplug_ost(acpi_handle handle, u32 source_event,
[]
> > > +	struct acpi_buffer buffer = {ACPI_ALLOCATE_BUFFER};
[]
> > > +	ret = acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
> > 
> > One big problem I see with this approach is now each acpi_printk() will
> > result in a call to acpi_get_name() which will invoke several ACPI
> > calls, including a call to acpi_ut_initialize_buffer() which allocates
> > buffer. Is this really warranted? What is the performance impact of this
> > change?
[]
> This interface is intended to be used by acpi_pr_<level>(), which is
> used for error, warning, debugging, etc.  It is not intended to be used
> in any performance path.

While it's not performance critical, perhaps the buffer
alloc/free could be avoided by using stack. Something like:

	char name[ACPI_PATH_SEGMENT_LENGTH * max_segments ? ];
	struct acpi_buffer buffer = {
		.length = ACPI_PATH_SEGMENT_LENGTH,
		.buffer = name,
	};


