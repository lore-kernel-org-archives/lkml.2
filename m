Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab0KXQMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 11:12:14 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61800 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab0KXQML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 11:12:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rotYdpaBD8x2MPg1Ve8LPVSe28V6stecQWObV/qPLxLQswBSJ4SSt4heWJw78f7dIn
         sqVrLH1ela9oZ2StXBgs+2A6UwuYT8WqFsih8+StfGg69lpDcwLsXF+lm+Z5KNTjJHWH
         MJtWC9TilyJgCtspusv7Hz4a0Fd1z5liSacHc=
Date: Wed, 24 Nov 2010 19:11:54 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: mkl0301@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dbrownell@users.sourceforge.net, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 1/3] ARM: cns3xxx: Add new and export the old power
 management functions
Message-ID: <20101124161154.GA10890@oksana.dev.rtsoft.ru>
References: <1290443565-20766-1-git-send-email-mkl0301@gmail.com>
 <1290443565-20766-2-git-send-email-mkl0301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1290443565-20766-2-git-send-email-mkl0301@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 12:32:43AM +0800, mkl0301@gmail.com wrote:
> From: Mac Lin <mkl0301@gmail.com>
> 
> This patch add cns3xxx_pwr_clk_dis, and export thoes power management functions
> that may be used by many other device drivers on CNS3XXX.
> 
> Signed-off-by: Mac Lin <mkl0301@gmail.com>
> ---
>  arch/arm/mach-cns3xxx/core.h            |    4 ++--
>  arch/arm/mach-cns3xxx/include/mach/pm.h |   19 +++++++++++++++++++
>  arch/arm/mach-cns3xxx/pm.c              |   17 +++++++++++++++++
>  3 files changed, 38 insertions(+), 2 deletions(-)
>  create mode 100644 arch/arm/mach-cns3xxx/include/mach/pm.h
> 
> diff --git a/arch/arm/mach-cns3xxx/core.h b/arch/arm/mach-cns3xxx/core.h
> index 6b33ec1..c6636bd 100644
> --- a/arch/arm/mach-cns3xxx/core.h
> +++ b/arch/arm/mach-cns3xxx/core.h
> @@ -11,13 +11,13 @@
>  #ifndef __CNS3XXX_CORE_H
>  #define __CNS3XXX_CORE_H
>  
> +#include <mach/pm.h>

This isn't needed in this file. Instead, devices.c should include
it. Plus, pm.c needs to include mach/pm.h, otherwise sparse gives
the following warnings:

  CHECK   arch/arm/mach-cns3xxx/pm.c
pm.c:26:6: warning: symbol 'cns3xxx_pwr_clk_dis' was not declared. Should it be static?
pm.c:35:6: warning: symbol 'cns3xxx_pwr_power_up' was not declared. Should it be static?
pm.c:47:6: warning: symbol 'cns3xxx_pwr_power_down' was not declared. Should it be static?
pm.c:121:10: warning: symbol 'usb_pwr_ref' was not declared. Should it be static?

I've fixed it up, and applied the patch to cns3xxx tree.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
