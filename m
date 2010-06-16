Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585Ab0FPSeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 14:34:15 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41460 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125Ab0FPSeN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 14:34:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=YO3G8hVwmrWY5La6tU3ZVOJENxEX6blnxyZ2wKzTrSdm3i5GdZnQM8AVrEz475A4cr
         0MtygYUE5l8gBhvC+E3z1PmzkoCaQ+1To7wXeULtNvWDHm4hvjABMqzDCyhNuBnalR9t
         1PfnJRUwRZhC1qYv0m2Wr57JNlRsKXApevdB8=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [REGRESSION] [IWL3945] Broadcast is broken?
Date: Wed, 16 Jun 2010 20:34:06 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3; KDE/4.4.4; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, reinette.chatre@intel.com,
       wey-yi.w.guy@intel.com, ilw@linux.intel.com,
       linux-wireless@vger.kernel.org, Berg Johannes <johannes.berg@intel.com>,
       iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
References: <201006141924.24061.maciej.rutecki@gmail.com> <1276538138.7931.3.camel@maxim-laptop>
In-Reply-To: <1276538138.7931.3.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006162034.06754.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On poniedziałek, 14 czerwca 2010 o 19:55:38 Maxim Levitsky wrote:
> On Mon, 2010-06-14 at 19:24 +0200, Maciej Rutecki wrote:
> > Hardware:
> > 08:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG
> > [Golan] Network Connection (rev 02)
> > 
> > Last known good kernel: 2.6.34
> > 
> > Failing kernels: since 2.6.35-rc1 to 2.6.35-rc3
> > 
> > Symptoms:
> > During connect do wireless network authentication seems be OK, but I
> > cannot get IP from dhcp serwer. I do:
> > echo 0x43fff > /sys/class/net/wlan0/device/debug_level
> > 
> > Syslog is here:
> > http://unixy.pl/maciek/download/kernel/2.6.35-rc3/gumis/syslog-before.txt
> > 
> > From syslog I guess the problem is that it doesn't receive broadcast
> > frames (but I'm not sure), so I try:
> > sudo ifconfig wlan0 promisc
> > 
> > Syslog:
> > http://unixy.pl/maciek/download/kernel/2.6.35-rc3/gumis/syslog-after.txt
> > 
> > And then I can get IP address.
> > 
> > Any advice?
> 
> Very likely commit 3474ad635db371b0d8d0ee40086f15d223d5b6a4,
> because I have same problem.
> 
> Try to revert it.

Thanks for information; revert this commit solves problem.

> 
> Best regards,
> Maxim Levitsky

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
