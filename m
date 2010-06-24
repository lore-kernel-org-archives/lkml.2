Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab0FXC3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 22:29:42 -0400
Received: from smtp-out4.blueyonder.co.uk ([195.188.213.7]:57524 "EHLO
	smtp-out4.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753384Ab0FXC3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 22:29:41 -0400
Message-ID: <4C22C312.2030805@blueyonder.co.uk>
Date: Thu, 24 Jun 2010 03:29:38 +0100
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-GB; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5 ThunderBrowse/3.2.8.1
MIME-Version: 1.0
To: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       alsa-user@lists.sourceforge.net
CC: LKML Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.35-rc3 E-MU 0404 USB problem
References: <4C20B364.9060405@blueyonder.co.uk> <AANLkTikiVMjIcnXrCVS6UK1ln1NVUZc3pjSGIIFwSJkg@mail.gmail.com>
In-Reply-To: <AANLkTikiVMjIcnXrCVS6UK1ln1NVUZc3pjSGIIFwSJkg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/06/10 18:49, James Courtier-Dutton wrote:
> On 22 June 2010 13:58, Sid Boyce<sboyce@blueyonder.co.uk>  wrote:
>> I have an application using the on-board sound card mic which should send
>> it's data to the USB card for relay to a Sofweare Defined Radio as 2
>> quadrature signals digital (I/Q) for transmission.
>> On the receiving side it can take data from the Radio at up to 192K sample
>> rate -->  program -->  Speaker on the on-board sound card - that works fine.
>> Transmit fails, dmesg output with 48K sample rate set is:-
>> [509686.177169] ALSA sound/usb/clock.c:214: 6:2:3: endpoint lacks sample
>> rate attribute bit, cannot set.
>> [509686.187920] ALSA sound/usb/clock.c:214: 6:2:1: endpoint lacks sample
>> rate attribute bit, cannot set.
>> [509686.266905] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
>> [509686.330901] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
>> [509686.353775] ALSA sound/usb/clock.c:214: 6:2:7: endpoint lacks sample
>> rate attribute bit, cannot set.
>> [509686.394898] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
>> [509686.458886] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
>> [509686.522874] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
>> [509823.078594] ALSA sound/usb/clock.c:214: 6:2:3: endpoint lacks sample
>> rate attribute bit, cannot set.
>> [509823.091571] ALSA sound/usb/clock.c:214: 6:2:1: endpoint lacks sample
>> rate attribute bit, cannot set.
>> [509823.146811] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
>> [509823.202679] ALSA sound/usb/clock.c:214: 6:2:7: endpoint lacks sample
>> rate attribute bit, cannot set.
>> [509823.210807] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
>> [509823.274792] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
>> [509823.338782] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
>> [509823.402783] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
>> Regards
>> Sid.
>> --
>
> This device uses a global clock rate according to the data sheets.
> So, record rate must equal playback rate.
>
sample_rate = 48000                     # ADC hardware sample rate in 
Hertz receive from the radio.
name_of_sound_capt = "hw:2"             # E-MU 0404 USB audio as IQ 
capture (Receive)
name_of_sound_play = "hw:0"             # HDA Intel on-board to Speakers.
channel_i = 1                           # Soundcard index of in-phase 
channel:  0, 1, 2, ...
channel_q = 0                           # Soundcard index of quadrature 
channel:  0, 1, 2, ...

# TX I/Q Generation for Softrock
name_of_mic_play = "hw:2"               # E-MU 0404 USB audio for IQ 
output sent to the Radio for transmit (Mic --> program --> E-MU --> 
transmitter).
mic_playback_rate = 48000
mic_play_chan_I = 1
mic_play_chan_Q = 0
microphone_name = "plughw:0"            # HDA Intel on-board sound
mic_channel_I = 0                       # Soundcard index of mic audio 
channel
mic_channel_Q = 1                       # Soundcard index of ignored channel
mic_sample_rate = 48000         # Microphone sample rate in Hertz
mic_max_sample = 25535
add_imd_button = 1

All sample rates set to 48K.
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

