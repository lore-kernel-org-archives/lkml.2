Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab2DJGyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 02:54:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41858 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab2DJGy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 02:54:29 -0400
Message-ID: <4F83D91B.8030501@canonical.com>
Date: Tue, 10 Apr 2012 08:54:19 +0200
From: David Henningsson <david.henningsson@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
CC: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] ALSA: hda - clean up CX20549 test mixer setup
References: <s5hk41ufe2j.wl%tiwai@suse.de> <1333719260-14504-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de> <1333719260-14504-7-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
In-Reply-To: <1333719260-14504-7-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2012 03:34 PM, Michael Karcher wrote:
> name pins consistently (MIC1/LINE1/HP-OUT/CD) on all controls
> affecting those pins.

If this is a test mixer only, so maybe it does not matter that much, but 
anyway:

Loopback controls are usually labeled

"Line Playback Volume"
"Mic Playback Volume"

And outputs:

"Headphone Playback Volume"

For line outputs, I'm not sure if the right thing is

"Front Playback Volume",
"Line-Out Playback Volume", or
"Line Out Playback Volume"


> remove duplicate SET_AMP_GAIN_MUTE to 0x17/index 0 and 0x17/index 1
>
> really select MIC1, not Mixer out for recording
>
> "Mixer out" for recording is not a "pin", adjust comment
>
> Signed-off-by: Michael Karcher<kernel@mkarcher.dialup.fu-berlin.de>
> ---
>   sound/pci/hda/patch_conexant.c |   38 +++++++++++++++++---------------------
>   1 files changed, 17 insertions(+), 21 deletions(-)
>
> diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
> index 8fe9f9d..a36488d 100644
> --- a/sound/pci/hda/patch_conexant.c
> +++ b/sound/pci/hda/patch_conexant.c
> @@ -930,10 +930,10 @@ static const struct snd_kcontrol_new cxt5045_test_mixer[] = {
>   	/* Output controls */
>   	HDA_CODEC_VOLUME("Speaker Playback Volume", 0x10, 0x0, HDA_OUTPUT),
>   	HDA_CODEC_MUTE("Speaker Playback Switch", 0x10, 0x0, HDA_OUTPUT),
> -	HDA_CODEC_VOLUME("Node 11 Playback Volume", 0x11, 0x0, HDA_OUTPUT),
> -	HDA_CODEC_MUTE("Node 11 Playback Switch", 0x11, 0x0, HDA_OUTPUT),
> -	HDA_CODEC_VOLUME("Node 12 Playback Volume", 0x12, 0x0, HDA_OUTPUT),
> -	HDA_CODEC_MUTE("Node 12 Playback Switch", 0x12, 0x0, HDA_OUTPUT),
> +	HDA_CODEC_VOLUME("HP-OUT Playback Volume", 0x11, 0x0, HDA_OUTPUT),
> +	HDA_CODEC_MUTE("HP-OUT Playback Switch", 0x11, 0x0, HDA_OUTPUT),
> +	HDA_CODEC_VOLUME("LINE1 Playback Volume", 0x12, 0x0, HDA_OUTPUT),
> +	HDA_CODEC_MUTE("LINE1 Playback Switch", 0x12, 0x0, HDA_OUTPUT),
>   	
>   	/* Modes for retasking pin widgets */
>   	CXT_PIN_MODE("HP-OUT pin mode", 0x11, CXT_PIN_DIR_INOUT),
> @@ -944,16 +944,16 @@ static const struct snd_kcontrol_new cxt5045_test_mixer[] = {
>
>   	/* Loopback mixer controls */
>
> -	HDA_CODEC_VOLUME("Mixer-1 Volume", 0x17, 0x0, HDA_INPUT),
> -	HDA_CODEC_MUTE("Mixer-1 Switch", 0x17, 0x0, HDA_INPUT),
> -	HDA_CODEC_VOLUME("Mixer-2 Volume", 0x17, 0x1, HDA_INPUT),
> -	HDA_CODEC_MUTE("Mixer-2 Switch", 0x17, 0x1, HDA_INPUT),
> -	HDA_CODEC_VOLUME("Mixer-3 Volume", 0x17, 0x2, HDA_INPUT),
> -	HDA_CODEC_MUTE("Mixer-3 Switch", 0x17, 0x2, HDA_INPUT),
> -	HDA_CODEC_VOLUME("Mixer-4 Volume", 0x17, 0x3, HDA_INPUT),
> -	HDA_CODEC_MUTE("Mixer-4 Switch", 0x17, 0x3, HDA_INPUT),
> -	HDA_CODEC_VOLUME("Mixer-5 Volume", 0x17, 0x4, HDA_INPUT),
> -	HDA_CODEC_MUTE("Mixer-5 Switch", 0x17, 0x4, HDA_INPUT),
> +	HDA_CODEC_VOLUME("PCM Volume", 0x17, 0x0, HDA_INPUT),
> +	HDA_CODEC_MUTE("PCM Switch", 0x17, 0x0, HDA_INPUT),
> +	HDA_CODEC_VOLUME("MIC1 pin Volume", 0x17, 0x1, HDA_INPUT),
> +	HDA_CODEC_MUTE("MIC1 pin Switch", 0x17, 0x1, HDA_INPUT),
> +	HDA_CODEC_VOLUME("LINE1 pin Volume", 0x17, 0x2, HDA_INPUT),
> +	HDA_CODEC_MUTE("LINE1 pin Switch", 0x17, 0x2, HDA_INPUT),
> +	HDA_CODEC_VOLUME("HP-OUT pin Volume", 0x17, 0x3, HDA_INPUT),
> +	HDA_CODEC_MUTE("HP-OUT pin Switch", 0x17, 0x3, HDA_INPUT),

Eh, is there a loopback control from the headphone?

> +	HDA_CODEC_VOLUME("CD pin Volume", 0x17, 0x4, HDA_INPUT),
> +	HDA_CODEC_MUTE("CD pin Switch", 0x17, 0x4, HDA_INPUT),
>   	{
>   		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
>   		.name = "Input Source",
> @@ -985,10 +985,6 @@ static const struct hda_verb cxt5045_test_init_verbs[] = {
>   	{0x13, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT},
>   	{0x18, AC_VERB_SET_DIGI_CONVERT_1, 0},
>
> -	/* Start with output sum widgets muted and their output gains at min */
> -	{0x17, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(0)},
> -	{0x17, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(1)},
> -
>   	/* Unmute retasking pin widget output buffers since the default
>   	 * state appears to be output.  As the pin mode is changed by the
>   	 * user the pin mode control will take care of enabling the pin's
> @@ -1003,11 +999,11 @@ static const struct hda_verb cxt5045_test_init_verbs[] = {
>   	/* Set ADC connection select to match default mixer setting (mic1
>   	 * pin)
>   	 */
> -	{0x1a, AC_VERB_SET_CONNECT_SEL, 0x00},
> -	{0x17, AC_VERB_SET_CONNECT_SEL, 0x00},
> +	{0x1a, AC_VERB_SET_CONNECT_SEL, 0x01},
> +	{0x17, AC_VERB_SET_CONNECT_SEL, 0x01},
>
>   	/* Mute all inputs to mixer widget (even unconnected ones) */
> -	{0x17, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(0)}, /* Mixer pin */
> +	{0x17, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(0)}, /* Mixer */
>   	{0x17, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(1)}, /* Mic1 pin */
>   	{0x17, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(2)}, /* Line pin */
>   	{0x17, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(3)}, /* HP pin */



-- 
David Henningsson, Canonical Ltd.
http://launchpad.net/~diwic
