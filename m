Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab2CIXhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 18:37:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41502 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab2CIXhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 18:37:04 -0500
Date: Fri, 9 Mar 2012 15:36:59 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] firmware loader: don't cancel _nowait requests when
 helper is not yet available
Message-ID: <20120309233659.GA21256@kroah.com>
References: <201203032122.36745.chunkeey@googlemail.com>
 <4F551E46.7000100@linux.vnet.ibm.com>
 <201203092330.24438.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203092330.24438.chunkeey@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 11:30:24PM +0100, Christian Lamparter wrote:
> This patch fixes a regression which was introduced by:
> "PM: Print a warning if firmware is requested when tasks are frozen"
> 
> request_firmware_nowait does not stall in any system resume paths.
> Therefore, I think it is perfectly save to use request_firmware_nowait
> from at least the ->complete() callback.

Is there code somewhere in the kernel that wants to do this?  Has commit
a144c6a broken it somehow that this fix would resolve it?

> 
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
>  drivers/base/firmware_class.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 6c9387d..017e020 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -535,7 +535,7 @@ static int _request_firmware(const struct firmware **firmware_p,
>  
>  	read_lock_usermodehelper();
>  
> -	if (WARN_ON(usermodehelper_is_disabled())) {
> +	if (WARN_ON(usermodehelper_is_disabled() && !(nowait && uevent))) {

What does uevent have to do with things here?

greg k-h
