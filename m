Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab0IRLvi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 07:51:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53001 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab0IRLvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 07:51:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ehEYe1kS5J2AGkdI5gbp8/XZw5TYthIzHAwcRE6f4mvG4M67VPFKgCi4VBkge/5hM0
         uzREyyeb0i6h6PstF5WInllVZpUpqKiwKB3ciEQA8v8anaQVprU4kxnu6lOlsF4Odi9y
         7r+cIi5+iB0p3cq6uMVNGY+/N/XmuHNauca3w=
Date: Sat, 18 Sep 2010 13:50:43 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Dave Airlie <airlied@redhat.com>, David Airlie <airlied@linux.ie>
Subject: Re: [PATCH] drm/edid: Don't repeatedly log hex dumps of bad EDIDs
 by default
Message-ID: <20100918115043.GB2953@joi.lan>
References: <1284764006.13604.21.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284764006.13604.21.camel@morgan.silverblock.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 06:53:26PM -0400, Andy Walls wrote:
> On my system, every 10 seconds drm_edid_block_valid() gets called 4
> times by radeon_dvi_detect().  This results in 4 instances of a
> multi-line hex dump of the same EDID (non-)data being logged every 10
> seconds.
> 
> Silence the hex dump from drm_edid_block_valid() unless a drm_debug
> module parameter flag is set.
> 
> Signed-of-by: Andy Walls <awalls@md.metrocast.net>
> 
> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> index dce5c4a..33a748c 100644
> --- a/drivers/gpu/drm/drm_edid.c
> +++ b/drivers/gpu/drm/drm_edid.c
> @@ -173,9 +173,12 @@ drm_edid_block_valid(u8 *raw_edid)
>  
>  bad:
>         if (raw_edid) {
> -               DRM_ERROR("Raw EDID:\n");
> -               print_hex_dump_bytes(KERN_ERR, DUMP_PREFIX_NONE, raw_edid, EDID_LENGTH);
> -               printk("\n");
> +               DRM_DEBUG("Raw EDID:\n");
> +               if (drm_debug & DRM_UT_CORE) {
> +                       print_hex_dump_bytes(KERN_ERR, DUMP_PREFIX_NONE,
> +                                            raw_edid, EDID_LENGTH);
> +                       printk("\n");
> +               }
>         }
>         return 0;
>  }
> 

Why not print it only once on original error level?
Something like:
static bool printed = false;
if (!printed) {
	...
	printed = true;
}

It has the same effect for you (no spamming by default) and it's still provide some information.

Marcin

