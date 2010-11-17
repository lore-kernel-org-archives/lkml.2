Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933901Ab0KQB1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 20:27:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:43519 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933606Ab0KQB1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 20:27:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,208,1288594800"; 
   d="scan'208";a="627523919"
Subject: Re: [PATCH] acpi: fix acpi/video.h error and warning when PM is
 not enabled
From: Zhang Rui <rui.zhang@intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20101116165954.f7d8540b.randy.dunlap@oracle.com>
References: <AANLkTimYevUOSxDm+nGq_ctPEFp_E2zJR7rNGvUi2fWY@mail.gmail.com>
	 <20101116165954.f7d8540b.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 09:29:08 +0800
Message-ID: <1289957348.8148.2098.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 08:59 +0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> When CONFIG_PM is not enabled, acpi/video.h causes a build error.
> Also fix a longstanding warning.
> 
> include/acpi/video.h:22: warning: 'struct acpi_device' declared inside parameter list
> include/acpi/video.h:22: warning: its scope is only this definition or declaration, which is probably not what you want
> include/acpi/video.h: In function 'acpi_video_get_edid':
> include/acpi/video.h:24: error: 'ENODEV' undeclared (first use in this function)
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

we already have a patch at
http://marc.info/?l=linux-kernel&m=128369371631933&w=2
Not sure if Len has applied it or not.
Anyway, thanks for the patch. :)

-rui
> ---
>  include/acpi/video.h |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> --- lnx-2637-rc2.orig/include/acpi/video.h
> +++ lnx-2637-rc2/include/acpi/video.h
> @@ -1,6 +1,10 @@
>  #ifndef __ACPI_VIDEO_H
>  #define __ACPI_VIDEO_H
>  
> +#include <linux/errno.h>
> +
> +struct acpi_device;
> +
>  #define ACPI_VIDEO_DISPLAY_CRT  1
>  #define ACPI_VIDEO_DISPLAY_TV   2
>  #define ACPI_VIDEO_DISPLAY_DVI  3
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


