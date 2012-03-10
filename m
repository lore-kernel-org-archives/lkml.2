Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208Ab2CJE2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 23:28:50 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40740 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756229Ab2CJE2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 23:28:48 -0500
X-Sasl-enc: 6DBQFGnYIo0bfnVK1XL7i6R32O4Qo+oB61kIfZGEl+R/ 1331353727
Date: Sat, 10 Mar 2012 01:28:44 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Manoj Iyer <manoj.iyer@canonical.com>
Cc: linux-kernel@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: Re: [ibm-acpi-devel] [PATCH] thinkpad-acpi: recognize Lenovo as
 version string in newer V-series BIOS
Message-ID: <20120310042844.GA14972@khazad-dum.debian.net>
References: <1331335944-4662-1-git-send-email-manoj.iyer@canonical.com>
 <1331335944-4662-2-git-send-email-manoj.iyer@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331335944-4662-2-git-send-email-manoj.iyer@canonical.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Mar 2012, Manoj Iyer wrote:
> The newer V series bios reports product version as 'Lenovo'
> instead of 'ThinkPad'. Recoginze this new string so that
> the module can load.
> 
> Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
> ---
>  drivers/platform/x86/thinkpad_acpi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
> index ea0c607..d68c000 100644
> --- a/drivers/platform/x86/thinkpad_acpi.c
> +++ b/drivers/platform/x86/thinkpad_acpi.c
> @@ -8658,7 +8658,7 @@ static int __must_check __init get_thinkpad_model_data(
>  	}
>  
>  	s = dmi_get_system_info(DMI_PRODUCT_VERSION);
> -	if (s && !strnicmp(s, "ThinkPad", 8)) {
> +	if (s && !(strnicmp(s, "ThinkPad", 8) && strnicmp(s, "Lenovo", 6))) {
>  		tp->model_str = kstrdup(s, GFP_KERNEL);
>  		if (!tp->model_str)
>  			return -ENOMEM;

So far so good, but what driver functionality works well in these new
lenovo boxes?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
