Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab2ENUq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:46:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56641 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab2ENUq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:46:58 -0400
Date: Mon, 14 May 2012 13:46:54 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] Staging: ipack: add proper device model into
 ipack_bus_register.
Message-ID: <20120514204654.GA8723@kroah.com>
References: <1336992089-2733-1-git-send-email-siglesias@igalia.com>
 <1336992089-2733-3-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336992089-2733-3-git-send-email-siglesias@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 12:41:26PM +0200, Samuel Iglesias Gonsalvez wrote:
> This patch adds a proper device model to the driver. The carrier boards are
> managed like other ipack device, the way to recognize them is using the
> platform data field from struct device.

Wait, what?  Why would you use the platform data field?  Why is that
needed at all?  You can specify the "type" of the device, but it seems
that you really want two different things here, busses and devices,
right?  So use two different devices and manage them differently, don't
make them the "same but different" by looking at the platform data
field.  That's not what the platform data field is for at all, sorry.

Please rework this patch, I can't take it as-is, sorry.

greg k-h
