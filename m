Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab1HJGLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 02:11:35 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54843 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab1HJGLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 02:11:33 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6433"; a="109254746"
X-IronPort-AV: E=Sophos;i="4.67,347,1309762800"; 
   d="scan'208";a="112899769"
Message-ID: <4E42210E.70202@qca.qualcomm.com>
Date: Wed, 10 Aug 2011 09:11:26 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "John W. Linville" <linville@tuxdriver.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Raja Mani <rmani@qca.qualcomm.com>,
        Vivek Natarajan <nataraja@qca.qualcomm.com>,
        Suraj Sumangala <surajs@qca.qualcomm.com>,
        Joe Perches <joe@perches.com>, Jouni Malinen <jouni@qca.qualcomm.com>
Subject: Re: linux-next: build failure after merge of the final tree (wireless
 tree related)
References: <20110810122109.a81b3186e4131aba82a4cae0@canb.auug.org.au>
In-Reply-To: <20110810122109.a81b3186e4131aba82a4cae0@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.234.11.48]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 08/10/2011 05:21 AM, Stephen Rothwell wrote:
> After merging the final tree, today's linux-next build (powerpc allyesconfig)
> failed like this:
> 
> drivers/net/wireless/ath/ath6kl/built-in.o: In function `htc_start':
> (.opd+0x600): multiple definition of `htc_start'
> drivers/net/wireless/ath/ath9k/built-in.o:(.opd+0x3e40): first defined here
> drivers/net/wireless/ath/ath6kl/built-in.o: In function `.htc_stop':
> (.text+0x7b40): multiple definition of `.htc_stop'
> drivers/net/wireless/ath/ath9k/built-in.o:(.text+0x67b34): first defined here
> drivers/net/wireless/ath/ath6kl/built-in.o: In function `.htc_start':
> (.text+0x7d18): multiple definition of `.htc_start'
> drivers/net/wireless/ath/ath9k/built-in.o:(.text+0x67ba0): first defined here
> drivers/net/wireless/ath/ath6kl/built-in.o: In function `htc_stop':
> (.opd+0x5e8): multiple definition of `htc_stop'
> drivers/net/wireless/ath/ath9k/built-in.o:(.opd+0x3e28): first defined here
> 
> Probably caused by commit bdcd81707973 ("Add ath6kl cleaned up driver").
> 
> I have reverted commit 392e741939dd ("Merge branch 'ath6kl-next' of
> master.kernel.org:/pub/scm/linux/kernel/git/kvalo/ath6kl") for today.

Sorry about that! I'll send a fix right away.

> John, this has happened a couple of times before where people have just
> copied an existing driver that happens to have some badly named global
> variables.  :-(

I was working on adding ath6kl prefix too all global ath6kl symbols but
I haven't been able to finish that yet.

Kalle
