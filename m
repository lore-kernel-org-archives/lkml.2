Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab1DURXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 13:23:48 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4704 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104Ab1DURXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 13:23:47 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Subject: Re: [PATCH] tg3: Convert u32 flag,flg2,flg3 uses to bitmap
From: "Michael Chan" <mchan@broadcom.com>
To: "Joe Perches" <joe@perches.com>
cc: "Matthew Carlson" <mcarlson@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <02bf2aa5c08514641ecbe7c39ef976918fad036c.1303367730.git.joe@perches.com>
References: <1303322263-18991-10-git-send-email-mcarlson@broadcom.com>
 <02bf2aa5c08514641ecbe7c39ef976918fad036c.1303367730.git.joe@perches.com>
Date: Thu, 21 Apr 2011 10:18:00 -0700
Message-ID: <1303406280.8857.13.camel@HP1>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5)
X-WSS-ID: 61AEB76C3GO6437994-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2011-04-20 at 23:39 -0700, Joe Perches wrote:
> @@ -4622,7 +4611,7 @@ static void tg3_tx_recover(struct tg3 *tp)
>                     "and include system chipset information.\n");
> 
>         spin_lock(&tp->lock);
> -       tp->tg3_flags |= TG3_FLAG_TX_RECOVERY_PENDING;
> +       tg3_flag_set(tp, TX_RECOVERY_PENDING);
>         spin_unlock(&tp->lock);
>  }
> 

By using set_bit() now, we can eliminate the spin_lock() here.  This
flag is checked much later when tg3_reset_task() is scheduled to run in
workqueue, so no memory barrier is needed either.

Thanks.


