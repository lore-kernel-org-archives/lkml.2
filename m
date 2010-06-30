Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab0F3JNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:13:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab0F3JNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 05:13:46 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4C2A6B6C.1000306@gmail.com>
References: <4C2A6B6C.1000306@gmail.com> <4C29674C.9070503@gmail.com> <4C28E14D.5050701@gmail.com> <1277621246-10960-4-git-send-email-justinmattock@gmail.com> <1277621246-10960-1-git-send-email-justinmattock@gmail.com> <7214.1277729293@redhat.com> <8066.1277750854@redhat.com> <22319.1277826461@redhat.com> 
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH 3/5]acpi:glue.c Fix warning: variable 'ret' set but not used
Date: Wed, 30 Jun 2010 10:13:35 +0100
Message-ID: <25800.1277889215@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock <justinmattock@gmail.com> wrote:

>  	if (!ACPI_FAILURE(status)) {
> -		int ret;
> 
> -		ret = sysfs_create_link(&dev->kobj, &acpi_dev->dev.kobj,
> +		fn = sysfs_create_link(&dev->kobj, &acpi_dev->dev.kobj,
>  				"firmware_node");
> -		ret = sysfs_create_link(&acpi_dev->dev.kobj, &dev->kobj,
> +		pn = sysfs_create_link(&acpi_dev->dev.kobj, &dev->kobj,
>  				"physical_node");
> +	if (fn) {

That new if-statement still needs indenting one more tab stop.  It's indented
the same as the previous if-statement, but is actually in the body of that
previous if-statement.

The body of the second if-statement should be indented one tab beyond the if,
and else/else-if statements and the final closing brace should be indented
level with the if:

	if (...) {
		body;
	} else if (...) {
		body;
	} else {
		body;
	}

so that they line up vertically.

> +		dev_warn(dev, "dev:%p Failed to create firmware_node: %d\n",
> +			acpi_dev, fn);

The "dev:%p " seems like it ought to be superfluous if you're using
dev_warn(), and certainly, returning the pointer isn't really useful, I
suspect.

However, at this point you have two device struct pointers: dev and
&acip_dev->dev, so printing them both is may be good.  Perhaps something like:

+		dev_warn(&acpi_dev->dev,
+			 "Failed to create firmware_node link to %s %s: %d\n",
+			 dev_driver_string(dev), dev_name(dev), fn);

David
