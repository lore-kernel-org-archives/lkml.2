Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699Ab2HPQrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:47:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37080 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab2HPQrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:47:13 -0400
Date: Thu, 16 Aug 2012 18:47:04 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 0/7] HID: picoLCD updates
In-Reply-To: <20120816183021.68c37f37@neptune.home>
Message-ID: <alpine.LNX.2.00.1208161846240.28475@pobox.suse.cz>
References: <20120730213656.0a9f6d30@neptune.home> <alpine.LNX.2.00.1208151016221.7026@pobox.suse.cz> <20120815114236.0f7db40e@neptune.home> <alpine.LNX.2.00.1208151409500.7026@pobox.suse.cz> <20120815171635.2564a4a8@neptune.home> <alpine.LNX.2.00.1208152329580.7026@pobox.suse.cz>
 <20120816183021.68c37f37@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Aug 2012, Bruno Prémont wrote:

> > I don't really understand this explanation. Once usb_kill_urb() returns, 
> > the URB should be available for future use (and therefore all queues 
> > completely drained).
> 
> I won't have time today to check, though my guess is that on each
> echo $usb-id > bind; echo $usb-id > unbind
> under /sys/bus/hid/drivers/hid-picolcd/ the USB urb queue fills a bit does
> not get cleared.
> 
> Is usb_kill_urb() called when unbinding just the specific hid driver? 

Yup, through hid_hw_stop() -> usbhid_stop().

> If so my short timing between bind/unbind must be triggering something 
> else...
> 
> Otherwise I'm missing something as at first time I got no "output queue full"
> messages, but as I repeated the bind/unbind sequences the prints per bind/unbind
> iteration increased in number.
> 
> Anyhow, on Friday evening/week-end I will continue digging and report back with my
> findings.

Thank you, Bruno.

-- 
Jiri Kosina
SUSE Labs
