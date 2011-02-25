Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab1BYXUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 18:20:54 -0500
Received: from kroah.org ([198.145.64.141]:33420 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899Ab1BYXUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 18:20:53 -0500
Date: Fri, 25 Feb 2011 15:20:39 -0800
From: Greg KH <greg@kroah.com>
To: Mike Waychison <mikew@google.com>
Cc: Olof Johansson <olofj@chromium.org>, Andi Kleen <andi@firstfloor.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Robert Lippert <rlippert@google.com>, Jon Mayer <jonmayer@google.com>,
        Tony Luck <tony.luck@intel.com>, Duncan Laurie <dlaurie@google.com>,
        Aaron Durbin <adurbin@google.com>, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, David Hendrix <dhendrix@chromium.org>,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v2 6/5] Fix unaligned memory accesses in dmi-sysfs
Message-ID: <20110225232039.GA10930@kroah.com>
References: <20110223015307.13068.14063.stgit@mike.mtv.corp.google.com>
 <4D6835F1.2050304@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6835F1.2050304@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 03:06:25PM -0800, Mike Waychison wrote:
> DMI entries are arranged in memory back to back with no alignment
> guarantees. This means that the struct dmi_header passed to callbacks
> from dmi_walk() itself isn't byte aligned.  This causes problems on
> architectures that expect aligned data, such as IA64.
> 
> The dmi-sysfs patchset introduced structure member accesses through
> this passed in dmi_header.  Fix this by memcpy()ing the structures to
> temporary locations on stack when inspecting/copying them.
> 
> Signed-off-by: Mike Waychison <mikew@google.com>
> Tested-by: Tony Luck <tony.luck@intel.com>
> ---
>  dmi-sysfs.c |   28 +++++++++++++---------------
>  1 file changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
> index a5afd80..eb26d62 100644
> --- a/drivers/firmware/dmi-sysfs.c
> +++ b/drivers/firmware/dmi-sysfs.c
> @@ -263,20 +263,16 @@ struct dmi_system_event_log {
>  	u8	supported_log_type_descriptos[0];
>  } __packed;
> 
> -static const struct dmi_system_event_log *to_sel(const struct
> dmi_header *dh)

This patch is corrupted.  I tried to edit it by hand, but git still
didn't like it.

Please resend using whatever you did for your other patches, as this way
was not correct :(

thanks,

greg k-h
