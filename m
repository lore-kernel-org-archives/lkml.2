Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab1C3Jkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:40:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51655
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754804Ab1C3Jkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:40:42 -0400
Date: Wed, 30 Mar 2011 02:40:04 -0700 (PDT)
Message-Id: <20110330.024004.45902973.davem@davemloft.net>
To: simon@mungewell.org
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, david-b@pacbell.net
Subject: Re: [PATCH] pl25a1_support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1301456667-1648-1-git-send-email-simon@mungewell.org>
References: <1301456667-1648-1-git-send-email-simon@mungewell.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Wood <simon@mungewell.org>
Date: Tue, 29 Mar 2011 21:44:27 -0600

> @@ -89,13 +97,17 @@ static int pl_reset(struct usbnet *dev)
>  	/* some units seem to need this reset, others reject it utterly.
>  	 * FIXME be more like "naplink" or windows drivers.
>  	 */
> -	(void) pl_set_QuickLink_features(dev,
> +	int     status;
> +
> +        status = pl_set_QuickLink_features(dev,
>  		PL_S_EN|PL_RESET_OUT|PL_RESET_IN|PL_PEER_E);

Poor indentation here in the status assignment, there should be
only a single TAB character before "status =".

Also, declare the local variable at the beginning of the function,
before the function, not after it.  And get rid of that tab between
"int" and "status, like this:

	int status;

	/* some units seem to need this reset, others reject it utterly.
	 * FIXME be more like "naplink" or windows drivers.
	 */
