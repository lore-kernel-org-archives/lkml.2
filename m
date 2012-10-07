Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab2JGTEz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 15:04:55 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:13757 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab2JGTEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 15:04:46 -0400
Date: Sun, 7 Oct 2012 21:03:59 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, fabien.andre@gmail.com,
        scott.liu@emc.com.tw, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] i2c-hid: introduce HID over i2c specification
 implementation
Message-ID: <20121007210359.29f40ecf@endymion.delvare>
In-Reply-To: <CAN+gG=E3nmXZ9RL3wN2tvKqSOu5hWYLXLf+Z=ag7VvZGJfhQ-w@mail.gmail.com>
References: <1347630103-4105-1-git-send-email-benjamin.tissoires@gmail.com>
	<20121007162838.01f36b7c@endymion.delvare>
	<CAN+gG=E3nmXZ9RL3wN2tvKqSOu5hWYLXLf+Z=ag7VvZGJfhQ-w@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Oct 2012 18:57:36 +0200, Benjamin Tissoires wrote:
> On Sun, Oct 7, 2012 at 4:28 PM, Jean Delvare <khali@linux-fr.org> wrote:
> > On Fri, 14 Sep 2012 15:41:43 +0200, benjamin.tissoires wrote:
> >> +     u16 readRegister = ihid->hdesc.wDataRegister;
> >
> > This is missing le16_to_cpu().
> 
> I agree this is awful, but not putting it allows me to not have to
> check the endianness when I'm using it.
> But I may be totally wrong on this.

I'm afraid I don't follow you. I want to see:

	u16 readRegister = le16_to_cpu(ihid->hdesc.wDataRegister);

If you don't do that, your driver is broken on bigendian systems. And
there's no need to "check the endianness when you're using it", the
above should be enough for things to work just fine.

-- 
Jean Delvare
