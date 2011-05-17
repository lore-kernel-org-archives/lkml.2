Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab1EQLkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 07:40:14 -0400
Received: from smtpout05.highway.telekom.at ([195.3.96.77]:46489 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754082Ab1EQLkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 07:40:12 -0400
From: Melchior FRANZ <melchior.franz@gmail.com>
To: Michael Chang <mchang@novell.com>
Subject: Re: i915/kms/backlight-combo mode problem
Date: Tue, 17 May 2011 13:40:08 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.6; KDE/4.6.3; x86_64; ; )
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        Joey Lee <jlee@novell.com>, chris@chris-wilson.co.uk,
        dri-devel@lists.freedesktop.org
References: <BANLkTimXkXCAKQGK2ysTRNN-xa4ZChxcHA@mail.gmail.com> <201105171058.21652@rk-nord.at> <BANLkTi=60vWASESnJ-_wdc-XEpzb-k9F1Q@mail.gmail.com>
In-Reply-To: <BANLkTi=60vWASESnJ-_wdc-XEpzb-k9F1Q@mail.gmail.com>
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105171340.09118@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

* Michael Chang -- Tuesday 17 May 2011:
> If you change brightness from lowest to highest, the LPBC value changes
> this way
> 
> Highest                  Lowest
> 0x10 ,   0x19 ......   0xe5

Yes. (Though it's 0x01, not 0x10.)

    ---0xFF      ... initial value and after closing/reopening lid
    |  0xE5   \  ... dark
    |  0xCC   |
    |  0xB2   |
 (1)|  0x99   |
    |  0x7F   |_____key adjustable range
    |  0x66   |
    |  0x4C   |
    |  0x33   |
    -->0x19   |
       0x01   /  ... bright
       0x00      ... also bright, only settable with setpci


(1) is the jump that resurrects the backlight from darkness by
    pressing the "brightness down" key

And again, if fully turned up via keys (and therefore at 0x01),
then setting to 0xff with setpci doesn't turn it off. At all other
key steps it does.  :-)



> If above is true, then you have a very particular notebook that
> reverse the sense of the LPBC values ....  I don't know who ever came
> across such device. wow.

Maybe they screwed it up and therefore sold it with Linux ("linpus")
and a custom driver preinstalled ...



> Regarding that your brightness control key,  due to that it is
> controlled by acer_wmi and likely that BIOS aware this, it would do
> brightness in a reversed way.

acer_wmi doesn't do the brightness adjustment. But maybe under "linpus"
some variant of it did. (BTW: there are two keys on this notebook that
aren't handled by the kernel, by X11 or even acer_wmi. There are just no
events for them. Looks like another ACER brain damage err.. "capability". :-)

m.
