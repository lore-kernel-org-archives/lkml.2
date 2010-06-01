Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab0FAMZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 08:25:48 -0400
Received: from smtp104.sbc.mail.re3.yahoo.com ([66.196.96.80]:48102 "HELO
	smtp104.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755133Ab0FAMZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 08:25:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ameritech.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=SgqJjP6/pC6ohuN5Xjn/GynpH9aeY8PlCwH1YSzIZhBYZn1gYs+WUBfuOeB5q4IRUI2gXxC/BrXWimw/ViUxDucqe6v7eN1nMBup5q1h+lw2/Vq8t6rrK8DAoPJji3gp75y/YvzyU0+u6KBExYuygjgdDoVg2MgLZkLMmJPL6fA=  ;
X-Yahoo-SMTP: YbXY4QiswBDIwUvpBHqjGlM60e.1oHNBgoHih_YhU30ZyW4-
X-YMail-OSG: ELoZEjQVM1nin.kFLbfyNJBl0kByeDTxu7NAFgodOTkL00JoyBEFNhh_
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4C04FC3F.70905@ameritech.net>
Date: Tue, 01 Jun 2010 08:25:35 -0400
From: "F. Heitkamp" <heitkamp@ameritech.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Giuliano Pochini <pochini@shiny.it>
CC: alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
       linux-audio-user@lists.linuxaudio.org,
       Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org,
       alsa-user@lists.sourceforge.net
Subject: Re: [Alsa-user] [alsa-devel] Crash 2.6.32.x, Echo 3G, Alsa, SCSI
References: <73211.74714.qm@web180714.mail.sp1.yahoo.com>	<4B684513.8090201@ladisch.de> <20100202230911.71e8b600@Jay>	<4C040864.8010205@ameritech.net> <20100531225936.4a9344df@Jay>
In-Reply-To: <20100531225936.4a9344df@Jay>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/10 16:59, Giuliano Pochini wrote:
> On Mon, 31 May 2010 15:05:08 -0400
> "F. Heitkamp"<heitkamp@ameritech.net>  wrote:
>
>    
>> On 02/02/10 17:09, Giuliano Pochini wrote:
>>      
>>> On Tue, 02 Feb 2010 16:30:27 +0100
>>> Clemens Ladisch<clemens@ladisch.de>   wrote:
>>>
>>>
>>>        
>>>> Frederick V Heitkamp wrote:
>>>>
>>>>          
>>>>> Repeatable Hard Crash.
>>>>> What else do I need to provide?
>>>>>            
> [...]
>    
>>> Signed-off-by: Giuliano Pochini<pochini@shiny.it>
>>>
>>> --- alsa-driver-1.0.22.1/alsa-kernel/pci/echoaudio/echoaudio.c__orig	2010-02-02 22:37:33.000000000 +0100
>>> +++ alsa-driver-1.0.22.1/alsa-kernel/pci/echoaudio/echoaudio.c	2010-02-02 22:44:03.000000000 +0100
>>> @@ -1821,7 +1821,9 @@ static irqreturn_t snd_echo_interrupt(in
>>>    	/* The hardware doesn't tell us which substream caused the irq,
>>>    	thus we have to check all running substreams. */
>>>    	for (ss = 0; ss<   DSP_MAXPIPES; ss++) {
>>> -		if ((substream = chip->substream[ss])) {
>>> +		substream = chip->substream[ss];
>>> +		if (substream&&   ((struct audiopipe *)substream->runtime->
>>> +				private_data)->state == PIPE_STATE_STARTED) {
>>>    			period = pcm_pointer(substream) /
>>>    				substream->runtime->period_size;
>>>    			if (period != chip->last_period[ss]) {
>>>
>>>
>>>
>>>        
>> I've tried some newer kernels.  Still having problems with the echo 3G.
>> This is kernel version:
>> 2.6.32.13.  The above patches posted to the linux kernel list seemed to
>> get rid of the crashes, but evidently did not go into the main kernel tree.
>>      
> Indeed. I've just checked 2.6.33 and the patch isn't there. It's in 2.6.34.
>
> If you need 2.6.32.13 you can apply the above patch to the kernel tree or
> download ftp://ftp.alsa-project.org/pub/driver/alsa-driver-1.0.23.tar.bz2,
> otherwise just use the latest kernel.
>    
I tried 2.6.34.   I have jack 1.9..5 installed.  I was able to use 
rhythmbox to play mp3s.  I could not use the echomixer app.  It complained
about a channels mismatch.

My goal is to be able to plug in a MIDI keyboard, or USB guitar 
interface and play along with songs etc.

I plugged in a MIDI keyboard, "/proc/asound/cards" showed the keyboard 
was recognized.  The keyboard has a USB and MIDI interface.
I am not sure if they both work at the same time.  I had the MIDI cable 
plugged into the Gina3G, but I could not tell if the keyboard was 
recognized.
I compiled csound5.  When I engaged it the system immediately froze and 
started spitting out:

5831.768583] set_audio_format[0] = 86
[ 5831.768610] pcm_trigger start
[ 5831.768611] start_transport 4001
[ 5831.790538] pcm_trigger stop
[ 5831.790539] stop_transport 4001
[ 5831.790576] Prepare rate=48000 format=10 channels=2
[ 5831.790578] set_audio_format[14] = 7
[ 5831.790579] Prepare rate=48000 format=10 channels=6
[ 5831.790580] set_audio_format[0] = 86
[ 5831.790608] pcm_trigger start
[ 5831.790609] start_transport 4001
[ 5831.812538] pcm_trigger stop
[ 5831.812540] stop_transport 4001
[ 5831.812576] Prepare rate=48000 format=10 channels=2
[ 5831.812577] set_audio_format[14] = 7
[ 5831.812578] Prepare rate=48000 format=10 channels=6
[ 5831.812580] set_audio_format[0] = 86
[ 5831.812607] pcm_trigger start
[ 5831.812608] start_transport 4001
[ 5831.834537] pcm_trigger stop
[ 5831.834539] stop_transport 4001
[ 5831.834576] Prepare rate=48000 format=10 channels=2
[ 5831.834577] set_audio_format[14] = 7
[ 5831.834579] Prepare rate=48000 format=10 channels=6
[ 5831.834580] set_audio_format[0] = 86
[ 5831.834607] pcm_trigger start
[ 5831.834608] start_transport 4001
[ 5831.856536] pcm_trigger stop
[ 5831.856538] stop_transport 4001
[ 5831.856574] Prepare rate=48000 format=10 channels=2
[ 5831.856576] set_audio_format[14] = 7
[ 5831.856577] Prepare rate=48000 format=10 channels=6
[ 5831.856579] set_audio_format[0] = 86
[ 5831.856606] pcm_trigger start
[ 5831.856607] start_transport 4001
[ 5831.878536] pcm_trigger stop
[ 5831.878538] stop_transport 4001
[ 5831.878575] Prepare rate=48000 format=10 channels=2
[ 5831.878576] set_audio_format[14] = 7
[ 5831.878578] Prepare rate=48000 format=10 channels=6
[ 5831.878579] set_audio_format[0] = 86
[ 5831.878606] pcm_trigger start
[ 5831.878607] start_transport 4001
[ 5831.900535] pcm_trigger stop
[ 5831.900537] stop_transport 4001
[ 5831.900575] Prepare rate=48000 format=10 channels=2
[ 5831.900576] set_audio_format[14] = 7
[ 5831.900578] Prepare rate=48000 format=10 channels=6
[ 5831.900579] set_audio_format[0] = 86
[ 5831.900606] pcm_trigger start
[ 5831.900607] start_transport 4001
[ 5831.922535] pcm_trigger stop
[ 5831.922537] stop_transport 4001
[ 5831.922576] Prepare rate=48000 format=10 channels=2
[ 5831.922578] set_audio_format[14] = 7
[ 5831.922579] Prepare rate=48000 format=10 channels=6
[ 5831.922580] set_audio_format[0] = 86
[ 5831.922608] pcm_trigger start
[ 5831.922609] start_transport 4001
[ 5831.944535] pcm_trigger stop
[ 5831.944537] stop_transport 4001
[ 5831.944575] Prepare rate=48000 format=10 channels=2
[ 5831.944576] set_audio_format[14] = 7
[ 5831.944578] Prepare rate=48000 format=10 channels=6
[ 5831.944579] set_audio_format[0] = 86
[ 5831.944607] pcm_trigger start
[ 5831.944608] start_transport 4001
[ 5831.966536] pcm_trigger stop
[ 5831.966538] stop_transport 4001
[ 5831.966576] Prepare rate=48000 format=10 channels=2
[ 5831.966578] set_audio_format[14] = 7
[ 5831.966579] Prepare rate=48000 format=10 channels=6
[ 5831.966580] set_audio_format[0] = 86
[ 5831.966609] pcm_trigger start
[ 5831.966610] start_transport 4001
[ 5831.988533] pcm_trigger stop
[ 5831.988535] stop_transport 4001
[ 5831.988572] Prepare rate=48000 format=10 channels=2
[ 5831.988574] set_audio_format[14] = 7
[ 5831.988576] Prepare rate=48000 format=10 channels=6
[ 5831.988577] set_audio_format[0] = 86
[ 5831.988604] pcm_trigger start
[ 5831.988605] start_transport 4001
[ 5832.010532] pcm_trigger stop
[ 5832.010534] stop_transport 4001
[ 5832.010572] Prepare rate=48000 format=10 channels=2
[ 5832.010574] set_audio_format[14] = 7
[ 5832.010575] Prepare rate=48000 format=10 channels=6
[ 5832.010576] set_audio_format[0] = 86
[ 5832.010604] pcm_trigger start
[ 5832.010605] start_transport 4001
[ 5832.032531] pcm_trigger stop
[ 5832.032533] stop_transport 4001
[ 5832.032569] Prepare rate=48000 format=10 channels=2
[ 5832.032570] set_audio_format[14] = 7
[ 5832.032572] Prepare rate=48000 format=10 channels=6
[ 5832.032573] set_audio_format[0] = 86
[ 5832.032600] pcm_trigger start
[ 5832.032601] start_transport 4001
[ 5832.054532] pcm_trigger stop
[ 5832.054534] stop_transport 4001
[ 5832.054571] Prepare rate=48000 format=10 channels=2
[ 5832.054573] set_audio_format[14] = 7
[ 5832.054574] Prepare rate=48000 format=10 channels=6
[ 5832.054575] set_audio_format[0] = 86
[ 5832.054602] pcm_trigger start
[ 5832.054603] start_transport 4001
[ 5832.076529] pcm_trigger stop
[ 5832.076531] stop_transport 4001
[ 5832.076567] Prepare rate=48000 format=10 channels=2
[ 5832.076568] set_audio_format[14] = 7
[ 5832.076570] Prepare rate=48000 format=10 channels=6
[ 5832.076571] set_audio_format[0] = 86
[ 5832.076598] pcm_trigger start
[ 5832.076599] start_transport 4001
[ 5832.098530] pcm_trigger stop
[ 5832.098532] stop_transport 4001
[ 5832.098568] Prepare rate=48000 format=10 channels=2
[ 5832.098569] set_audio_format[14] = 7
[ 5832.098570] Prepare rate=48000 format=10 channels=6
[ 5832.098571] set_audio_format[0] = 86
[ 5832.098599] pcm_trigger start
[ 5832.098600] start_transport 4001
[ 5832.120532] pcm_trigger stop
[ 5832.120533] stop_transport 4001
[ 5832.120573] Prepare rate=48000 format=10 channels=2
[ 5832.120575] set_audio_format[14] = 7
[ 5832.120576] Prepare rate=48000 format=10 channels=6
[ 5832.120577] set_audio_format[0] = 86
[ 5832.120606] pcm_trigger start
[ 5832.120607] start_transport 4001
[ 5832.142529] pcm_trigger stop
[ 5832.142530] stop_transport 4001
[ 5832.142569] Prepare rate=48000 format=10 channels=2
[ 5832.142570] set_audio_format[14] = 7
[ 5832.142571] Prepare rate=48000 format=10 channels=6
[ 5832.142573] set_audio_format[0] = 86
[ 5832.142600] pcm_trigger start
[ 5832.142601] start_transport 4001
[ 5832.164529] pcm_trigger stop
[ 5832.164530] stop_transport 4001
[ 5832.164568] Prepare rate=48000 format=10 channels=2
[ 5832.164569] set_audio_format[14] = 7
[ 5832.164571] Prepare rate=48000 format=10 channels=6
[ 5832.164572] set_audio_format[0] = 86
[ 5832.164599] pcm_trigger start
[ 5832.164600] start_transport 4001
[ 5832.186528] pcm_trigger stop
[ 5832.186529] stop_transport 4001
[ 5832.186567] Prepare rate=48000 format=10 channels=2
[ 5832.186568] set_audio_format[14] = 7
[ 5832.186570] Prepare rate=48000 format=10 channels=6
[ 5832.186571] set_audio_format[0] = 86
[ 5832.186601] pcm_trigger start
[ 5832.186602] start_transport 4001
[ 5832.208527] pcm_trigger stop
[ 5832.208528] stop_transport 4001
[ 5832.208564] Prepare rate=48000 format=10 channels=2
[ 5832.208566] set_audio_format[14] = 7
[ 5832.208567] Prepare rate=48000 format=10 channels=6
[ 5832.208569] set_audio_format[0] = 86
[ 5832.208596] pcm_trigger start
[ 5832.208597] start_transport 4001
[ 5832.230526] pcm_trigger stop
[ 5832.230527] stop_transport 4001
[ 5832.230565] Prepare rate=48000 format=10 channels=2
[ 5832.230566] set_audio_format[14] = 7
[ 5832.230567] Prepare rate=48000 format=10 channels=6
[ 5832.230568] set_audio_format[0] = 86
[ 5832.230596] pcm_trigger start
[ 5832.230597] start_transport 4001
[ 5832.252545] pcm_trigger stop
[ 5832.252547] stop_transport 4001
[ 5832.252583] Prepare rate=48000 format=10 channels=2
[ 5832.252584] set_audio_format[14] = 7
[ 5832.252586] Prepare rate=48000 format=10 channels=6
[ 5832.252587] set_audio_format[0] = 86
[ 5832.252614] pcm_trigger start
[ 5832.252615] start_transport 4001
[ 5832.274524] pcm_trigger stop
[ 5832.274526] stop_transport 4001
[ 5832.274561] Prepare rate=48000 format=10 channels=2
[ 5832.274563] set_audio_format[14] = 7
[ 5832.274564] Prepare rate=48000 format=10 channels=6
[ 5832.274565] set_audio_format[0] = 86
[ 5832.274593] pcm_trigger start
[ 5832.274594] start_transport 4001
[ 5832.296536] pcm_trigger stop
[ 5832.296538] stop_transport 4001
[ 5832.296576] Prepare rate=48000 format=10 channels=2
[ 5832.296577] set_audio_format[14] = 7
[ 5832.296578] Prepare rate=48000 format=10 channels=6
[ 5832.296579] set_audio_format[0] = 86
[ 5832.296606] pcm_trigger start
[ 5832.296607] start_transport 4001
[ 5832.318525] pcm_trigger stop
[ 5832.318527] stop_transport 4001
[ 5832.318566] Prepare rate=48000 format=10 channels=2
[ 5832.318567] set_audio_format[14] = 7
[ 5832.318569] Prepare rate=48000 format=10 channels=6
[ 5832.318570] set_audio_format[0] = 86
[ 5832.318598] pcm_trigger start
[ 5832.318599] start_transport 4001
[ 5832.340523] pcm_trigger stop
[ 5832.340524] stop_transport 4001
[ 5832.340563] Prepare rate=48000 format=10 channels=2
[ 5832.340564] set_audio_format[14] = 7
[ 5832.340566] Prepare rate=48000 format=10 channels=6
[ 5832.340567] set_audio_format[0] = 86
[ 5832.340594] pcm_trigger start
[ 5832.340595] start_transport 4001
[ 5832.362522] pcm_trigger stop
[ 5832.362524] stop_transport 4001
[ 5834.003252] SysRq : Terminate All Tasks
[ 5846.410995] pcm_close
[ 5846.410997] pcm_close  oc=2  cs=0  rs=1
[ 5846.410998] pcm_close2 oc=2  cs=0  rs=1
[ 5846.449499] Prepare rate=48000 format=10 channels=2
[ 5846.473577] set_audio_format[14] = 7
[ 5846.484293] Prepare rate=48000 format=10 channels=6
[ 5846.503645] set_audio_format[0] = 86
[ 5846.514449] pcm_trigger start
[ 5846.515307] start_transport 4001
[ 5846.533291] pcm_trigger stop
[ 5846.534001] stop_transport 4001
[ 5846.567444] pcm_hw_free(14)
[ 5846.568002] free_pipes: Pipe 14
[ 5846.585146] pcm_hw_freed
[ 5846.592757] pcm_hw_freed
[ 5846.600307] pcm_close
[ 5846.607086] pcm_close  oc=1  cs=0  rs=1
[ 5846.618528] pcm_close2 oc=1  cs=1  rs=1
[ 5846.630021] pcm_hw_free(0)
[ 5846.631001] free_pipes: Pipe 0
[ 5846.647193] pcm_hw_freed
[ 5846.654751] pcm_hw_freed
[ 5846.662303] pcm_close
[ 5846.669072] pcm_close  oc=0  cs=1  rs=1
[ 5846.680516] pcm_close2 oc=0  cs=1  rs=0
[ 5846.706051] uhci_hcd 0000:00:1d.2: release dev 4 ep81-INT, period 8, 
phase 4s
[ 5846.783378] [drm] Resetting GPU

>
>    

