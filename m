Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238Ab0GBRK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 13:10:27 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:55780 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756352Ab0GBRK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 13:10:26 -0400
From: Dmitry Torokhov <dtor@mail.ru>
To: feng.tang@intel.com
Subject: Re: [PATCH 5/5] input: i8042 - add runtime check in x86's i8042_platform_init
Date: Fri, 2 Jul 2010 09:59:23 -0700
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       hpa@zytor.com, jacob.jun.pan@intel.com, randy.dunlap@oracle.com
References: <1278059716-7147-1-git-send-email-feng.tang@intel.com> <1278059716-7147-6-git-send-email-feng.tang@intel.com>
In-Reply-To: <1278059716-7147-6-git-send-email-feng.tang@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201007020959.24889.dtor@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Feng,

On Friday, July 02, 2010 01:35:16 am feng.tang@intel.com wrote:
> From: Feng Tang <feng.tang@intel.com>
> 
> Then it will first check x86_platforms's i8042 detection result,
> then go on with normal probe.
> 
> Cc: Dmitry Torokhov <dtor@mail.ru>
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
>  drivers/input/serio/i8042-x86ia64io.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/serio/i8042-x86ia64io.h
> b/drivers/input/serio/i8042-x86ia64io.h index 6168469..2e14fc5 100644
> --- a/drivers/input/serio/i8042-x86ia64io.h
> +++ b/drivers/input/serio/i8042-x86ia64io.h
> @@ -840,6 +840,10 @@ static int __init i8042_platform_init(void)
>  {
>  	int retval;
> 
> +	/* Just return if pre-detection shows no i8042 controller exist */
> +	if (!x86_platform.i8042_detect())
> +		return -ENODEV;
> +

I think this needs to be protected with "#ifdef CONFIG_X86" as the file is 
shared between X86 and IA64.

Thanks,

Dmitry
