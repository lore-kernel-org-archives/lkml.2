Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab2IMEwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 00:52:15 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48655 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab2IMEwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 00:52:12 -0400
Date: Wed, 12 Sep 2012 21:52:06 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: =?utf-8?B?Vm9qdMSbY2ggQm/EjWVr?= <vbocek@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Input: joydev - fix axes values sent in initial
 js_event
Message-ID: <20120913045206.GB17105@core.coreip.homeip.net>
References: <1344895914-32127-1-git-send-email-vbocek@gmail.com>
 <20120905055218.GA24715@core.coreip.homeip.net>
 <CAOeGmboLCan-fX4sPPxS5jkyepxLTSnRgvdHJ0-edcH8UCQg+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOeGmboLCan-fX4sPPxS5jkyepxLTSnRgvdHJ0-edcH8UCQg+w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 10:09:57PM +0200, Vojtěch Boček wrote:
> Hi,
> 
> 2012/9/5 Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > So what guarantees that joystick events will arrive in time, before
> > joydev_generate_startup_event() is called? It looks like your solution
> > is racy...
> >
> > I wonder if we should not generate the startup event until we have seen
> > at least one EV_SYN, i.e. entire device state has been transmitted to
> > us.
> 
> I just tried to delay read() until first EV_SYN arrives as you suggested,
> but that was not the problem, at least not the main one. First joystick
> input events arrives immediately after it is plugged in and driver is loaded,
> but when that happens, joydev may not be (and most likely is not)
> opened yet, which means the events will never reach joydev because of
> "if (!handle->open)" check in input_pass_event.
> 
> I wonder how to handle this. Is "if(!handle->open)" valid check? I think so,
> my guess is that joydev is the only handler with internal buffer, and it
> is useless to update that buffer when the device is not opened.
> I think reloading abs values on joydev open should be okay.
> 
> I suppose that if we reload abs values on joydev open, waiting for first
> sync is not needed, yes?
> 
> So the patch could look like this:

This makes sense. Just to confirm - have you tried the patch and
verified it works for you?

Thanks.

-- 
Dmitry
