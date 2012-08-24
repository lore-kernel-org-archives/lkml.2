Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933376Ab2HXWaq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 18:30:46 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40429 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414Ab2HXWan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 18:30:43 -0400
Message-ID: <5038007E.5060505@gmail.com>
Date: Sat, 25 Aug 2012 00:30:22 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Josh Boyer <jwboyer@redhat.com>
CC: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        bruno@wolff.to, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: Logitech USB headset not working in 3.6-rc3
References: <20120824190808.GC20043@zod.bos.redhat.com>
In-Reply-To: <20120824190808.GC20043@zod.bos.redhat.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 24.08.2012 21:08, Josh Boyer wrote:
> We've had a report[1] that the Logitech USB headset 0003:046D:0A0C isn't
> working with 3.6-rc3.  It seems the last working kernel was based on
> commit 10c63c9, and it first stopped working with a kernel based on
> commit 23dcfa6.  There are only a few ALSA commits between those
> revisions, so hopefully this is something that is fairly easy to
> identify.  The only commit to USB audio in that set is:

[...]

> !!ALSA/HDA dmesg
> !!------------------
> 
> [   38.190306] SELinux: initialized (dev configfs, type configfs), uses genfs_contexts
> [   38.229616] snd_hda_intel 0000:00:1b.0: irq 66 for MSI/MSI-X
> [   38.270699] ALSA sound/usb/mixer.c:866 6:0: cannot get min/max values for control 2 (id 6)
> [   38.274097] ALSA sound/usb/mixer.c:866 1:0: cannot get min/max values for control 2 (id 1)
> [   38.276753] ALSA sound/usb/mixer.c:866 2:0: cannot get min/max values for control 2 (id 2)
> [   38.279322] ALSA sound/pci/hda/hda_auto_parser.c:322 autoconfig: line_outs=1 (0xe/0x0/0x0/0x0/0x0) type:line
> [   38.279326] ALSA sound/pci/hda/hda_auto_parser.c:326    speaker_outs=1 (0x11/0x0/0x0/0x0/0x0)
> [   38.279329] ALSA sound/pci/hda/hda_auto_parser.c:330    hp_outs=1 (0xd/0x0/0x0/0x0/0x0)
> [   38.279331] ALSA sound/pci/hda/hda_auto_parser.c:331    mono: mono_out=0x0
> [   38.279333] ALSA sound/pci/hda/hda_auto_parser.c:335    inputs:
> [   38.279336] ALSA sound/pci/hda/hda_auto_parser.c:339      Mic=0x10
> [   38.279342] ALSA sound/pci/hda/hda_auto_parser.c:339      Line=0xf
> [   38.285983] usbcore: registered new interface driver snd-usb-audio

Also, according to this dmesg, the device is probed just fine (which the
commit you mentioned wouldn't change anything about though).

So what does "isn't working anymore" refer to precisely? Are there any
more dmesg entries generated once the stream is started?


Daniel

