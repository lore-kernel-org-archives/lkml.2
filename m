Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab0DKU1e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 16:27:34 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:39122 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab0DKU1c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 16:27:32 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Bruno =?iso-8859-1?q?Pr=E9mont?= <bonbons@linux-vserver.org>
Subject: Re: [PATCH v6 7/8, needs improvement] hid: add suspend/resume hooks for hid drivers
Date: Sun, 11 Apr 2010 22:27:32 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>
References: <20100324233707.7243b04d@neptune.home> <alpine.LNX.2.00.1004112029220.8345@pobox.suse.cz> <20100411204002.6ba32f43@neptune.home>
In-Reply-To: <20100411204002.6ba32f43@neptune.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004112227.32045.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 11. April 2010 20:40:02 schrieb Bruno Prémont:
> On Sun, 11 April 2010 Jiri Kosina <jkosina@suse.cz> wrote:
> > > As far as I understand the code, in auto-suspend case if the driver 
> > > sends commands to the device it will have to call usbhid_wait_io(). 
> > > Please correct me if I'm wrong!
> > 
> > It's not needed. There is a queuing mechanism in place on 
> > 'resumption_waker' workqueue.
> 
> So the driver is not allowed to ask the device to do something
> at auto-suspend time (as that would abort the auto-suspension).

>From within suspend()?

Generally if the driver wants to talk to a device that's a good
reason to wake up a device.

	Regards
		Oliver
