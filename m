Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab1LNJXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 04:23:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673Ab1LNJXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 04:23:34 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Daniel Kurtz <djkurtz@chromium.org>
Subject: Re: [PATCH 3/3] HID: usbhid: defer LED setting to a workqueue
Date: Wed, 14 Dec 2011 10:25:04 +0100
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: jkosina@suse.cz, bleung@chromium.org, stern@rowland.harvard.edu,
        olofj@chromium.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <1321529030-7845-1-git-send-email-djkurtz@chromium.org> <201112140901.35203.oneukum@suse.de> <CAGS+omAzL+RspmQ=GCAN+NSEyDddm=zXvJR99PPT8R=4OVGn4g@mail.gmail.com>
In-Reply-To: <CAGS+omAzL+RspmQ=GCAN+NSEyDddm=zXvJR99PPT8R=4OVGn4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112141025.04745.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 14. Dezember 2011, 09:19:31 schrieb Daniel Kurtz:
> On Wed, Dec 14, 2011 at 4:01 PM, Oliver Neukum <oneukum@suse.de> wrote:
> > Am Donnerstag, 17. November 2011, 12:23:50 schrieb Daniel Kurtz:
> >> Defer LED setting action to a workqueue.
> >> This is more likely to send all LED change events in a single URB.
> >
> > Hi,
> >
> > I hope I am looking at the correct version of this patch.
> 
> Yes, that is the correct version.  It looks like I forgot to bump r in
> the [PATCH] of the subject.
> 
> > But as far as I can see the work for handling LEDs is not delayed
> > while a reset is going on. That is wrong.
> 
> Good catch, I think.  Your comment is a bit terse, so it is difficult to
> tell exactly what you are recommending.  Perhaps something like the following?

The problem done this way is what submits the work again after
it did nothing because a reset was pending.

	Regards
		Oliver
