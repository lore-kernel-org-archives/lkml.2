Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab0INGHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 02:07:14 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:50268 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab0INGHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 02:07:11 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [linux-pm] wacom + runtime PM = AA deadlock
Date: Tue, 14 Sep 2010 08:07:39 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, pingc@wacom.com,
        Jiri Slaby <jslaby@suse.cz>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org
References: <4C8E180D.4020309@suse.cz> <201009132120.23372.oliver@neukum.org> <20100914005209.GB27540@core.coreip.homeip.net>
In-Reply-To: <20100914005209.GB27540@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009140807.39977.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 14. September 2010, 02:52:10 schrieb Dmitry Torokhov:
> On Mon, Sep 13, 2010 at 09:20:23PM +0200, Oliver Neukum wrote:
> > Am Montag, 13. September 2010, 19:10:47 schrieb Dmitry Torokhov:
> > 
> > > I think this introduces significant change in behavior though - before
> > > we did not do usb_autopm_put_interface() on successful open, basically
> > > disabling autopm facilities, right?
> > 
> > Right. Which makes no sense at all. You'd better remove anything related
> > to runtime PM and not set supports_autosuspend for that.
> > 
> 
> That not what I meant, I do not want to remove autopm, it's just it was
> effectively disabled and if we fix it we might start getting some
> regression reports ;)

True. So currently we have

- a deadlock
- disabled runtime power management

We need to fix the deadlock. We can fix it retaining a disabled
runtime power management. Or we can fix it fixing the runtime
power management at the same time. However this opens
the door to regressions. So for now I really suggest removing
it from the driver and reintroduce it properly for the next merge
window.

	Regards
		Oliver
