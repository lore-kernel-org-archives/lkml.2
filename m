Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab2LEOZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 09:25:17 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:38950 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab2LEOZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 09:25:14 -0500
MIME-Version: 1.0
X-Originating-IP: [121.7.72.46]
In-Reply-To: <s5hzk1tvm6m.wl%tiwai@suse.de>
References: <CAMVG2st4KZOYk9qMK6FFRnJt0bCEz-0nFsQAa4zXc+sed_eVhQ@mail.gmail.com>
	<s5hwqx69kuk.wl%tiwai@suse.de>
	<s5ha9tv1j2a.wl%tiwai@suse.de>
	<CAMVG2svAdYxJqj=7oA8XpYfaV6MP14Ff_DR3ZwVG0cm-FV_0sA@mail.gmail.com>
	<s5hip8jyza2.wl%tiwai@suse.de>
	<CAMVG2suWOAXJYWJb+QrLH2KV3CJw+Ut6fRRuy0U_F6-9oV9YyA@mail.gmail.com>
	<s5ha9tvyuio.wl%tiwai@suse.de>
	<CAMVG2svjXk-dbhjuiAX4SpTctNbwPkyzOa47n9vA2o1rLiWbBw@mail.gmail.com>
	<s5h38znysbx.wl%tiwai@suse.de>
	<CAMVG2sse7VN31gVjGuQr+7R6To8Nwk-OPwFs5Nhauxh7-J=jOg@mail.gmail.com>
	<s5h1uf6x87a.wl%tiwai@suse.de>
	<s5hsj7lx6on.wl%tiwai@suse.de>
	<CAMVG2su62GRKwO=948WZq8AUxB7DTv0794m+MNGFe9ZFJxHwiQ@mail.gmail.com>
	<s5hehj5x3ke.wl%tiwai@suse.de>
	<CAMVG2svTDCzyVsJT+drpGUJOpNbSOSTWnNPbSdZdFFrbcx42tA@mail.gmail.com>
	<s5hzk1tvm6m.wl%tiwai@suse.de>
Date: Wed, 5 Dec 2012 22:25:12 +0800
Message-ID: <CAMVG2ssi==HZoRLGEZ1e9izRsdipFxy4FGje7gMgEo504Wu33A@mail.gmail.com>
Subject: Re: switcheroo registration vs switching race...
From: Daniel J Blueman <daniel@quora.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Seth Forshee <seth.forshee@canonical.com>, Dave Airlie <airlied@linux.ie>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 December 2012 00:04, Takashi Iwai <tiwai@suse.de> wrote:
> At Tue, 4 Dec 2012 23:54:39 +0800,
> Daniel J Blueman wrote:
>>
>> On 4 December 2012 23:03, Takashi Iwai <tiwai@suse.de> wrote:
>> > At Tue, 4 Dec 2012 22:46:47 +0800,
>> > Daniel J Blueman wrote:
>> >>
>> >> On 4 December 2012 21:55, Takashi Iwai <tiwai@suse.de> wrote:
>> >> > At Tue, 04 Dec 2012 14:23:05 +0100,
>> >> > Takashi Iwai wrote:
>> >> >>
>> >> >> At Tue, 4 Dec 2012 20:58:55 +0800,
>> >> >> Daniel J Blueman wrote:
>> >> >> >
>> >> >> > On 4 December 2012 01:10, Takashi Iwai <tiwai@suse.de> wrote:
>> >> >> > > At Tue, 4 Dec 2012 00:50:56 +0800,
>> >> >> > > Daniel J Blueman wrote:
>> >> >> > >>
>> >> >> > >> On 4 December 2012 00:23, Takashi Iwai <tiwai@suse.de> wrote:
>> >> >> > >> > At Mon, 3 Dec 2012 23:08:28 +0800,
>> >> >> > >> > Daniel J Blueman wrote:
>> >> >> > >> >>
>> >> >> > >> >> On 3 December 2012 22:40, Takashi Iwai <tiwai@suse.de> wrote:
>> >> >> > >> >> > At Mon, 3 Dec 2012 22:25:52 +0800,
>> >> >> > >> >> > Daniel J Blueman wrote:
>> >> >> > >> >> >>
>> >> >> > >> >> >> On 3 December 2012 19:17, Takashi Iwai <tiwai@suse.de> wrote:
>> >> >> > >> >> >> > At Wed, 28 Nov 2012 09:45:39 +0100,
>> >> >> > >> >> >> > Takashi Iwai wrote:
>> >> >> > >> >> >> >>
>> >> >> > >> >> >> >> At Wed, 28 Nov 2012 11:45:07 +0800,
>> >> >> > >> >> >> >> Daniel J Blueman wrote:
>> >> >> > >> >> >> >> >
>> >> >> > >> >> >> >> > Hi Seth, Dave, Takashi,
>> >> >> > >> >> >> >> >
>> >> >> > >> >> >> >> > If I power down the unused discrete GPU before lightdm starts by
>> >> >> > >> >> >> >> > fiddling with the sysfs file [1] in the upstart script, I see a race
>> >> >> > >> >> >> >> > manifesting as the discrete GPU's HDA controller timing out to
>> >> >> > >> >> >> >> > commands [2].
>> >> >> > >> >> >> >> >
>> >> >> > >> >> >> >> > Adding some debug, I see that the registered audio devices are put
>> >> >> > >> >> >> >> > into D3 before the GPU is, but it turns out that the discrete (and
>> >> >> > >> >> >> >> > internal) GPU's HDA controller gets registered a bit later, so the
>> >> >> > >> >> >> >> > list is empty. The symptom is since the HDA driver it's talking to
>> >> >> > >> >> >> >> > hardware which is now in D3.
>> >> >> > >> >> >> >> >
>> >> >> > >> >> >> >> > We could add a mutex to nouveau to allow us to wait for the DGPU HDA
>> >> >> > >> >> >> >> > controller, but perhaps this should be solved at a higher level in the
>> >> >> > >> >> >> >> > vgaswitcheroo code; what do you think?
>> >> >> > >> >> >> >>
>> >> >> > >> >> >> >> Maybe it's a side effect for the recent effort to fix another race in
>> >> >> > >> >> >> >> the probe.  A part of them problem is that the registration is done at
>> >> >> > >> >> >> >> the very last of probing.
>> >> >> > >> >> >> >>
>> >> >> > >> >> >> >> Instead of delaying the registration, how about the patch below?
>> >> >> > >> >> >> >
>> >> >> > >> >> >> > Ping.  If this really works, I'd like to queue it for 3.8 merge, at
>> >> >> > >> >> >> > least...
>> >> >> > >> >> >>
>> >> >> > >> >> >> Ping ack; I was trying to find time to understand another race that
>> >> >> > >> >> >> occurs with GPU probing after switching, but is separate from the
>> >> >> > >> >> >> situation before switching, here.
>> >> >> > >> >> >>
>> >> >> > >> >> >> In the context of writing the switch, it looks like struct azx isn't
>> >> >> > >> >> >> allocated by the time azx_vs_set_state accesses it [1,2]; racing with
>> >> >> > >> >> >> azx_codec_create?
>> >> >> > >> >> >
>> >> >> > >> >> > It was allocated, but it wasn't assigned properly in pci drvdata.
>> >> >> > >> >> >
>> >> >> > >> >> > Below is the revised patch.  Just moved pci_set_drvdata() before
>> >> >> > >> >> > register_vga_switcheroo().  Could you retest with it?
>> >> >> > >> >>
>> >> >> > >> >> Superb; this addresses the oops.
>> >> >> > >> >
>> >> >> > >> > OK, I'll queue it to sound tree for 3.8 kernel with Cc to stable.
>> >> >> > >> >
>> >> >> > >> >> ~1 second after the DGPU is put into D3, I still often see "hda-intel:
>> >> >> > >> >> spurious response 0x0:0x0, last cmd=0x170500":
>> >> >> > >> >> http://quora.org/2012/hda-switch-spurious.txt
>> >> >> > >> >
>> >> >> > >> > Hm, it's not clear who triggers these messages.  I'll try to check the
>> >> >> > >> > code paths.
>> >> >> > >> >
>> >> >> > >> >> Presumably this implies the read of the ring-buffer pointer returned
>> >> >> > >> >> 0xffffffff, so the HDA driver understands the pointer to have wrapped
>> >> >> > >> >> and processes the 191 unwritten entries?
>> >> >> > >> >
>> >> >> > >> > Good point.  Actually there is one bug that looks obviously wrong
>> >> >> > >> > (writing 32bit value to CORBWP).  Maybe it has been working just
>> >> >> > >> > because writing CORBRP doesn't influence except for the reset bit.
>> >> >> > >> >
>> >> >> > >> > Reading CORBWP as a byte is OK, but this could be better in a word so
>> >> >> > >> > that we can check 0xffff as invalid.
>> >> >> > >> >
>> >> >> > >> > A test patch is below.  Hopefully this improves the situation...
>> >> >> > >>
>> >> >> > >> I'll check this out tomorrow and also instrument the code to get a
>> >> >> > >> backtrace, since there may still be an underlying race with the
>> >> >> > >> previous patches:
>> >> >> >
>> >> >> > [...]
>> >> >> >
>> >> >> > > That's odd.  The Cirrus one (0000:00:1b.0) must be independent from
>> >> >> > > the vga switcheroo things for Nvidia...
>> >> >> > >
>> >> >> > > The patch below is the revised patch of the first one.  Now the vga
>> >> >> > > switcheroo registration is done before the video controller D3 check,
>> >> >> > > so the race should be smaller.
>> >> >> >
>> >> >> > This patch improves things further of course; a major improvement over
>> >> >> > without. ~15% of the time, I still get the 'spurious response'
>> >> >> > messages in this callpath:
>> >> >>
>> >> >> A possible scenario is that the graphics went in D3 before probing
>> >> >> hd-audio, and the hd-audio continues to initialize the hardware
>> >> >> without knowing the graphics counterpart is disabled.
>> >> >>
>> >> >> There is a code check_hdmi_disabled() in hda_intel.c that checks the
>> >> >> availability of the video driver, and it might be that this doesn't
>> >> >> work as expected...
>> >> >
>> >> > I think I understand this path.  You are setting "OFF", right?
>> >> > This will set the audio client OFF before can_switch() is called.
>> >> > Thus it can be called even before the probing process finished.
>> >> >
>> >> > In short, wait_for_completion() must be put at the beginning of
>> >> > azx_vs_set_state() in addition to azx_vs_can_switch().
>> >> >
>> >> > The revised patch is attached below.  Hopefully this sorts out all
>> >> > races.
>> >>
>> >> This works great and instead, I get "Cannot lock devices!" sometimes
>> >> (see http://quora.org/2012/hda-switch-lock.txt ).
>> >
>> > This means that some apps (likely udev, PulseAudio or whatever) are
>> > accessing sound devices during you turn off the audio / D-GPU.  It
>> > wouldn't be too big trouble, but it's still a bit risky.
>>
>> It looks like this prevents suspending, since the waiting process is
>> sleeping uninterruptably in snd_power_wait (updated
>> http://quora.org/2012/hda-switch-lock.txt with the details).
>
> Grrr, yet missing piece.  The patch below should fix it.
>
> Takashi
>
> ---
> From: Takashi Iwai <tiwai@suse.de>
> Subject: [PATCH] ALSA: hda - Avoid doubly suspend after vga switcheroo
>
> The HD-audio driver artificially calls the suspend and the resume code
> path in the VGA switcheroo state changes.  When a machine goes to
> suspend, it tries to suspend the device again, and it stalls at
> snd_power_wait().
>
> This patch adds checks whether the devices were already in (forced)
> suspend in PM callbacks for avoiding the doubly suspend.

So far, so good. I haven't had chance to test it deeper, but will drop
a mail if I find an issue, which seems unlikely from initial testing.

Excellent work and thanks!

Dan
--
Daniel J Blueman
