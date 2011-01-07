Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab1AGRTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 12:19:46 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34389 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab1AGRTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 12:19:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kyHHO3XlaPXN9fVehf8tIqmDvDRFn3KCsq20EWI/uLE2Ztxl2g0yESzb21sGhFEJ/R
         Q1xScuzFiq8ifEhiOeaQLSCBNF8IYPQhg8ktdEI/6QWI4ZyEAS3CIVhiKwivUrZKKL/T
         NpKami8VlGPmaijfv7dav4GPTEG4wwH/28DYg=
Date: Sat, 8 Jan 2011 04:19:37 +1100
From: "Trent W. Buck" <trentbuck@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: BUG: blank screen i915 (N10) LVDS in 2.6.37
Message-ID: <20110107171934.GA1299@dali>
References: <20110107085931.GA1400@dali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107085931.GA1400@dali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> When I boot 2.6.37, the onboard head remains blank.
> It works in 2.6.36.  In both cases, the VGA head works fine.
> [...]
> IIRC I also changed from eeepc_laptop on .36 to eeepc_wmi .37 (with
> the associated change to the boot parameter in .config); dunno if
> that matters.

Apparently it does: going back to eeepc_laptop fixes the issue.

    --- .config.old	2011-01-08 04:16:20.752701984 +1100
    +++ .config	2011-01-08 03:51:03.000000000 +1100
    @@ -4 +4 @@
    -# Wed Jan  5 22:13:38 2011
    +# Sat Jan  8 03:47:32 2011
    @@ -353 +353 @@
    -CONFIG_CMDLINE="root=/dev/sda2 ro quiet"
    +CONFIG_CMDLINE="root=/dev/sda2 acpi_osi=Linux ro quiet"
    @@ -1775 +1774,0 @@
    -# CONFIG_LEDS_DELL_NETBOOKS is not set
    @@ -1936 +1934,0 @@
    -# CONFIG_DELL_WMI is not set
    @@ -1938 +1935,0 @@
    -# CONFIG_HP_WMI is not set
    @@ -1947,4 +1944,2 @@
    -# CONFIG_EEEPC_LAPTOP is not set
    -CONFIG_EEEPC_WMI=y
    -CONFIG_ACPI_WMI=y
    -# CONFIG_MSI_WMI is not set
    +CONFIG_EEEPC_LAPTOP=m
    +# CONFIG_ACPI_WMI is not set
