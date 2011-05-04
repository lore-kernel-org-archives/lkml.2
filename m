Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab1EDSog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:44:36 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:14096 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab1EDSof convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:44:35 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-132.messagelabs.com!1304534660!24539271!20
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.31]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>
Date: Wed, 4 May 2011 13:44:27 -0500
Subject: RE: [PATCH 1/1] Staging: hv: Add the necessary dependencies to
 hyperv	Kconfig
Thread-Topic: [PATCH 1/1] Staging: hv: Add the necessary dependencies to
 hyperv	Kconfig
Thread-Index: AcwKipXFTabauT75RfynfuAp7mMIZgAADz9Q
Message-ID: <0D753D10438DA54287A00B027084269764D295CE91@AUSP01VMBX24.collaborationhost.net>
References: <1304535105-26892-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1304535105-26892-1-git-send-email-kys@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 04, 2011 11:52 AM, K. Y. Srinivasan wrote:
>
> The vmbus driver dependes on ACPI and PCI subsystems. Change 
> Kconfig to reflect this.
>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/staging/hv/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/staging/hv/Kconfig b/drivers/staging/hv/Kconfig
> index 76f0756..5e0c9f6 100644
> --- a/drivers/staging/hv/Kconfig
> +++ b/drivers/staging/hv/Kconfig
> @@ -1,6 +1,6 @@
>  config HYPERV
>  	tristate "Microsoft Hyper-V client drivers"
> -	depends on X86 && m
> +	depends on X86 && ACPI && PCI && m
>  	default n
>  	help
> 	  Select this option to run Linux as a Hyper-V client operating

ACPI itself depends on PCI.  It also depends on IA64 || X86.  Will the
vmbus driver work with IA64?  If so the depends on could just be:

	depends on ACPI && m

Also, default n is redudant since n is the default anyway.

Regards,
Hartley
