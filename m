Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab1AFI1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 03:27:13 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41999 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab1AFI1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 03:27:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=bSmPZlcwpjFMI28q2kVt/9viYseJTSPiZm3ylDeMdqs4aKfa9TVOZ5PgpxRyuH48oD
         qIRo+gUtwF9GfnZOhxxqvXrKbBOEXhggkPVsXpoNmle3LTM4oOOwEmJa4GOZ/4yESIGi
         7pUWRvcVZsx2yVoxcyVQjxM9yhPGG/D6OQQ0c=
Message-ID: <4D257CD9.8060909@gmail.com>
Date: Thu, 06 Jan 2011 09:27:05 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Brown, Len" <len.brown@intel.com>
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        steiner@sgi.com
Subject: ia64 build broken [was: mmotm 2010-12-23-16-58 uploaded]
References: <201012240132.oBO1W8Ub022207@imap1.linux-foundation.org> <4D232352.2030809@gmail.com> <4D234F8E.7080102@gmail.com>
In-Reply-To: <4D234F8E.7080102@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2011 05:49 PM, Jiri Slaby wrote:
> 16dc39c98a6ca56a27f22f7ac6731d8223237a2e is first bad commit
> commit 16dc39c98a6ca56a27f22f7ac6731d8223237a2e
> Author: Len Brown <len.brown@intel.com>
> Date:   Thu Dec 16 23:12:23 2010 -0500
> 
>     ACPI: use ioremap_cache()
> 
>     Although the temporary boot-time ACPI table mappings
>     were set up with CPU caching enabled, the permanent table
>     mappings and AML run-time region memory accesses were
>     set up with ioremap(), which on x86 is a synonym for
>     ioremap_nocache().
> 
>     Changing this to ioremap_cache() improves performance as
>     seen when accessing the tables via acpidump,
>     or /sys/firmware/acpi/tables.  It should also improve
>     AML run-time performance.
> 
>     No change on ia64.

BTW I've just noted, you actually broke ia64. The code reads like:
   return ioremap(unsigned long phys_addr, unsigned long size);

regards,
-- 
js
