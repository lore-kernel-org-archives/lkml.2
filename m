Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab0DKSbW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 14:31:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43297 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456Ab0DKSbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 14:31:20 -0400
Date: Sun, 11 Apr 2010 20:31:18 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH v6 7/8, needs improvement] hid: add suspend/resume hooks
 for hid drivers
In-Reply-To: <20100411130226.4086a92d@neptune.home>
Message-ID: <alpine.LNX.2.00.1004112029220.8345@pobox.suse.cz>
References: <20100324233707.7243b04d@neptune.home> <20100324234022.0361bd80@neptune.home> <20100326065656.GC26602@core.coreip.homeip.net> <20100326102951.3b9ecda1@neptune.home> <alpine.LNX.2.00.1003262156280.24576@pobox.suse.cz> <20100327012245.0ace6a09@neptune.home>
 <alpine.LNX.2.00.1003291144350.24576@pobox.suse.cz> <20100329121611.0c22dcaf@pluto.restena.lu> <alpine.LNX.2.00.1003301010410.24576@pobox.suse.cz> <20100330223224.18fe4f3e@neptune.home> <20100330224230.7b84df75@neptune.home> <alpine.LNX.2.00.1003311415000.24576@pobox.suse.cz>
 <20100411130226.4086a92d@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Apr 2010, Bruno Prémont wrote:

> > We should also consider putting the hook calls into bluetooth 
> > implementation as well (though there is currently no driver using it, but 
> > I don't know, maybe Wacom could benefit from it as well).
> 
> Where do I find the bluetooth HID bits? I've been searching through kernel
> sources (under drivers/) but did not find bluetooth code trying to
> register a HID device...

They are in net/bluetooth/hidp. Not really obvious, I know, but Marcel 
wanted it this way.

> As far as I understand the code, in auto-suspend case if the driver 
> sends commands to the device it will have to call usbhid_wait_io(). 
> Please correct me if I'm wrong!

It's not needed. There is a queuing mechanism in place on 
'resumption_waker' workqueue.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
