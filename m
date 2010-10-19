Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab0JSPzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:55:50 -0400
Received: from kroah.org ([198.145.64.141]:59757 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880Ab0JSPzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:55:48 -0400
Date: Tue, 19 Oct 2010 08:48:38 -0700
From: Greg KH <greg@kroah.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shaohua Li <shaohua.li@intel.com>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH RESEND] ACPI dock: move some functions to .init.text
Message-ID: <20101019154838.GF4589@kroah.com>
References: <1277127073-10485-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1287472419-13187-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1287472419-13187-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 09:13:39AM +0200, Uwe Kleine-König wrote:
> find_dock and find_bay are only called by dock_init which lives in
> .init.text dock_add is only called by find_dock and find_bay.  So all
> three functions can be moved to .init.text, too.
> 
> This fixes:
> 
>         WARNING: vmlinux.o(.text+0x2134b7): Section mismatch in reference from the function dock_add() to the function .init.text:platform_device_register_resndata()
>         The function dock_add() references
>         the function __init platform_device_register_resndata().
>         This is often because dock_add lacks a __init
>         annotation or the annotation of platform_device_register_resndata is wrong.
> 
> for a build with unset CONFIG_MODULES.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
