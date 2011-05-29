Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab1E2Uhb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 16:37:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64344 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab1E2Uh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 16:37:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=n4ZHVj7AhGsPGjRxVtT5hOW7RWPVQMCTMqcowMAkdd2Vw4txOZGNySEVSzL3MPNCYJ
         39JyT+LYOEJsfZt/H9k/eNsxHnyp8XTCH94VLdmqCsF2L4ri5gqZNmLY12yKtKcded+m
         WZuphf3r8KOunfOlNTo57ppPnoJ4haA4n65Y4=
Date: Sun, 29 May 2011 23:37:06 +0300
From: Dan Carpenter <error27@gmail.com>
To: "Ken O'Brien" <kernel@kenobrien.org>
Cc: gregkh@suse.de, shemminger@vyatta.com, martinez.javier@gmail.com,
        arnd@arndb.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] staging: bcm: Style cleanup of 1st 500 lines.
Message-ID: <20110529203706.GE3099@shale.localdomain>
References: <1306699685-7906-1-git-send-email-kernel@kenobrien.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306699685-7906-1-git-send-email-kernel@kenobrien.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 09:08:05PM +0100, Ken O'Brien wrote:
> Applied coding convention rules to 1st 500 lines. These lines no longer throw errors or warnings.
> Subsequent patches will fix the remaining lines.

> -	else if (_IOC_DIR(cmd) & _IOC_WRITE)
> -	    Status = !access_ok(VERIFY_READ, argp, _IOC_SIZE(cmd));
> -	else if (_IOC_NONE == (_IOC_DIR(cmd) & _IOC_NONE))
> -	    Status = STATUS_SUCCESS;
> +	else
> +		if (_IOC_DIR(cmd) & _IOC_WRITE)
> +			Status = !access_ok(VERIFY_READ, argp, _IOC_SIZE(cmd));
> +	else
> +		if (_IOC_NONE == (_IOC_DIR(cmd) & _IOC_NONE))
> +			Status = STATUS_SUCCESS;

The original code was correct, "else if" goes on one line.

> +		if (IsReqGpioIsLedInNVM(Adapter, value) == FALSE) {
> +			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
> +								DBG_LVL_ALL,
> +		"Sorry, Requested GPIO<0x%X> is not correspond to LED !!!",
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This should be indented to there.  I know it makes the line too long
but it's better to ignore checkpatch on this.  Even computer
programs like checkpatch can ignored from time to time.  There were
several other debug messages like this so it's probably worth
redoing the patch once any other review comments are in.

> +								value);
> +			Status = -EINVAL;

regards,
dan carpenter
