Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040Ab1JXQje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 12:39:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61865 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933013Ab1JXQjd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 12:39:33 -0400
MIME-Version: 1.0
In-Reply-To: <4EA5913D.7090004@genband.com>
References: <op.v3q34la3dsdv5o@localhost>
	<4EA5913D.7090004@genband.com>
Date: Mon, 24 Oct 2011 14:39:31 -0200
Message-ID: <CACGt9ymGUAzjkZJCePnO+7cyKsi8-rtpno9ebjKtoCXj-tCALg@mail.gmail.com>
Subject: Re: Linux USB HID should ignore values outside Logical
 Minimum/Maximum range
From: =?UTF-8?Q?Denilson_Figueiredo_de_S=C3=A1?= <denilsonsa@gmail.com>
To: Chris Friesen <chris.friesen@genband.com>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 14:24, Chris Friesen <chris.friesen@genband.com> wrote:
> On 10/22/2011 05:42 AM, Denilson Figueiredo de Sá wrote:
>
>> It may even happen to send an out-of-range value for one axis, but a
>> valid value for another axis. The code should be prepared for that
>> (ignore one, but keep the other).
>
> In this case what should be used for the "invalid" axis value?  The previous
> value?

If that's an absolute pointing device, can we supply only one axis? I
mean, can we do this: "move the pointer to this X position, but leave
the Y position where it currently is". (note that the pointer might
have moved since last input from this device, due to other devices
also being present)

If that's not possible, then I'm not sure about what should be the
correct behavior. Should we ignore both axes if one of them is
invalid? Should we use the last good value from the other axis? (note
that relative pointing devices like proper mice shouldn't have this
issue, as we can just use zero for invalid values, which means "no
movement")

I haven't tested that on Windows (yet), so I don't know how it
behaves. If I test it, I'll post my results here.

I know, this is a corner case difficult to decide about.



By the way, my report was about absolute pointing devices, but I
haven't tested how Linux USB HID behaves for other kinds of devices
(keyboards, gamepads, anything else).


-- 
Denilson Figueiredo de Sá
Rio de Janeiro - Brasil
