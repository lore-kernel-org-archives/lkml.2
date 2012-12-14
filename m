Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab2LNLzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 06:55:40 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:32808 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab2LNLzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 06:55:39 -0500
Message-ID: <50CB13B5.6090203@openvz.org>
Date: Fri, 14 Dec 2012 15:55:33 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121123 Firefox/10.0.11 Iceape/2.7.11
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, Denis Kirjanov <kirjanov@gmail.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 12/12] edac: fix kernel panic on module unloading
References: <20121214110229.11019.63713.stgit@zurg> <20121214110310.11019.21098.stgit@zurg> <20121214112657.6c1b74e9@pyramind.ukuu.org.uk>
In-Reply-To: <20121214112657.6c1b74e9@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Fri, 14 Dec 2012 15:03:10 +0400
> Konstantin Khlebnikov<khlebnikov@openvz.org>  wrote:
>
>> This patch fixes use-after-free and double-free bugs in edac_mc_sysfs_exit().
>> mci_pdev has single reference and put_device() calls mc_attr_release() which
>> calls kfree(), thus following device_del() works with already released memory.
>> An another kfree() in edac_mc_sysfs_exit() releses the same memory again. Great.
>
> Patches for this were posted a while ago by Jean Delvare. See bugzilla
> 50491 as well for this.
>

Seems like this is different bugs, that was in "i7core_edac", this one in "edac_core"

