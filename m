Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438Ab0DHKAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 06:00:25 -0400
Received: from smtprelay01.ispgateway.de ([80.67.18.43]:50713 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab0DHKAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 06:00:21 -0400
X-Greylist: delayed 12187 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Apr 2010 06:00:21 EDT
Message-ID: <4BBDA92B.8010505@ladisch.de>
Date: Thu, 08 Apr 2010 12:00:11 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Tvrtko Ursulin <tvrtko@ursulin.net>, Takashi Iwai <tiwai@suse.de>
CC: alsa-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Ooops when working with USB MIDI (2.6.33.1)
References: <201004051433.47171.tvrtko@ursulin.net>
In-Reply-To: <201004051433.47171.tvrtko@ursulin.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tvrtko Ursulin wrote:
> I had TuxGuitar running and an external USB MIDI device, which I then
> turned off, on, and exited TuxGuitar at which point there was this oops.
> ...
> [321182.618342] IP: [<ffffffff81375d65>] _raw_spin_lock_irq+0x15/0x30                                                                               
> [321182.618449]  [<ffffffffa01e2fca>] ? snd_usbmidi_output_drain+0x7a/0x100 [snd_usb_lib]
> [321182.618462]  [<ffffffffa01b7699>] ? snd_rawmidi_drain_output+0x119/0x180 [snd_rawmidi]

I think that bug was introduced by this commit:
http://git.kernel.org/linus/7a17daae8ed71bf3259d905a4fc48a5b424fa935
which causes the driver to free many internal data structures when
they might still be in use by userspace.

Please try to revert it.

I think a proper fix would be to free the URBs/buffers but not the
driver's data structures.

Takashi, do you remember what the original problem was?


Regards,
Clemens
