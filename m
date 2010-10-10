Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab0JJP6h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 11:58:37 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51973 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab0JJP6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 11:58:36 -0400
Message-ID: <4CB1E2A4.4000000@cnpbagwell.com>
Date: Sun, 10 Oct 2010 10:58:28 -0500
From: Chris Bagwell <chris@cnpbagwell.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Chase Douglas <chase.douglas@canonical.com>
CC: linux-input@vger.kernel.org, xorg-devel@lists.x.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Andy Whitcroft <apw@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-kernel@vger.kernel.org,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Duncan McGreggor <duncan.mcgreggor@canonical.com>
Subject: Re: [PATCH 3/3] Input: synaptics - remove touches over button click
 area
References: <1286549880-32580-1-git-send-email-chase.douglas@canonical.com> <1286549880-32580-2-git-send-email-chase.douglas@canonical.com> <1286549880-32580-3-git-send-email-chase.douglas@canonical.com> <1286549880-32580-4-git-send-email-chase.douglas@canonical.com>
In-Reply-To: <1286549880-32580-4-git-send-email-chase.douglas@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2010 09:58 AM, Chase Douglas wrote:
> Now that we have proper multitouch support, we can handle integrated
> buttons better. If we know the top of the buttons on the touchpad, we
> can ignore any touches that occur within the touchpad area while a
> button is clicked. It may be possible to get the button area by querying
> the device, but for now allow the user to manually set it.
>
> A note on why this works: the Synaptics touchpads have pseudo touch
> tracking. When two touches are on the touchpad, an MT touch packet with
> just the X, Y, and pressure values is sent before a normal Synaptics
> touch packet. When one touch is obviously in motion and the other is
> stationary, the touchpad controller sends the touch in motion in the
> normal packet and the stationary touch in the MT packet. Single touch
> emulation is provided by the normal packet, so an action like clicking
> a button and dragging with another finger still works as expected.
>
> Tested on a Dell Mini 1012 with synaptics_multitouch=1 and
> synaptics_button_thresh=4100.
>

Even if we did not submit the MT logic, I'd go a totally different 
direction and move clickpad button press support fully to 
xf86-input-synaptics and I'd remove the logic from kernel side that maps 
HW's middle button to left button.  It seems just limping a long with 
single button support anyways.

I haven't had time to review Takashi's xf86-input-synaptics patches just 
sent yet but seems along this line of thinking as well.

Chris
