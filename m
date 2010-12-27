Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab0L0WMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 17:12:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab0L0WMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 17:12:22 -0500
Date: Mon, 27 Dec 2010 15:12:37 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Tsozik <tsozik@yahoo.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, zaitcev@redhat.com
Subject: Re: [PATCH 1/1] mct_u232: added _ioctl, _msr_to_icount and
 _get_icount functions
Message-ID: <20101227151237.744bbb6e@lembas.zaitcev.lan>
In-Reply-To: <87086.58416.qm@web65703.mail.ac4.yahoo.com>
References: <87086.58416.qm@web65703.mail.ac4.yahoo.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Dec 2010 12:55:38 -0800 (PST)
Tsozik <tsozik@yahoo.com> wrote:

> +static void mct_u232_msr_to_icount(struct async_icount *icount,
> +						unsigned char msr)
> +{
> +	/* Translate Control Line states */
> +	if (msr & MCT_U232_MSR_DDSR)
> +		icount->dsr++;
> +	if (msr & MCT_U232_MSR_DCTS)
> +		icount->cts++;
> +	if (msr & MCT_U232_MSR_DRI)
> +		icount->rng++;
> +	if (msr & MCT_U232_MSR_DCD)
> +		icount->dcd++;
> +} /* mct_u232_msr_to_icount */

This looks good to me, but since it's a new hardware facility that
we did not use previously, I'd like to make sure this works for you.

> mct_u232_msr_to_icount uses delta nibble to track state changes.
> RM-60 testing showed the same levels as measured by PDM-2 in close
> proximity to RM-60.

Right, this is good. I have just one request for you: could you find
somewhere a computer with a built-in 8250-compatible serial port,
attach RM-60 to it, and run your counting application there?
I think your patch looks just fine, but I would like to make sure
that we (e.g. mct_u232+patch) are truly compatible now.

-- Pete
