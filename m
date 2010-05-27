Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240Ab0E0Qun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:50:43 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:51720 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755034Ab0E0Qul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:50:41 -0400
Message-ID: <4BFEA2DF.8080006@msgid.tls.msk.ru>
Date: Thu, 27 May 2010 20:50:39 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Bastian Blank <waldi@debian.org>, xen-devel@lists.xensource.com,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix name of Xen event-channel device
References: <20100526105144.GA28280@wavehammer.waldi.eu.org> <20100527073512.GA17135@wavehammer.waldi.eu.org> <20100527143104.GB6040@wavehammer.waldi.eu.org> <20100527150251.GD6040@wavehammer.waldi.eu.org>
In-Reply-To: <20100527150251.GD6040@wavehammer.waldi.eu.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bastian Blank wrote:
> The Xen event-channel device is named evtchn in the kernel but always
> used as /dev/xen/evtchn in userspace. This patch fixes the name.
> 
> Signed-off-by: Bastian Blank <waldi@debian.org>
> 
> diff --git a/drivers/xen/evtchn.c b/drivers/xen/evtchn.c
> index 66e185c..89cd743 100644
> --- a/drivers/xen/evtchn.c
> +++ b/drivers/xen/evtchn.c
> @@ -471,7 +471,7 @@ static const struct file_operations evtchn_fops = {
>  
>  static struct miscdevice evtchn_miscdev = {
>  	.minor        = MISC_DYNAMIC_MINOR,
> -	.name         = "evtchn",
> +	.name         = "xen/evtchn",

Um.  Will existing userspace - esp. udev rules - continue
to work after this change?  Also, how about other xen-related
devices which are moved to /dev/xen in that same udev rules?

Thanks!

/mjt
