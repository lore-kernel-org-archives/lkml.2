Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab2KTVUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 16:20:31 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:28637 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab2KTVUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 16:20:30 -0500
Message-ID: <1353445931.10939.100.camel@misato.fc.hp.com>
Subject: Re: [PATCH v6 1/5] ACPI: Add acpi_handle_<level>() interfaces
From: Toshi Kani <toshi.kani@hp.com>
To: Joe Perches <joe@perches.com>
Cc: linux-acpi@vger.kernel.org, rjw@sisk.pl, lenb@kernel.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, vijaymohan.pandarathil@hp.com
Date: Tue, 20 Nov 2012 14:12:11 -0700
In-Reply-To: <1353445837.17819.20.camel@joe-AO722>
References: <1353444294-25575-1-git-send-email-toshi.kani@hp.com>
	 <1353444294-25575-2-git-send-email-toshi.kani@hp.com>
	 <1353445837.17819.20.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-20 at 13:10 -0800, Joe Perches wrote:
> On Tue, 2012-11-20 at 13:44 -0700, Toshi Kani wrote:
> > This interface acquires the global namespace
> > mutex and may not be called from interrupt context.
> []
> > diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
> []
> > +/**
> > + * acpi_handle_printk: Print message with ACPI prefix and object path
> > + *
> > + * This function is called through acpi_handle_<level> macros and prints
> > + * a message with ACPI prefix and object path.  This function acquires
> > + * the global namespace mutex and may not be called from interrupt context.
> > + */
> > +void
> > +acpi_handle_printk(const char *level, acpi_handle handle, const char *fmt, ...)
> > +{
> []
> > +	ret = acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
> > +	if (ret == AE_OK)
> > +		path = buffer.pointer;
> > +	else
> > +		path = "<n/a>";
> 
> Perhaps:
> 	if (in_interrupt() ||
> 	    acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer) != AE_OK)
> 		path = "<n/a>";
> 	else
> 		path = buffer.pointer;
> 
> so that any interrupt context still works, just
> not printing the correct acpi_get_name;

Hi Joe,

Good idea.  I will update the patch as you suggested.

Thanks,
-Toshi



