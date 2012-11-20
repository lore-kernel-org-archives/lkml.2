Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab2KTQLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 11:11:35 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:57487 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab2KTQLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 11:11:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Lars Poeschel <poeschel@lemonage.de>
Subject: Re: [PATCH] video console: add a driver for lcd2s character display
Date: Tue, 20 Nov 2012 16:11:28 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>, FlorianSchandinat@gmx.de,
        mathieu.poirier@linaro.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1353416206-3243-1-git-send-email-larsi@wh2.tu-dresden.de> <201211201325.57883.arnd@arndb.de> <201211201521.33726.poeschel@lemonage.de>
In-Reply-To: <201211201521.33726.poeschel@lemonage.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211201611.28646.arnd@arndb.de>
X-Provags-ID: V02:K0:EVq8ZBKJRPL79b8slOhB4LneISE0swzGeh++8L5kmBy
 0JPzTFk+HX5R5YW4C7NS9sUzo0UVqz8hfqXDGNyoiQ699TS8SP
 XoTUiE96LgXz6XdaKXZDj+fW6Fw7tIalTfawz22+i6tnhATKf7
 0FlN+qb8xQGHX74oK50djLYkeNC58Jvnts5pTeWDITFh1jItJv
 a9s1oGtm1fOzi/9zderh8DBtRVBZ2CPgada5nmfGtPwlK42iqr
 9L25zl8ypBL+zlP5HN5n4VzJM4t9rpp9Ic/N0fwVPHALPM7Ap4
 pU/u7PJhDvdsH8EES+w4TK0EhfW/Bz4caWVWUR+YF1Pl6FOYUd
 EPITh41bX73nTQce7Fjc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 November 2012, Lars Poeschel wrote:
> > 
> > It's better to define the struct consw as a preinitialized
> > 'static const' object, rather than dynamically setting each
> > member.
> 
> I could not find a place to store the drivers private data inside the struct 
> vc_data. I wanted to have the struct consw inside the drivers private data 
> (struct lcd2s_data) to be able to container_of to the drivers private data in 
> the consw.con_* functions. This makes it possible to use more than one actual 
> lcd2s display with the same driver. Otherwise I have to store the struct 
> i2c_client somewhere statically and the driver can control only one display 
> and has to forbid to be probed a second time. Or am I wrong somewhere ?

I believe you can only have one device anyway, because of the way you
register using "take_over_console(&data->consw, LCD2S_FIRST, LCD2S_LAST, 1);"

Whichever lcd2s was last registered gets VC 8 and 9. This is not nice, but
I think it's similar to how all the other VC work. They consequently don't
store per-device data at all, but just have global variables for device
specific data. We generally discourage this behaviour for device drivers,
but I woulnd't expect you to change the way that VC works, so you can just
do the same here.

Things would be different if this was a "console" driver rather than a "vc"
driver.

	Arnd
