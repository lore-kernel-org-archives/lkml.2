Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab2FJOtE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 10:49:04 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42657 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751392Ab2FJOtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 10:49:02 -0400
X-Sasl-enc: +OxMzDGGyhRtySz29RTJs2R7YHFeE5M/jwnL3A1Sb4IC 1339339740
Date: Sun, 10 Jun 2012 11:48:58 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Vsevolod Kozlov <zaba@wybt.net>
Cc: linux-kernel@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net
Subject: Re: thinkpad_acpi: Saving bluetooth state to NVRAM problem and fix
Message-ID: <20120610144858.GB11169@khazad-dum.debian.net>
References: <20120610091840.GA4960@scharfenberg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120610091840.GA4960@scharfenberg>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jun 2012, Vsevolod Kozlov wrote:
> thinkpad_acpi normally fails to save Bluetooth state to NVRAM on my system
> (ThinkPad X120e).  However, a small change in the code fixes the functionality:
> 
> --- a/drivers/platform/x86/thinkpad_acpi.c
> +++ b/drivers/platform/x86/thinkpad_acpi.c
> @@ -3999,7 +3999,7 @@ static const struct tpacpi_rfk_ops bluetooth_tprfk_ops = {
>  static void bluetooth_shutdown(void)
>  {
>  	/* Order firmware to save current state to NVRAM */
> -	if (!acpi_evalf(NULL, NULL, "\\BLTH", "vd",
> +	if (!acpi_evalf(NULL, NULL, "\\_SB.BLTH", "vd",
>  			TP_ACPI_BLTH_SAVE_STATE))
>  		pr_notice("failed to save bluetooth state to NVRAM\n");
>  	else
> 
> I can't tell whether this breaks the functionality on other ThinkPad systems
> because I don't have any, though.

Yes, it would break other systems.  But I can write a fix that supports both
systems with the data you supplied.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
