Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab0GAJcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 05:32:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545Ab0GAJb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 05:31:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4C2B9F49.8090304@gmail.com>
References: <4C2B9F49.8090304@gmail.com> <4C2A6B6C.1000306@gmail.com> <4C29674C.9070503@gmail.com> <4C28E14D.5050701@gmail.com> <1277621246-10960-4-git-send-email-justinmattock@gmail.com> <1277621246-10960-1-git-send-email-justinmattock@gmail.com> <7214.1277729293@redhat.com> <8066.1277750854@redhat.com> <22319.1277826461@redhat.com> <25800.1277889215@redhat.com> 
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH 3/5]acpi:glue.c Fix warning: variable 'ret' set but not used
Date: Thu, 01 Jul 2010 10:31:46 +0100
Message-ID: <16513.1277976706@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock <justinmattock@gmail.com> wrote:

> +		if (fn) {
> +			dev_warn(&acpi_dev->dev,
> +				"Failed to create firmware_node link to %s %s: %d\n",
> +				dev_driver_string(dev), dev_name(dev), fn);
> +		} else if (pn) {
> +			dev_warn(&acpi_dev->dev,
> +				"Failed to create physical_node link to %s %s: %d\n",
> +				dev_driver_string(dev), dev_name(dev), pn);
> +				return AE_ERROR;
> +		}			

There's one more question to ask yourself: do you really need two dev_warn()
statements?  You could have just one that prints both error values:

		if (fn || pn)
			dev_warn(&acpi_dev->dev,
				 "Failed to create link(s) to %s %s:"
				 " fn=%d pn=%d\n",
				 dev_driver_string(dev), dev_name(dev),
				 fn, pn);

Not sure it's worth going that far.  You could reduce it still further:

		if (fn || pn)
			dev_warn(&acpi_dev->dev,
				 "Failed to create link(s) to %s %s:"
				 " %d\n",
				 dev_driver_string(dev), dev_name(dev),
				 fn ?: pn);

Is it that important to know which failed to be created, or that both failed
to be created?

David
