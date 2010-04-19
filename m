Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab0DSV2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 17:28:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018Ab0DSV2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 17:28:07 -0400
Date: Mon, 19 Apr 2010 14:28:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Justin Mattock <justinmattock@gmail.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: MacBookPro2,2 unable too boot with the latest HEAD
Message-Id: <20100419142804.3cd53666.akpm@linux-foundation.org>
In-Reply-To: <i2vdd18b0c31004140812i6a0e9430u68ab49b24273fe9b@mail.gmail.com>
References: <i2vdd18b0c31004140812i6a0e9430u68ab49b24273fe9b@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Apr 2010 08:12:57 -0700
Justin Mattock <justinmattock@gmail.com> wrote:

> Just noticed this this morning,
> system can only boot up when I take the battery
> out.(when the battery is plugged in this(below)
> shows up, and if booting no go)
> 
> [  169.207193] divide error: 0000 [#1] SMP
> [  169.207203] last sysfs file: /sys/devices/platform/applesmc.768/light
> [  169.207208] CPU 0
> [  169.207212] Modules linked in: rfcomm sco radeon bnep l2cap ttm
> drm_kms_helper drm ipt_LOG iptable_nat nf_nat xt_state
> nf_conntrack_ftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4
> iptable_filter ip_tables x_tables btusb bluetooth firewire_ohci ath9k
> firewire_core ath9k_common video battery ac ath9k_hw evdev joydev
> ohci1394 ath button thermal sky2 i2c_i801 raw1394 ieee1394 uhci_hcd
> ehci_hcd coretemp acpi_cpufreq processor appletouch applesmc uvcvideo
> [  169.207303]
> [  169.207310] Pid: 182, comm: kacpi_notify Not tainted
> 2.6.34-rc3-00502-gd3b0936 #42 Mac-F42187C8/MacBookPro2,2
> [  169.207316] RIP: 0010:[<ffffffff81237e43>]  [<ffffffff81237e43>]
> acpi_ex_extract_from_field+0xb1/0x24a

Presumably acpi_ex_extract_from_field() fed zero into (the misnamed)
ACPI_ROUND_UP_TO().

I'll ask Rafael and Maciej to track this as a post-26.33 regression,
thanks.

