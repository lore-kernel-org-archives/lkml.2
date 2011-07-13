Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964906Ab1GMFmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 01:42:35 -0400
Received: from ppp118-208-123-30.lns20.bne4.internode.on.net ([118.208.123.30]:57885
	"EHLO mail.psychogeeks.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750705Ab1GMFme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 01:42:34 -0400
Message-ID: <4E1D3045.7050507@psychogeeks.com>
Date: Wed, 13 Jul 2011 15:42:29 +1000
From: Chris W <lkml@psychogeeks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110620 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Jarod Wilson <jarod@wilsonet.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: Imon module Oops and kernel hang
References: <4E1B978C.2030407@psychogeeks.com> <20110712080309.d538fec9.rdunlap@xenotime.net> <7B814F02-408C-434F-B813-8630B60914DA@wilsonet.com> <4E1CCC26.4060506@psychogeeks.com> <1B380AD0-FE0D-47DF-B2C3-605253C9C783@wilsonet.com>
In-Reply-To: <1B380AD0-FE0D-47DF-B2C3-605253C9C783@wilsonet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 13/07/11 14:20, Jarod Wilson wrote:

>> Chris W wrote:
>> The rc keymap modules have been built (en masse as a result of
>> CONFIG_RC_MAP=m) but I am not explicitly loading them and they do not
>> get automatically loaded.
>
> Huh. That's unexpected. They get auto-loaded here, last I knew. I'll
> have to give one of my devices a spin tomorrow, not sure exactly what
> the last kernel I tried one of them on was. Pretty sure they're
> working fine with the Fedora 15 2.6.38.x kernels and vanilla (but
> Fedora-configured) 3.0-rc kernels though.


I just ran depmod to make sure things were straight in this dept.

kepler ~ # depmod -F System.map -e -av 2.6.39.3

There are no reported errors.   The modules rc-imon-mce.ko,
rc-imon-pad.ko and imon.ko depend only on rc-core.ko according to the
output.  There don't seem to be any explicit dependencies to the keymaps
(not a kernel dev so I don't know if there should be)


>> I just tried this:
>>
>> kepler ~ # rmmod rc_winfast ir_lirc_codec lirc_dev ir_sony_decoder
>> ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder ir_nec_decoder
>>
>> kepler ~ # modprobe -v rc-imon-pad
>> insmod
/lib/modules/2.6.39.3/kernel/drivers/media/rc/keymaps/rc-imon-pad.ko
>>
>> kepler ~ # modprobe -v rc-imon-mce
>> insmod
/lib/modules/2.6.39.3/kernel/drivers/media/rc/keymaps/rc-imon-mce.ko
> ...
>> kepler ~ # modprobe -v imon debug=1
>> insmod /lib/modules/2.6.39.3/kernel/drivers/media/rc/imon.ko debug=1
>>
>> with the same crash (below).  (I have the tainting nvidia driver
>> loaded today but it was absent yesterday)
>>
>> Perhaps there something else in the kernel config that must be on in
>> order to support the keymaps?
>>
>> Any other thoughts?
>
> Not at the moment. That T.889 line is... odd. No clue what the heck
> that thing is. Lemme see what I can see tomorrow (just past midnight
> here at the moment), if I don't hit anything, I might need a copy of
> your kernel config to repro.

I can only see the "T.889" string in the System.map, kernel binary and
kernel/sched.o (but not the source?).  I have sent the config file
off-list to Jarod.

I will try a Gentoo out-of-the-box kernel config when I finish work also.

Thanks once again for your time
Regards,

-- 
Chris Williams
Brisbane, Australia
