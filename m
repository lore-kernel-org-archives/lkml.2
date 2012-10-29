Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab2J2KmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 06:42:24 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:58983 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752902Ab2J2KmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 06:42:23 -0400
Message-ID: <1351507340.1339.12.camel@x61.thuisdomein>
Subject: Re: [PATCH] aic94xx: fix handling of default CTRL-A settings
From: Paul Bolle <pebolle@tiscali.nl>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 29 Oct 2012 11:42:20 +0100
In-Reply-To: <1348574859.1436.38.camel@x61.thuisdomein>
References: <1348574859.1436.38.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Oct 2012 10:42:20.0327 (UTC) FILETIME=[128F3370:01CDB5C2]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-25 at 14:07 +0200, Paul Bolle wrote:
> Compiling aic94xx_sds.o (part of the aic94xx driver) triggers this GCC
> warning:
>     drivers/scsi/aic94xx/aic94xx_sds.c: In function 'asd_read_flash':
>     drivers/scsi/aic94xx/aic94xx_sds.c:597:21: warning: 'offs' may be used uninitialized in this function [-Wmaybe-uninitialized]
>     drivers/scsi/aic94xx/aic94xx_sds.c:985:6: note: 'offs' was declared here
> 
> This warning can be traced back to asd_find_flash_de(). If it fails to
> find a FLASH_DE_CTRL_A_USER entry it will return without setting 'offs'.
> And that will leave 'offs' uninitialized when asd_read_flash_seg() is
> called a little later.
> 
> But that call of asd_read_flash_seg() isn't needed in that case.
> Everything this code cares about can already be found in the "default
> CTRL-A user settings section" that was created in the error path. So
> let's just jump over that call (and all other unneeded code) after
> creating that section.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) I noticed this warning while building v3.6-rc7 on current Fedora
> 17, using Fedora's default config.

And, again, identical warnings can be seen while building v3.7-rc3.
What's the status of my patch? Did anyone found some time to have a look
at it?


Paul Bolle

