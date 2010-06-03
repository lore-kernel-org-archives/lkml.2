Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab0FCEyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 00:54:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:2867 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab0FCEyT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 00:54:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=dolBkY5MAncxAlAFX9tHd73AYJQCmJIxj3cYf78MgTnv8q9zIJ8+0Ub+tF+X4Qu7K
	tjLE+c6/PumPp6ymTqbSA==
MIME-Version: 1.0
In-Reply-To: <20100603031842.GB11311@gvim.org>
References: <AANLkTik_4ezDAQoAQjkpEgwD9SLKeOjDzy2H7T2v6uCP@mail.gmail.com>
	<Pine.LNX.4.44L0.1005292026080.6300-100000@netrider.rowland.org>
	<AANLkTikxws5kmFhnBO1MLzE65ETka3Jy0R5ayAKTS1Lc@mail.gmail.com>
	<201005312338.55109.rjw@sisk.pl>
	<20100531232617.GF31155@gvim.org>
	<20100601090737.4bc243d9@schatten.dmk.lab>
	<20100601140519.GC1281@gvim.org>
	<AANLkTikF-B23_UWG1O3tlBl4m8NStAJllGhhevNhYZT6@mail.gmail.com>
	<20100602133910.GA9106@gvim.org>
	<AANLkTilSU79cnBODXFokzIPB1hRcZBxbwTgTQ59MeKcK@mail.gmail.com>
	<20100603031842.GB11311@gvim.org>
Date: Wed, 2 Jun 2010 21:54:15 -0700
Message-ID: <AANLkTiks7sQBbDnN6QrtGVqSXLob1qCs7VA12LZAWnfM@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Brian Swetland <swetland@google.com>
To: markgross@thegnar.org
Cc: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>, 640e9920@gmail.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 8:18 PM, mark gross <640e9920@gmail.com> wrote:
> On Wed, Jun 02, 2010 at 02:58:30PM -0700, Arve Hjønnevåg wrote:
>>
>> The list is not short. You have all the inactive and active
>> constraints on the same list. If you change it to a two level list
>> though, the list of unique values (which is the list you have to walk)
>> may be short enough for a tree to be overkill.
>
> what have you seen in practice from the wake-lock stats?
>
> I'm having a hard time seeing where you could get more than just a
> handfull.  However; one could go to a dual list (like the scheduler) and
> move inactive nodes from an active to inactive list, or we could simply
> remove them from the list uppon inactivity.  which would would well
> after I change the api to have the client allocate the memory for the
> nodes...  BUT, if your moving things in and out of a list a lot, I'm not
> sure the break even point where changing the structure helps.
>
> We'll need to try it.
>
> I think we will almost never see more than 10 list elements.
>
> --mgross
>
>

I see about 80 (based on the batteryinfo dump) on my Nexus One
(QSD8250, Android Froyo):

  Kernel Wake lock "event5-86": (nothing executed)
  Kernel Wake lock "PowerManagerService": 4m 27s 994ms  (453 times) realtime
  Kernel Wake lock "event4-92": 72ms  (10 times) realtime
  Kernel Wake lock "AudioHardwareQSDIn": (nothing executed)
  Kernel Wake lock "event4-87": (nothing executed)
  Kernel Wake lock "event5-82": (nothing executed)
  Kernel Wake lock "event2-87": (nothing executed)
  Kernel Wake lock "alarm_rtc": 21s 882ms  (186 times) realtime
  Kernel Wake lock "vdec_suspend": (nothing executed)
  Kernel Wake lock "event6-87": (nothing executed)
  Kernel Wake lock "event0-91": (nothing executed)
  Kernel Wake lock "SMD_DS": 30s 938ms  (53 times) realtime
  Kernel Wake lock "event6-91": (nothing executed)
  Kernel Wake lock "KeyEvents": 398ms  (3226 times) realtime
  Kernel Wake lock "qmi1": (nothing executed)
  Kernel Wake lock "mmc_delayed_work": (nothing executed)
  Kernel Wake lock "event3-82": (nothing executed)
  Kernel Wake lock "event3-92": 58ms  (6 times) realtime
  Kernel Wake lock "SMD_RPCCALL": 295ms  (1756 times) realtime
  Kernel Wake lock "SMD_DATA6": (nothing executed)
  Kernel Wake lock "audio_pcm_idle": 3s 99ms  (1 times) realtime
  Kernel Wake lock "serial-debug": (nothing executed)
  Kernel Wake lock "event6-82": (nothing executed)
  Kernel Wake lock "event3-86": (nothing executed)
  Kernel Wake lock "event2-82": (nothing executed)
  Kernel Wake lock "i2c": (nothing executed)
  Kernel Wake lock "event2-86": (nothing executed)
  Kernel Wake lock "event5-87": (nothing executed)
  Kernel Wake lock "event4-86": (nothing executed)
  Kernel Wake lock "event5-92": 4ms  (21 times) realtime
  Kernel Wake lock "rpc_server": (nothing executed)
  Kernel Wake lock "power-supply": 527ms  (8 times) realtime
  Kernel Wake lock "radio-interface": 10s 11ms  (10 times) realtime
  Kernel Wake lock "event6-86": (nothing executed)
  Kernel Wake lock "deleted_wake_locks": 203ms  (214 times) realtime
  Kernel Wake lock "qmi0": (nothing executed)
  Kernel Wake lock "event2-91": (nothing executed)
  Kernel Wake lock "event4-82": (nothing executed)
  Kernel Wake lock "event7-82": (nothing executed)
  Kernel Wake lock "dock": 27ms  (1 times) realtime
  Kernel Wake lock "SMD_DATA5": 1m 45s 121ms  (158 times) realtime
  Kernel Wake lock "event1-92": (nothing executed)
  Kernel Wake lock "gpio_kp": (nothing executed)
  Kernel Wake lock "event3-87": (nothing executed)
  Kernel Wake lock "event7-92": (nothing executed)
  Kernel Wake lock "msm_serial_hs_dma": (nothing executed)
  Kernel Wake lock "event5-91": (nothing executed)
  Kernel Wake lock "vbus_present": 517ms  (1 times) realtime
  Kernel Wake lock "alarm": 3s 229ms  (249 times) realtime
  Kernel Wake lock "event1-82": (nothing executed)
  Kernel Wake lock "venc_suspend": (nothing executed)
  Kernel Wake lock "event1-86": (nothing executed)
  Kernel Wake lock "AudioHardwareQSDOut": 3s 98ms  (1 times) realtime
  Kernel Wake lock "event0-87": (nothing executed)
  Kernel Wake lock "event2-92": 169ms  (687 times) realtime
  Kernel Wake lock "ds2784-battery": 12s 846ms  (158 times) realtime
  Kernel Wake lock "ApmCommandThread": 564ms  (2 times) realtime
  Kernel Wake lock "msmfb_idle_lock": 1s 495ms  (715 times) realtime
  Kernel Wake lock "headset": (nothing executed)
  Kernel Wake lock "kgsl": 26s 473ms  (123 times) realtime
  Kernel Wake lock "venc_idle": (nothing executed)
  Kernel Wake lock "event1-91": (nothing executed)
  Kernel Wake lock "s5k3e2fx": (nothing executed)
  Kernel Wake lock "usb_mass_storage": (nothing executed)
  Kernel Wake lock "unknown_wakeups": (nothing executed)
  Kernel Wake lock "vdec_idle": (nothing executed)
  Kernel Wake lock "audio_pcm_suspend": 3s 99ms  (1 times) realtime
  Kernel Wake lock "microp_i2c_present": (nothing executed)
  Kernel Wake lock "event4-91": (nothing executed)
  Kernel Wake lock "event6-92": 182ms  (86 times) realtime
  Kernel Wake lock "event0-82": (nothing executed)
  Kernel Wake lock "event0-92": 8ms  (37 times) realtime
  Kernel Wake lock "rpc_read": 112ms  (1540 times) realtime
  Kernel Wake lock "event0-86": (nothing executed)
  Kernel Wake lock "msm_serial_hs_rx": (nothing executed)
  Kernel Wake lock "qmi2": (nothing executed)
  Kernel Wake lock "event1-87": (nothing executed)
  Kernel Wake lock "msm_camera": (nothing executed)
  Kernel Wake lock "rpc-interface": 2ms  (1 times) realtime
  Kernel Wake lock "main": 1m 38s 314ms  (5 times) realtime
  Kernel Wake lock "gpio_input": (nothing executed)
  Kernel Wake lock "event3-91": (nothing executed)
  Kernel Wake lock "SMD_DATA7": (nothing executed)
