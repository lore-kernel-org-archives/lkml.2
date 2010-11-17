Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933405Ab0KQGxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 01:53:03 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38165 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab0KQGxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 01:53:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TkiUlKuxc+I21ttdJSopD/81CbG5m3dt4FS+Ops4hDuBYWQJs1m2iZeiNDp6yfUUes
         a9GfZkF6zxJvighWTyAS3EzqfJMM6ugzcxBH9sVAun/AbV5zyl3Vs4KqvtYoFU5E7mdQ
         Dd/QJx2cKFD/Xu05yvjgc43hgaq7VtzSRnL3k=
Date: Tue, 16 Nov 2010 22:52:52 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: Mattia Dongili <malattia@linux.it>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: regression since 2.6.36: backlight in sony-laptop not working
Message-ID: <20101117065252.GA7046@core.coreip.homeip.net>
References: <20101104142915.GC7650@gamma.logic.tuwien.ac.at>
 <20101110035833.GB3029@kamineko.org>
 <20101111235000.GA6651@gamma.logic.tuwien.ac.at>
 <20101112034423.GA7407@srcf.ucam.org>
 <20101112035027.GD26742@gamma.logic.tuwien.ac.at>
 <20101112035732.GB7574@srcf.ucam.org>
 <20101112042243.GE2852@kamineko.org>
 <20101117063006.GF29129@gamma.logic.tuwien.ac.at>
 <20101117063338.GG29129@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117063338.GG29129@gamma.logic.tuwien.ac.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 03:33:38PM +0900, Norbert Preining wrote:
> > - recompiled a input-kbd binary with a relaxed version check
> > 	-	if (EV_VERSION != version) {
> > 	+	if (EV_VERSION > version) {
> >   in input.c, line 104 of input-utils.
> 
> Furthermore, although both of you referred to the fact that udev keymap
> is working, I checked that Debian/sid uses udev kbd rules, but it 
> stopped working ...
> 

Seems to be working here (I also verified that the keycodces are
actually emitted with evtest):

[root@dtor-d630 ~]# /lib/udev/keymap /dev/input/event3 0x87 wlan
setting scancode 0x87 to key code 238
[root@dtor-d630 ~]# /lib/udev/keymap /dev/input/event3 0x87 battery
setting scancode 0x87 to key code 236
[root@dtor-d630 ~]# uname -r
2.6.37-rc1+
[root@dtor-d630 ~]# 

-- 
Dmitry
