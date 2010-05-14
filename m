Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab0ENR3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 13:29:40 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46883 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201Ab0ENR3i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 13:29:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=bWnNfVz3QkZ4ORrUNn75hCGvq40aw7sXPVBqEYODybSctELS94QRHBvEUV8rC5wGni
         jd9f4gsUr6PEazP6UceSCBrPSXVv8KwR/UJ3qzZi+s+HolnhzoL/YBF8USuKyGsCzxvI
         J6MqHGniJfBnigSTzKH/fpOkP2MmbUWFj3sHI=
MIME-Version: 1.0
In-Reply-To: <4BED8765.8040307@gmail.com>
References: <4BEC7A84.3010503@gmail.com> <201005141520.30802.br1@einfach.org> 
	<4BECEE3E.6090303@gmail.com> <201005141538.43416.br1@einfach.org> 
	<4BED6F19.3040608@gmail.com> <20100514165325.GA28198@tux> 
	<4BED8765.8040307@gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 14 May 2010 10:29:17 -0700
X-Google-Sender-Auth: BIKejgKHmvuEJRZj4e_tdGixk28
Message-ID: <AANLkTiky103uOz38yZPlLypEQ8DnkdCk1X3zPl9014Yi@mail.gmail.com>
Subject: Re: ath9k: BUG kmalloc-8192: Poison overwritten
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Bruno Randolf <br1@einfach.org>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 10:24 AM, Justin P. Mattock
<justinmattock@gmail.com> wrote:

>
> here you go:
> (I was grabbing the info
> after rmmod and modprobe)
>
> [    7.034242] ATH9K: cachelsz: 256
> [   69.175348] ATH9K: cachelsz: 256

Close, so I without any patches applied, and by just running modprobe as below:


modprobe ath9k debug=0x00000200

               ath_print(common, ATH_DBG_CONFIG, "cachelsz %u rxbufsize %u\n",
                               common->cachelsz, common->rx_bufsize);


This is already in the code so just please do this:

rmmod ath9k
modprobe ath9k debug=0x00000200
dmesg | grep cachelsz
