Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab2LCTvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 14:51:54 -0500
Received: from [206.117.179.246] ([206.117.179.246]:49399 "EHLO labridge.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752129Ab2LCTvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 14:51:52 -0500
Message-ID: <1354564292.3524.7.camel@joe-AO722>
Subject: Re: [PATCH v4 1/3] aerdrv: Trace Event for AER
From: Joe Perches <joe@perches.com>
To: Lance Ortiz <lance.ortiz@hp.com>
Cc: bhelgaas@google.com, lance_ortiz@hotmail.com, jiang.liu@huawei.com,
        tony.luck@intel.com, bp@alien8.de, rostedt@goodmis.org,
        mchehab@redhat.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 03 Dec 2012 11:51:32 -0800
In-Reply-To: <20121203183305.26636.22979.stgit@grignak.americas.hpqcorp.net>
References: <20121203183305.26636.22979.stgit@grignak.americas.hpqcorp.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-03 at 11:33 -0700, Lance Ortiz wrote:
> This header file will define a new trace event that will be triggered when
> a AER event occurs.  The following data will be provided to the trace
> event.

trivial notes:

> diff --git a/include/trace/events/ras.h b/include/trace/events/ras.h
[]
> +#define correctable_error_string			\
> +	{BIT(0),	"Receiver Error"},		\
> +	{BIT(6),	"Bad TLP"},			\
> +	{BIT(7),	"Bad DLLP"},			\
> +	{BIT(8),	"RELAY_NUM Rollover"},		\
> +	{BIT(12),	"Replay Timer Timeout"},	\
> +	{BIT(13),	"Advisory Non-Fatal"}
> +
> +#define uncorrectable_error_string			\
> +	{BIT(4),	"Data Link Protocol"},		\
> +	{BIT(12),	"Poisoned TLP"},		\
> +	{BIT(13),	"Flow Control Protocol"},	\
> +	{BIT(14),	"Completion Timeout"},		\
> +	{BIT(15),	"Completer Abort"},		\
> +	{BIT(16),	"Unexpected Completion"},	\
> +	{BIT(17),	"Receiver Overflow"},		\
> +	{BIT(18),	"Malformed TLP"},		\
> +	{BIT(19),	"ECRC"},			\
> +	{BIT(20),	"Unsupported Request"}

probably better to prefix these with aer_

> +	TP_printk("%s PCIe Bus Error: severity=%s, %s\n",
> +		__get_str(dev_name),
> +		(__entry->severity == HW_EVENT_ERR_CORRECTED) ? "Corrected" :
> +			((__entry->severity == HW_EVENT_ERR_FATAL) ?
> +			"Fatal" : "Uncorrected"),

unnecessary parentheses

		__entry->severity == HW_EVENT_ERR_CORRECTED ? "Corrected" :
		__entry->severity == HW_EVENT_ERR_FATAL ? "Fatal" :
		"Uncorrected"),

might be more kernel style conventional

