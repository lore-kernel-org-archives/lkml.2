Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab2EYO2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 10:28:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab2EYO2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 10:28:04 -0400
Date: Fri, 25 May 2012 10:27:56 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Lan Tianyu <tianyu.lan@intel.com>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        lantianyu1986@gmail.com
Subject: Re: USB device PM oddity in 3.5
Message-ID: <20120525142756.GD23824@zod.bos.redhat.com>
References: <20120524203655.GK1143@zod.bos.redhat.com>
 <Pine.LNX.4.44L0.1205241646080.1186-100000@iolanthe.rowland.org>
 <20120525113936.GA23824@zod.bos.redhat.com>
 <4FBF826B.1040101@intel.com>
 <20120525130826.GA13258@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120525130826.GA13258@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 02:08:26PM +0100, Matthew Garrett wrote:
> udev is being a little too aggressive in enabling autosuspend. I've just 
> sent a patch upstream, but here it is:

Aside from the small buglet in the rule below, this seems to solve the
issue.  I've booted Linus' tree as of this morning with a fixed udev and
initramfs and the keyboard and mouse are working well now.
> diff --git a/rules/42-usb-hid-pm.rules b/rules/42-usb-hid-pm.rules
> index d5d5897..fc44b94 100644
> --- a/rules/42-usb-hid-pm.rules
> +++ b/rules/42-usb-hid-pm.rules
> @@ -46,4 +46,10 @@ ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="04b3", ATTR{idProduct}=="4012
>  ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="14dd", ATTR{idProduct}="0002", TEST=="power/control", ATTR{power/control}="auto"
>  
>  # USB HID devices that are internal to the machine should also be safe to autosuspend
> +
> +ACTION=="add", SUBSYSTEM=="usb", SUBSYSTEMS=="usb", ATTRS{removable}=="removable", GOTO="usb_hid_pm_end"
> +ACTION=="add", SUBSYSTEM=="usb", SUBSYSTEMS=="usb", ATTRS{removable}=="unknown", GOTO="usb_hid_pm_end"        
> +
>  ACTION=="add", SUBSYSTEM=="usb", ATTR{bInterfaceClass}=="03", ATTRS{removable}=="fixed", TEST=="../power/control", ATTR{../power/control}="auto"
> +
> +LABEL="usb_add_pm_end"

LABEL should be "usb_hid_pm_end" here.

josh
