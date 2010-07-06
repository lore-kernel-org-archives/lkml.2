Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab0GFH4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 03:56:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44166 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab0GFH4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 03:56:49 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH] hp-wmi: add return value checking for input_allocate_device()
Date: Tue, 6 Jul 2010 09:56:45 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Anisse Astier <anisse@astier.eu>,
       platform-driver-x86@vger.kernel.org
References: <1278383426.12801.15.camel@mola>
In-Reply-To: <1278383426.12801.15.camel@mola>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201007060956.45726.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

it's incredible how much cleanups and fixes you find in this
handful of drivers... It's very much appreciated!

On Tuesday 06 July 2010 04:30:26 Axel Lin wrote:
> Add error checking and return -ENOMEM if input_allocate_device() fail.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/platform/x86/hp-wmi.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
> index 51c07a0..c508e20 100644
> --- a/drivers/platform/x86/hp-wmi.c
> +++ b/drivers/platform/x86/hp-wmi.c
> @@ -402,6 +402,8 @@ static int __init hp_wmi_input_setup(void)
>  	int err;
>  
>  	hp_wmi_input_dev = input_allocate_device();
> +	if (!hp_wmi_input_dev)
> +		return -ENOMEM;
>  
>  	hp_wmi_input_dev->name = "HP WMI hotkeys";
>  	hp_wmi_input_dev->phys = "wmi/input0";
But also hp_wmi_input_setup() call should get checked and if it
fails, the previous wmi_install_notify_handler() must get uninstalled
again. Hm, probably the whole driver shouldn't load then and
the error code from hp_wmi_input_setup() can be returned in
hp_wmi_init(void).

Do you mind to incorporate above if you agree.

Thanks,

   Thomas
