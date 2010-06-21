Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259Ab0FUUKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:10:44 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:59947 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab0FUUKm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:10:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=MXZ9nSL0HL2qC7rZV5prsDuME1q2XkHct17Vab30wnAp8LCG475LSJ06PZxzuLvcnQ
         +Zo/F7RLWyKHrr1mRR5du6iMKh92OeoE0SCGQsN+SGI345zlKgV8fKmM+QvOmiHfL64Z
         9AOqL5FF2P4eEEDPMNOsrVF4110S/azestVhU=
MIME-Version: 1.0
Reply-To: linux@schou.dk
In-Reply-To: <AANLkTikCGzUKe9Fy1d0xhberqGFe71lvrQbg5gkQzgf1@mail.gmail.com>
References: <AANLkTimO5PXmJiIPDw82MTA53mLSl-OC0e1SOEh7v8pH@mail.gmail.com> 
	<1276972298.22889.16.camel@obelisk.thedillows.org> <AANLkTimwZFNLBNJWODyzKXwx9CbIorg3OCA53XZchkeN@mail.gmail.com> 
	<1277043970.22889.45.camel@obelisk.thedillows.org> <AANLkTikBTMq3d-Ov65wYLJ_Vw-7Jde4AOwfXcEPB0wLr@mail.gmail.com> 
	<1277129180.22889.64.camel@obelisk.thedillows.org> <AANLkTikW71h7ABVXY21pLL9AeOlmRTfVaSTjJ_6Ma0_R@mail.gmail.com> 
	<AANLkTikCGzUKe9Fy1d0xhberqGFe71lvrQbg5gkQzgf1@mail.gmail.com>
From: Hans Schou <linux@schou.dk>
Date: Mon, 21 Jun 2010 22:10:20 +0200
X-Google-Sender-Auth: aSmK8HMgfel2Y70NjQKRcaBCG4Y
Message-ID: <AANLkTikPW9j4H15gq7nl0Tb213R15uIQAnSDi_cTOJre@mail.gmail.com>
Subject: Re: PROBLEM: SIS7019 stops recording after 42 min
To: David Dillow <dave@thedillows.org>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/21 Hans Schou <linux@schou.dk>:

> I have just started:
>  arecord -B 1000000 -F 500000 -c 1 -r 44100 -f S16 -M -D hw:0,0 -v arec.wav

It gave a file size of 258822944 bytes. Almost 50 min:
  echo "258822944/(2*60*44100)" | bc -ql
48.90

This is the longest recording I have made on this hardware.

I have this running now:
+ arecord -B 200000 -F 100000 -c 1 -r 44100 -f S16 -M -D hw:0,0 -v arec.wav
Recording WAVE 'arec.wav' : Signed 16 bit Little Endian, Rate 44100 Hz, Mono
Hardware PCM card 0 'SiS7019' device 0 subdevice 0
Its setup is:
  stream       : CAPTURE
  access       : MMAP_INTERLEAVED
  format       : S16_LE
  subformat    : STD
  channels     : 1
  rate         : 44100
  exact rate   : 44100 (44100/1)
  msbits       : 16
  buffer_size  : 8820
  period_size  : 4410
  period_time  : 100000
  tick_time    : 0
  tstamp_mode  : NONE
  period_step  : 1
  sleep_min    : 0
  avail_min    : 4410
  xfer_align   : 4410
  start_threshold  : 1
  stop_threshold   : 8820
  silence_threshold: 0
  silence_size : 0
  boundary     : 1244678400

and no overrun within 2 min.

/hans
