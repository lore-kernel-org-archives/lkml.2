Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab1ALFuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 00:50:10 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51150 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab1ALFuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 00:50:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HHulSV8wYF50mYlVUGnDOu7TvzON+evwYr8QnqnvKmi6uvDc0Gmkz8xGkQnfP0/W1+
         UBVvMCxpboMe4TPEzU1zR74ewG9ZcfUZ0lL1rpIAMP1SfdQIULTX4gPxGwsZl3ctnJ7D
         2NU/RO5pDwcNoYjs1dvR68XuZwbdeRHi0eEak=
Date: Tue, 11 Jan 2011 21:50:02 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Fabien Marteau <fabien.marteau@armadeus.com>
Cc: Scott Moreau <oreaus@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: joystick:   Adding Austria Microsystem AS5011
 joystick driver (fourth version)
Message-ID: <20110112055002.GB22944@core.coreip.homeip.net>
References: <4D27735C.6000105@armadeus.com>
 <20110108093040.GA8671@core.coreip.homeip.net>
 <4D2ACA17.5060708@armadeus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2ACA17.5060708@armadeus.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 09:57:59AM +0100, Fabien Marteau wrote:
> Hi Dmitry,
> 
> Thanks for the patch, I tested it on my platform and there is a little bug in irq request for the button :
> 
> +	error = request_threaded_irq(as5011->button_irq,
> +				     NULL, as5011_button_interrupt,
> +				     IRQF_TRIGGER_RISING | IRQF_TRIGGER_RISING,
> +				     "as5011_button", as5011);
> 
> Should be :
> 
> +	error = request_threaded_irq(as5011->button_irq,
> +				     NULL, as5011_button_interrupt,
> +				     IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
> +				     "as5011_button", as5011);
> 
> With this modification the patch is ok.
> 

Great, I applied it.

Thanks.

-- 
Dmitry
