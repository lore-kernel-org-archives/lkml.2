Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab0GNNNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 09:13:38 -0400
Received: from adelie.canonical.com ([91.189.90.139]:32948 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab0GNNNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 09:13:36 -0400
Date: Wed, 14 Jul 2010 14:13:34 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Possible false positive from checkpatch.pl
Message-ID: <20100714131334.GB20746@shadowen.org>
References: <4C3B5660.8020405@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3B5660.8020405@lwfinger.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 12:52:32PM -0500, Larry Finger wrote:
> Andy,
> 
> In preparing a vendor driver for submission to staging, I am getting
> the following from checkpatch.pl:
> 
> ERROR: Macros with multiple statements should be enclosed in a do - while loop
> #377: FILE: staging/rtl8712/rtl871x_mp_ioctl.h:377:
> +#define GEN_MP_IOCTL_HANDLER(sz, hdl, oid) {sz, hdl, oid},
> 
> ERROR: Macros with multiple statements should be enclosed in a do - while loop
> #378: FILE: staging/rtl8712/rtl871x_mp_ioctl.h:378:
> +#define EXT_MP_IOCTL_HANDLER(sz, subcode, oid) {sz, &mp_ioctl_ \
> +       ## subcode ## _hdl, oid},
> 
> total: 2 errors, 0 warnings, 466 lines checked
> 
> Enclosing these macros in a do {...} while (0) is definitely wrong
> and will not compile. Moving the comma from the end of the macro to
> the lines that invoke it fixes the problem, but should not be
> necessary.

They do look like a false positive to me.  Its not entirly obvious id we
cna detect them as valid exceptions.  Always remember that checkpatch is
an advisor, if its wrong it can and should be ignored.

I will think on this some.

-apw
