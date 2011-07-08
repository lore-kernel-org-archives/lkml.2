Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab1GHVAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 17:00:36 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:46299 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752146Ab1GHVAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 17:00:35 -0400
X-Sasl-enc: CQwH82vhydQHVspxDzodZVtnx3RILfQ17jDNPtzwvz3i 1310158834
Date: Fri, 8 Jul 2011 13:44:14 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/12] gma500: Re-order checks and dereferences in
 psb_intel_lvds
Message-ID: <20110708204414.GA28312@kroah.com>
References: <20110708084053.19581.81711.stgit@localhost.localdomain>
 <20110708084309.19581.86654.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110708084309.19581.86654.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 09:43:15AM +0100, Alan Cox wrote:
> From: Alan Cox <alan@linux.intel.com>
> 
> Dan Carpenter reports:
> 
> Smatch complains about 6a7afe3acc4b "gma500: continue abstracting
> platform specific code"
> 
> drivers/staging/gma500/psb_intel_lvds.c +579 psb_intel_lvds_set_property(7)
> 	warn: variable dereferenced before check 'encoder'
> 
> --- a/drivers/staging/gma500/psb_intel_lvds.c
> +++ b/drivers/staging/gma500/psb_intel_lvds.c
> @@ -575,11 +575,12 @@ int psb_intel_lvds_set_property(struct drm_connector
> *connector,
>                                        struct drm_property *property,
>                                        uint64_t value)
>  {
> -       struct drm_encoder *pEncoder = connector->encoder;
> +       struct drm_encoder *encoder = connector->encoder;
> +       struct drm_psb_private *dev_priv = encoder->dev->dev_private;
>                                            ^^^^^^^^^^^^
> dereference encoder here.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>

Oh that played hell with git, please don't do that again...

