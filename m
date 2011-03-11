Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab1CKNkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 08:40:35 -0500
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:46921 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab1CKNke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 08:40:34 -0500
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Mar 2011 08:40:32 EST
Message-ID: <4D7A24CF.9070805@eukrea.com>
Date: Fri, 11 Mar 2011 14:34:07 +0100
From: =?UTF-8?B?RXJpYyBCw6luYXJk?= <eric@eukrea.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: =?UTF-8?B?TcOhcmlvIElzaWRvcm8=?= <marioisidoro@gmail.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH n_gsm] GSM Mux in non-transparent mode
References: <1299724790.1800.135.camel@Paio>
In-Reply-To: <1299724790.1800.135.camel@Paio>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mário,

On 10/03/2011 03:39, Mário Isidoro wrote:
> @@ -2661,9 +2725,12 @@ static int gsmtty_tiocmset(struct tty_struct
> *tty, struct file *filp,
>   	struct gsm_dlci *dlci = tty->driver_data;
>   	unsigned int modem_tx = dlci->modem_tx;
>
> -	modem_tx &= clear;
> +	modem_tx &= ~clear;
>   	modem_tx |= set;
>
good catch : this fix (and only this one in your patch) makes Telit modems 
work realiable here with ppp (which was failing before).
Tested on GC864-QUAD-V2, UC864-E and UC864-WD

Thanks !

Eric
