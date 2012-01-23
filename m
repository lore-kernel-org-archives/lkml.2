Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab2AWJFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 04:05:14 -0500
Received: from senator.holtmann.net ([87.106.208.187]:56018 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab2AWJFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 04:05:13 -0500
Message-ID: <1327309415.1955.87.camel@aeonflux>
Subject: Re: [PATCH] Regression: Revert "Bluetooth: use buffer priority to
 mark URB_ISO_ASAP flag"
From: Marcel Holtmann <marcel@holtmann.org>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
Date: Mon, 23 Jan 2012 10:03:35 +0100
In-Reply-To: <1327298281-2502-1-git-send-email-keithp@keithp.com>
References: <1327298281-2502-1-git-send-email-keithp@keithp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keith,

> URB_ISO_ASAP may only be used with iso end points, but this patch was
> attempting to use it with a bulk endpoint. When DEBUG is defined in
> the USB stack, it checks for invalid flags and returns -EINVAL instead
> of actually transmitting the data.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---

a version of this patch should be already upstream or in stable trees.
If you are sending this again, then it might slipped through. Johan?

> Ok, so this is a comedy of errors. The Bluetooth code is trying to use
> an iso-specific flag (URB_ISO_ASAP) on a bulk endpoint, which is
> invalid, but normally harmless. Unless the USB code is compiled for
> debugging, in which case it checks a bunch for incorrect usage and
> discards URBs which are wrong.
> 
> As far as I'm concerned, #ifdef DEBUG code should never ever change
> the behaviour of the code, and so I'd say the USB code is even more
> broken than the bluetooth code...

And yes, this one is hilarious.

Regards

Marcel


