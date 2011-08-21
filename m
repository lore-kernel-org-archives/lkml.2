Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab1HUStP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 14:49:15 -0400
Received: from lucidpixels.com ([72.73.18.11]:35998 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894Ab1HUStL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 14:49:11 -0400
Date: Sun, 21 Aug 2011 14:49:08 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: kernel 3.0: BUG: soft lockup: find_get_pages+0x51/0x110
In-Reply-To: <201108211959.27207.maciej.rutecki@gmail.com>
Message-ID: <alpine.DEB.2.02.1108211446580.14539@p34.internal.lan>
References: <alpine.DEB.2.02.1108151241370.32349@p34.internal.lan> <201108211959.27207.maciej.rutecki@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 21 Aug 2011, Maciej Rutecki wrote:

> On poniedzia?ek, 15 sierpnia 2011 o 18:43:22 Justin Piszcz wrote:
>> Hello,
>>
>> What causes this(?) -- am I out of memory(?) or is this a kernel bug?
>>
>> [104147.717815] BUG: soft lockup - CPU#13 stuck for 23s! [kswapd0:934]
>> [104147.717820] Modules linked in: dm_mod tcp_diag parport_pc ppdev lp
>> parport inet_diag ub pl2303 ftdi_sio snd_usb_audio snd_pcm_oss
>> snd_mixer_oss snd_pcm snd_page_alloc snd_hwdep snd_usbmidi_lib
>> snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event
>> snd_seq snd_timer snd_seq_device snd soundcore usbserial cdc_acm nouveau
>> serio_raw ttm drm_kms_helper drm agpgart i2c_algo_bit mxm_wmi wmi
>> i7core_edac edac_core video [104147.717872] CPU 13
>> [104147.717874] Modules linked in: dm_mod tcp_diag parport_pc ppdev lp
>> parport inet_diag ub pl2303 ftdi_sio snd_usb_audio snd_pcm_oss
>> snd_mixer_oss snd_pcm snd_page_alloc snd_hwdep snd_usbmidi_lib
>> snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event
>> snd_seq snd_timer snd_seq_device snd soundcore usbserial cdc_acm nouveau
>> serio_raw ttm drm_kms_helper drm agpgart i2c_algo_bit mxm_wmi wmi
>> i7core_edac edac_core video [104147.717916]
>> [104147.717921] Pid: 934, comm: kswapd0 Not tainted 3.0.0 #4 Supermicro
>> X8DTH-i/6/iF/6F/X8DTH [104147.717928] RIP: 0010:[<ffffffff81081f71>]
>> [<ffffffff81081f71>] find_get_pages+0x51/0x110 [104147.717940] RSP:
>> 0018:ffff880626127ba0  EFLAGS: 00000246
> [...]
>
> It's regression? 2.6.39 works OK?

Hello,

It appears to have been occurring for sometime (although not since I have
enabled frame pointers in the kernel to debug the problem):

Kernels: 2.6.39.2, 3.0, 3.0.1.

kern.log:Jul 30 02:10:40 p34 kernel: [27760.840979] BUG: soft lockup - CPU#10 stuck for 23s! [kswapd1:946]
kern.log:Jul 30 02:11:08 p34 kernel: [27788.799309] BUG: soft lockup - CPU#10 stuck for 22s! [kswapd1:946]
kern.log:Jul 30 02:15:35 p34 kernel: [28000.480936] BUG: soft lockup - CPU#10 stuck for 21s! [kswapd1:946]
kern.log:Jul 30 02:15:35 p34 kernel: [28028.438740] BUG: soft lockup - CPU#10 stuck for 22s! [kswapd1:946]
kern.log:Jul 30 02:15:52 p34 kernel: [28072.364088] BUG: soft lockup - CPU#10 stuck for 21s! [kswapd1:946]
kern.log:Jul 30 02:16:20 p34 kernel: [28100.310535] BUG: soft lockup - CPU#10 stuck for 22s! [kswapd1:946]
kern.log:Jul 30 02:16:48 p34 kernel: [28128.260612] BUG: soft lockup - CPU#10 stuck for 22s! [kswapd1:946]
kern.log:Aug 12 01:46:47 p34 kernel: [330481.760506] BUG: soft lockup - CPU#7 stuck for 23s! [kswapd1:935]
kern.log:Aug 12 01:47:15 p34 kernel: [330509.718618] BUG: soft lockup - CPU#7 stuck for 23s! [kswapd1:935]
kern.log:Aug 15 11:57:38 p34 kernel: [104147.717815] BUG: soft lockup - CPU#13 stuck for 23s! [kswapd0:934]
kern.log:Aug 18 06:15:28 p34 kernel: [50020.901890] BUG: soft lockup - CPU#4 stuck for 22s! [kswapd0:934]

Justin.

