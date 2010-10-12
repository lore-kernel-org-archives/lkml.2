Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab0JLSHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 14:07:18 -0400
Received: from csmtp1.one.com ([195.47.247.21]:42796 "EHLO csmtp1.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579Ab0JLSHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 14:07:17 -0400
X-Greylist: delayed 530 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Oct 2010 14:07:16 EDT
Message-ID: <4CB4A1BB.9010006@bitmath.org>
Date: Tue, 12 Oct 2010 19:58:19 +0200
From: Henrik Rydberg <rydberg@bitmath.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100922 Thunderbird/3.1.4
MIME-Version: 1.0
To: Chase Douglas <chase.douglas@canonical.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chris Bagwell <chris@cnpbagwell.com>, Takashi Iwai <tiwai@suse.de>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        linux-input <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Proposal for synaptics driver
References: <1286900585.22715.367.camel@mini>
In-Reply-To: <1286900585.22715.367.camel@mini>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2010 06:23 PM, Chase Douglas wrote:
[...]

> The rest of the
> touchpad is stationary and does not click. If no one has a better name
> for these touchpads, I'll refer to them as "integrated buttons"
> touchpads.


The name "integrated button" is the term in use for the later Macbook models,
where there is a button that clicks anywhere on the pad.

[...]

> My definition of a usable mouse is single touch and left

> click support (including click and drag using a physical button).


This has been stated several times already in related threads.

[...]
> For ClickPad devices, my feeling is that we should translate middle

> button clicks to left button clicks in the kernel, and MT+ST emulation
> should be performed. Middle and right click functionality may be
> provided for in userspace,


Having the physical click map to BTN_LEFT, regardless of where on the pad, and
flagging the presence of an integrated button via the version field in the
device id, would be consistent with existing drivers.

[...]

> I think we should disable single touch support over the buttons due to
> the following scenario:
> 
> User positions cursor over button on screen, attempts to click physical
> touchpad button, cursor moves because of motion on touchpad when user
> depresses button.


The location and number of buttons could be freely mappable in userspace, so I
think we want to put minimum energy into the emulation part, considering it is
reworked in userspace anyways.


[...]

> Now the bit about integrated button touchpad detection. First, I would
> be interested in learning if anyone can disprove bit 0x200000 of the 0c
> extended caps flags means integrated buttons.


I think the easiest way to learn this is to produce a dkms package for people to
test.

Henrik
