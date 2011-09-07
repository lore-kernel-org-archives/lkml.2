Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab1IGQux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:50:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51599 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab1IGQuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:50:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: [PATCH] vt/suspend: cleanup #if defined uglyness and fix compile error
Date: Wed, 7 Sep 2011 18:49:43 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org, akpm@linux-foundation.org,
        gregkh@suse.de, pavel@ucw.cz, rjw@sisk.pl, len.brown@intel.com,
        art@ified.ca, jslaby@suse.cz
References: <201109061404.10301.hartleys@visionengravers.com>
In-Reply-To: <201109061404.10301.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109071849.43603.arnd@arndb.de>
X-Provags-ID: V02:K0:i2dKz4wPUPN2YcYhP9wQXBH6N+1ASiWsvbn+UZz1Ip3
 NcXSXFBN0iOj6snLm5Fx4eaS6VBsBxLALrPZmYIF5Np8IC73st
 MwA4g9jBB1grcMb4nntctVWIZ5ldLGg6VP/FxZ93/7DHIKmUOQ
 aqBq7CFvurxiSpE0Eb2FBE6i/RFMwPmzRPnU7/DEeSve9kgzVl
 Si/He/eQR/2LEWm3vg92Fq1psm9NxL1SCxUjgEG2+XDOgeG7CU
 Bcjq1JkmGtJsU4NubFPsXGQyhW9NkdpKVFj2dbksohat6PrsvL
 RkknnrInY8yUYmNZFCAuL9u5L4jl3pmmEDMH1JL5Nb9bgGNd3K
 VZ/tCdEVYDFbj6n9wy78=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 September 2011, H Hartley Sweeten wrote:
> rder to cleanup
> the #if defined ugliness for the vt suspend support functions. Note that
> CONFIG_VT_CONSOLE is already dependant on CONFIG_VT.
> 
> The function pm_set_vt_switch is actually dependant on CONFIG_VT and not
> CONFIG_PM_SLEEP. This fixes a compile error when CONFIG_PM_SLEEP is
> not set:
> 
> drivers/tty/vt/vt_ioctl.c:1794: error: redefinition of 'pm_set_vt_switch'
> include/linux/suspend.h:17: error: previous definition of 'pm_set_vt_switch' was here
> 
> Also, remove the incorrect path from the comment in console.c.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Arnd Bergmann <arnd@arnd.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Arthur Taylor <art@ified.ca>
> Cc: Jiri Slaby <jslaby@suse.cz>

Acked-by: Arnd Bergmann <arnd@arndb.de>
