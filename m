Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab1HZR0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 13:26:17 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:58558 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752182Ab1HZR0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 13:26:16 -0400
Date: Fri, 26 Aug 2011 10:26:12 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Smack: SMACK_IOCLOADACCESS
Message-Id: <20110826102612.087b673e.rdunlap@xenotime.net>
In-Reply-To: <1314337927-17210-1-git-send-email-jarkko.sakkinen@intel.com>
References: <1314337927-17210-1-git-send-email-jarkko.sakkinen@intel.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Aug 2011 08:52:07 +0300 Jarkko Sakkinen wrote:

> IOCTL call for /smack/load that takes access rule in
> the same format as they are written into /smack/load.
> Sets errno to zero if access is allowed and to EACCES
> if not.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
> ---
>  include/linux/smack.h    |   29 ++++++++
>  security/smack/smack.h   |    1 +
>  security/smack/smackfs.c |  173 +++++++++++++++++++++++++++++-----------------
>  3 files changed, 140 insertions(+), 63 deletions(-)
>  create mode 100644 include/linux/smack.h
> 
> diff --git a/include/linux/smack.h b/include/linux/smack.h
> new file mode 100644
> index 0000000..c574713
> --- /dev/null
> +++ b/include/linux/smack.h
> @@ -0,0 +1,29 @@
> +/*
> + * Copyright (c) 2011, Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU Lesser General Public License
> + * as published by the Free Software Foundation; either version 2.1
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU Lesser General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
> + *
> + * Author:
> + *      Jarkko Sakkinen <jarkko.sakkinen@intel.com>
> + *
> + */
> +
> +#ifndef _SMACK_H
> +#define _SMACK_H
> +
> +#define SMACK_IOC_BASE 'S'
> +#define SMACK_IOC_LOAD_ACCESS _IOR(SMACK_IOC_BASE, 0, const char *)
> +
> +#endif /* _SMACK_H */

Please add this 'S' to Documentation/ioctl/ioctl-number.txt.
Thanks.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
