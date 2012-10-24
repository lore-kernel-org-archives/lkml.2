Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934692Ab2JXLAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 07:00:39 -0400
Received: from canardo.mork.no ([148.122.252.1]:51939 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934674Ab2JXLAi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 07:00:38 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Cc: linux-kernel@vger.kernel.org, linux@sierrawireless.com
Subject: Re: Fix memory leak in sierra_release()
Organization: m
References: <20121023200333.GN18610@csclub.uwaterloo.ca>
Date: Wed, 24 Oct 2012 13:00:21 +0200
In-Reply-To: <20121023200333.GN18610@csclub.uwaterloo.ca> (Lennart Sorensen's
	message of "Tue, 23 Oct 2012 16:03:33 -0400")
Message-ID: <87r4oof83e.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Lennart Sorensen" <lsorense@csclub.uwaterloo.ca> writes:

> I found a memory leak in sierra_release() (well sierra_probe() I guess)
> that looses 8 bytes each time the driver releases a device.
>
> Here is the patch to fix it.
>
> diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
> index 01d882c..76ef95b 100644
> --- a/drivers/usb/serial/sierra.c
> +++ b/drivers/usb/serial/sierra.c
> @@ -959,6 +959,7 @@ static void sierra_release(struct usb_serial *serial)
>  			continue;
>  		kfree(portdata);
>  	}
> +	kfree(serial->private);
>  }
>  
>  #ifdef CONFIG_PM

Looks sensible to me, but needs a signed-off-by and CC to linux-usb.


Bjørn
