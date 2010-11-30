Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab0K3PzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 10:55:00 -0500
Received: from bay0-omc4-s16.bay0.hotmail.com ([65.54.190.218]:45383 "EHLO
	bay0-omc4-s16.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752677Ab0K3Py6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 10:54:58 -0500
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Nov 2010 10:54:58 EST
X-Originating-IP: [71.6.48.170]
X-Originating-Email: [tobynbertram@hotmail.com]
Message-ID: <BAY130-DS5A81442DAC5CC69983A4ADE250@phx.gbl>
From: Tobyn Bertram <tobynbertram@hotmail.com>
To: "'Li, Yan I'" <yan.i.li@intel.com>,
        "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
CC: <linux-input@vger.kernel.org>, "'Takashi Iwai'" <tiwai@suse.de>,
        "'Ding, Jian-feng'" <jian-feng.ding@intel.com>,
        <linux-kernel@vger.kernel.org>, <meego-kernel@lists.meego.com>
References: <aefc1833eeede37ae6ea4a9ddeaa602eb7d31101.1290823698.git.yan.i.li@intel.com> <ddb890ce98e91c7422da64168b1624c1e62a02ee.1291101955.git.yan.i.li@intel.com> <20101130075026.GA15731@core.coreip.homeip.net> <20101130080759.GA17830@thyme.bj.intel.com>
Subject: RE: [PATCH v2] Input: Bug 18122 - Support Lenovo S10-3t's 2-button ClickPad
Date: Tue, 30 Nov 2010 07:48:12 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <20101130080759.GA17830@thyme.bj.intel.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
thread-index: AcuQZbc1/7KRH9QOQD6ivgJ8oYASJQAPrQ+Q
X-OriginalArrivalTime: 30 Nov 2010 15:48:11.0185 (UTC) FILETIME=[FDC6AA10:01CB90A5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I do not have a S10-3t.  I have a HP DV7t with a standard 1 button Clickpad.
I am sorry for any confusion.

I think that 2 different Clickpads will need to be defined: 1 button
Clickpads and 2 button Clickpads.  Maybe like this?

#define SYN_CAP_CLICKPAD1BTN(ex0c)		((ex0c) & 0x100000)
#define SYN_CAP_CLICKPAD2BTN(ex0c)		((ex0c) & 0x000100)

Tobyn

-----Original Message-----
From: Li, Yan I [mailto:yan.i.li@intel.com] 
Sent: Tuesday, November 30, 2010 12:08 AM
To: Dmitry Torokhov; tobynbertram@hotmail.com
Cc: linux-input@vger.kernel.org; Takashi Iwai; Ding, Jian-feng;
linux-kernel@vger.kernel.org; meego-kernel@lists.meego.com
Subject: Re: [PATCH v2] Input: Bug 18122 - Support Lenovo S10-3t's 2-button
ClickPad

On Tue, Nov 30, 2010 at 03:50:26PM +0800, Dmitry Torokhov wrote:
> On Tue, Nov 30, 2010 at 03:44:06PM +0800, Yan Li wrote:
> > This is for kernel bug #18122 and MeeGo bug #4807, version 2.
> > 
> > Lenovo S10-3t's ClickPad is a 2-button ClickPad that reports BTN_LEFT
> > and BTN_RIGHT as normal touchpad, unlike the 1-button ClickPad used in
> > HP mini 210 that reports solely BTN_MIDDLE.
> > 
> > Of c0-cap response, the 1-button ClickPad has the 20-bit set while
> > 2-button ClickPad has the 8-bit set.
> > 
> > This patch makes the kernel only handle 1-button ClickPad specially,
> > and treat 2-button ClickPad as same as other normal touchpads.
> > 
> 
> As Takashi mentioned, HP Clickpads have the same 0x0c signature than
> Lenovos non-clickpads so this is not that simple. We need to wait and
> see if Christopher will shed some light here...

So the only exception is the one reported by tob. These are the bits
I've collected:

Yan's S10-3t: model: 1, fw: 7.4, id: 0x1e0b1, caps:
0xd04771/0xa40000/0x4a0500 (2 button clickpad)
tob's S10-3t: model: 1, fw: 7.4, id: 0x1e0b1, caps:
0xd04771/0xe40000/0x5a0400 (?)
hp Envy 14/mini210:
              model: 1, fw: 7.4, id: 0x1e0b1, caps:
0xd04771/0xe40000/0x5a0400 (1 button clickpad)

I asked tob to double-check his model and whether his touchpad emits
BTN_MIDDLE or not but get no reply yet. I've checked 4 S10-3t
purchased at different dates and all of them show same exc0 cap, but I
have to say other models selling in other parts of the world may be
still different.

-- 
Best regards,
Li, Yan

MeeGo Team, Opensource Technology Center, SSG, Intel
Office tel.: +86-10-82171695 (inet: 8-758-1695)
OpenPGP key: 5C6C31EF
IRC: yanli on network irc.freenode.net

