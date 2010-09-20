Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab0ITTnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:43:47 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:53136 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270Ab0ITTnp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:43:45 -0400
In-Reply-To: <1283005748-3293-2-git-send-email-rydberg@euromail.se>
References: <1283005748-3293-1-git-send-email-rydberg@euromail.se> <1283005748-3293-2-git-send-email-rydberg@euromail.se>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=ISO-8859-1; delsp=yes; format=flowed
Message-Id: <FF722ED6-6568-47D0-82D1-99B9E9D5AEAF@enac.fr>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
From: =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
Subject: Re: [PATCH 2/3] hid: 3m: Convert to MT slots
Date: Mon, 20 Sep 2010 21:43:37 +0200
To: Henrik Rydberg <rydberg@euromail.se>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 28 août 10 à 16:29, Henrik Rydberg a écrit :

> The Microtouch controller is capable of doing finger tracking on
> up to 60 fingers. To reduce bandwidth and cpu usage, convert the
> driver to use the MT slots protocol.

As I understand it, this patch actually has three roles:
  1. improving the evdev parameters of the device
  2. cleaning the protocol to get rid of useless MISC/SCANCODE messages
  3. convert the protocol to MT slots


> +#define SN_MOVE			2048
> +#define SN_WIDTH		128
>

In the long run, it might be useful to comment these signal/noise  
constants



>  			hid_map_usage(hi, usage, bit, max, EV_KEY, BTN_TOUCH);
> +			input_set_capability(hi->input, EV_KEY, BTN_TOUCH);

>  {
> +	/* tell hid-input to skip setup of these event types */
>  	if (usage->type == EV_KEY || usage->type == EV_ABS)
> -		clear_bit(usage->code, *bit);
> -
> -	return 0;
> +		set_bit(usage->type, hi->input->evbit);
> +	return -1;
>  }
>

I understand this as a trick to get rid of MISC/SCANCODEs that are  
added for every EV_KEY message, consequence of a rule in hid-input.c.  
Wouldn't it be simpler to improve the rule than to work around it?

Cheers,

St.

