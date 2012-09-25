Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab2IYGhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 02:37:55 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:16590 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab2IYGhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 02:37:54 -0400
Date: Tue, 25 Sep 2012 09:37:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Gorskin Ilya <revent82@gmail.com>
Cc: gregkh@linuxfoundation.org, klmckinney1@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Staging:bcm: fix coding style error in InterfaceIsr.c
Message-ID: <20120925063744.GP4587@mwanda>
References: <1348549469-7222-1-git-send-email-revent82@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348549469-7222-1-git-send-email-revent82@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 11:04:28AM +0600, Gorskin Ilya wrote:
> -	if(((Adapter->bPreparingForLowPowerMode == TRUE) && (Adapter->bDoSuspend == TRUE)) ||
> -		psIntfAdapter->bSuspended ||
> -		psIntfAdapter->bPreparingForBusSuspend)
> -	{
> -			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, INTF_INIT, DBG_LVL_ALL,"Interrupt call back is called while suspending the device");
> +	if (((Adapter->bPreparingForLowPowerMode == TRUE) &&
> +				(Adapter->bDoSuspend == TRUE)) ||
> +				psIntfAdapter->bSuspended ||
> +				psIntfAdapter->bPreparingForBusSuspend) {
> +			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, INTF_INIT,
> +					DBG_LVL_ALL,
> +					"Interrupt call back is called
> +					while suspending the device");
>  			return ;

Hi,

Thanks for doing this, these changes are welcome.  However, they
should be done slightly differently.

Take one type of checkpatch warning at a time and fix that one over
the file, then do a separate patch for the next type of warning.
[patch 1/2] Staging: bcm: move curly braces in InterfaceIsr.c
[patch 2/2] Staging: bcm: clean up conditions in InterfaceIsr.c

Something like that.

Also the way you've indented the condition is not right.  The
conditions which are && together should line up like this:

	if (((Adapter->bPreparingForLowPowerMode == TRUE) &&
	     (Adapter->bDoSuspend == TRUE)) ||
	    psIntfAdapter->bSuspended ||
	    psIntfAdapter->bPreparingForBusSuspend) {

Also the condition has too many parenthesis.  Everyone knows how the
precedence works in:
	if (foo == 3 || bar == 4) {
We don't need to specify:
	if ((foo == 3) || (bar == 4)) {

Putting extra parenthesis make the code harder to read and has lead
to == vs = bugs which would have been caught by gcc:
warning: suggest parentheses around assignment used as truth value [-Wparentheses]

Also can we just leave off the "== TRUE", or is this a case where it
can "== TRUE", "== FALSE", and "== FILENOTFOUND"?

Finally, this is not quoted correctly.
> +                                     "Interrupt call back is called
> +                                     while suspending the device");
Don't break those string literals up across multiple lines, but if
you do then you need to add quotes.
					"Interrupt call back is called"
					                              ^
					"while suspending the device");
					^

regards,
dan carpenter


