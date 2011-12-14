Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab1LNHyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 02:54:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40352 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892Ab1LNHyR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 02:54:17 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Daniel Kurtz <djkurtz@chromium.org>
Subject: Re: [PATCH 2/3] HID: usbhid: hid-core: submit queued urbs before suspend
Date: Wed, 14 Dec 2011 08:55:39 +0100
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: jkosina@suse.cz, bleung@chromium.org, stern@rowland.harvard.edu,
        olofj@chromium.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <1321529030-7845-1-git-send-email-djkurtz@chromium.org> <1321529030-7845-3-git-send-email-djkurtz@chromium.org>
In-Reply-To: <1321529030-7845-3-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201112140855.40050.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 17. November 2011, 12:23:49 schrieb Daniel Kurtz:
> Unfortunately, this usually happens while the first LED request is
> actually still being processed.  Thus when the completion handler tries
> to submit the second LED request it fails, since REPORTED_IDLE is
> already set!  This REPORTED_IDLE check failure causes the completion
> handler to complete, however without clearing the CTRL_RUNNING flag.
> This, in turn, means that the suspend() handler's wait_io() condition
> is never satisfied, and instead it times out after 10 seconds, aborting
> the original system suspend.
> 
> This patch changes the behavior to the following:
>   (1) allow completion handler to finish submitting all queued URBs, even if
>       REPORTED_IDLE is set.  This guarantees that all URBs queued before the
>       hid-core suspend() call will be submitted before the system is
>       suspended.

Hi,

why is this desirable? You'd want to requests to be executed at resumption.
A system suspend will alter the LED state anyway.

	Regards
		Oliver
-- 
- - - 
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg) 
Maxfeldstraße 5                         
90409 Nürnberg 
Germany 
- - - 
