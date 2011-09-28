Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab1I1OTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 10:19:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58590 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab1I1OTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 10:19:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH v3 21/24] C6X: general SoC support
Date: Wed, 28 Sep 2011 16:19:07 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1317155405-26235-1-git-send-email-msalter@redhat.com> <1317155405-26235-22-git-send-email-msalter@redhat.com>
In-Reply-To: <1317155405-26235-22-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281619.07213.arnd@arndb.de>
X-Provags-ID: V02:K0:DhPqitORzeg9Y4q2H4DcySFPJQFDgABB5RQkX2VmugN
 8UBDvfKn5OzVgJPsoP/gJoG/s5c8w/7mszX6iYOePbgTHuLFft
 Hf8HVsurj5UCSAfjaKmAtb7FmhXokTTjIdkQwyfKCaQz5z7rl9
 UUW5xsnlghr9Xyhza53L4GQfEQGByRMaJ+avZzqk3RWEzjPWfY
 Led+GQVv4I/BFDUYfHiDd42/0EWlWEXd9FoLh5EDBn0b/anaQL
 /OejezCn2zCq+zNh4CXJNUAELutxDY1UN+ARnqKS7pd3yuMo8Q
 GMc/uQ4AXJCoYIDruFDr7qZblOF20iCNHbKvNFJn9Yh3PXabTL
 WKuchbW+fhvR3l9c/vM8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 September 2011, Mark Salter wrote:
> +int soc_mac_addr(unsigned int index, u8 *addr)
> +{
> +       int i, have_cmdline_mac = 0, have_fuse_mac = 0;
> +
> +       for (i = 0; i < 6; i++) {
> +               if (cmdline_mac[i])
> +                       have_cmdline_mac = 1;
> +               if (c6x_fuse_mac[i])
> +                       have_fuse_mac = 1;
> +       }
> +
> +       /* cmdline overrides hardware fuse MAC */
> +       if (have_cmdline_mac)
> +               memcpy(addr, cmdline_mac, 6);
> +       else if (have_fuse_mac)
> +               memcpy(addr, c6x_fuse_mac, 6);
> +       else
> +               return 0;

IMHO it's more important to let the user override the MAC address through
the device tree than the command line, although if you allow both, the
command line should take precedence. If you think you need to keep the
command line option, please add a way to read it from the device tree
as a fallback before falling back to the fused mac address.

Also, a final fallback on random_mac_address() would be reasonable here.

Finally, how about passing a struct device pointer from the driver, rather
than the index? That would seem more logical and make it easier to get
to the device tree properties.

> +       /* adjust for specific EMAC device */
> +       addr[5] += index * c6x_num_cores;
> +       return 1;
> +}
> +EXPORT_SYMBOL(soc_mac_addr);

EXPORT_SYMBOL_GPL()

	Arnd
