Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab2G3I21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 04:28:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34706 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233Ab2G3I2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 04:28:25 -0400
Date: Mon, 30 Jul 2012 10:28:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: Witold Szczeponik <Witold.Szczeponik@gmx.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, bhelgaas@google.com, lenb@kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH V3 0/3] PNP: Allow PNP resources to be disabled
 (interface)
Message-ID: <20120730082820.GA32745@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Witold Szczeponik <Witold.Szczeponik@gmx.net>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, bhelgaas@google.com,
	lenb@kernel.org, linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org
References: <50158321.4030007@gmx.net>
 <201207292122.28249.rjw@sisk.pl>
 <50158FA9.7080700@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50158FA9.7080700@gmx.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2012 at 09:31:53PM +0200, Witold Szczeponik wrote:
> the aim is to select a PNP ACPI option where resources can be disabled
> (or are not needed).  E.g., the parallel port of the 600E can be used
> with and without IRQ lines.  The means to allow for this is to use the
> sysfs interface to select disabled resources (just like any other 
> resource value).  In https://lkml.org/lkml/2011/7/3/41, I used the 
> following example:
> 
>   echo disable > /sys/bus/pnp/devices/$device/resources
>   echo clear > /sys/bus/pnp/devices/$device/resources
>   echo set irq disabled > /sys/bus/pnp/devices/$device/resources
>   echo fill > /sys/bus/pnp/devices/$device/resources
>   echo activate > /sys/bus/pnp/devices/$device/resources
> 
> The third line is made possible by the patch series.  All other
> lines are already implemented.

Shouldn't this be rather "disable_irq" or something which is a single
word and thus would simplify parsing a lot?

Also, <Documentation/filesystems/sysfs.txt> says

"Attributes should be ASCII text files, preferably with only one value
per file. It is noted that it may not be efficient to contain only one
value per file, so it is socially acceptable to express an array of
values of the same type."

Thanks.

-- 
Regards/Gruss,
    Boris.
