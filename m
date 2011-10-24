Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab1JXUfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 16:35:54 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60568 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab1JXUfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 16:35:51 -0400
Date: Mon, 24 Oct 2011 13:35:41 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Denilson Figueiredo de =?iso-8859-1?Q?S=E1?= 
	<denilsonsa@gmail.com>
Cc: Chris Friesen <chris.friesen@genband.com>, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: Linux USB HID should ignore values outside Logical
 Minimum/Maximum range
Message-ID: <20111024203541.GB31721@core.coreip.homeip.net>
References: <op.v3q34la3dsdv5o@localhost>
 <4EA5913D.7090004@genband.com>
 <CACGt9ymGUAzjkZJCePnO+7cyKsi8-rtpno9ebjKtoCXj-tCALg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGt9ymGUAzjkZJCePnO+7cyKsi8-rtpno9ebjKtoCXj-tCALg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 02:39:31PM -0200, Denilson Figueiredo de Sá wrote:
> On Mon, Oct 24, 2011 at 14:24, Chris Friesen <chris.friesen@genband.com> wrote:
> > On 10/22/2011 05:42 AM, Denilson Figueiredo de Sá wrote:
> >
> >> It may even happen to send an out-of-range value for one axis, but a
> >> valid value for another axis. The code should be prepared for that
> >> (ignore one, but keep the other).
> >
> > In this case what should be used for the "invalid" axis value?  The previous
> > value?
> 
> If that's an absolute pointing device, can we supply only one axis? I
> mean, can we do this: "move the pointer to this X position, but leave
> the Y position where it currently is". (note that the pointer might

Yes, input protocol is stateful and it will actually suppress duplicate
events itself. I.e. if device moves from (10, 20) to (40, 20) usespace
will see:

EV_ABS/ABS_X/10
EV_ABS/ABS_Y/20
EV_SYN/SYN_REPORT
EV_ABS/ABS_X/40
EV_SYN/SYN_REPORT

even if driver emits 2nd EV_ABS/ABS_Y/20 event.

> have moved since last input from this device, due to other devices
> also being present)

The other devices have no effect on this device state.

Thanks.

-- 
Dmitry
