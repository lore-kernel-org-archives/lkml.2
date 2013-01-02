Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab3ABR7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 12:59:44 -0500
Received: from mail.kapsi.fi ([217.30.184.167]:40763 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab3ABR7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 12:59:42 -0500
Message-ID: <50E4755E.7030209@iki.fi>
Date: Wed, 02 Jan 2013 19:58:54 +0200
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>
CC: Borislav Petkov <bp@alien8.de>, Shuah Khan <shuahkhan@gmail.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Andy Furniss <andyqos@ukfsn.org>, Alex Deucher <alexdeucher@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
References: <20121223105527.GA6230@liondog.tnic> <50D6E491.3030801@ukfsn.org> <20121223110730.GC6230@liondog.tnic> <50D6E8A4.1030204@ukfsn.org> <20121223113153.GA8918@liondog.tnic> <20121223115133.GA229@x4> <20121223122210.GA4460@liondog.tnic> <20121223133102.GA8153@liondog.tnic> <CAKocOOPO7ZhybEgKfCkpna+KbpGgajMp6HuHbO9m9uT3gUtP0g@mail.gmail.com> <50E3907C.4040106@iki.fi> <20130102120248.GC6181@x1.alien8.de> <CAH3drwYSrfsbKg-BYpMF3Nkxrw1toK=EmcvJfKGzdbT_BK-1HQ@mail.gmail.com>
In-Reply-To: <CAH3drwYSrfsbKg-BYpMF3Nkxrw1toK=EmcvJfKGzdbT_BK-1HQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.128.184.254
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2013 07:19 PM, Jerome Glisse wrote:
> On Wed, Jan 2, 2013 at 7:02 AM, Borislav Petkov <bp@alien8.de> wrote:
>> On Wed, Jan 02, 2013 at 03:42:20AM +0200, Antti Palosaari wrote:
>>> I ended up also that same commit after bisecting from current 3.8
>>> master.
>>>
>>> 01:05.0 VGA compatible controller: ATI Technologies Inc 760G [Radeon
>>> 3000] It is ASUS M5A78L-M/USB3 with integrated GPU.
>>>
>>> I cannot even boot unless graphical boot is removed from Fedora 17
>>> boot options (rhgb quiet). Random GPU crashes still.
>>
>> You could try the temporary R600-only fix although I can't see whether
>> your GPU is also an R600 ASIC or something different by staring at the
>> model string above:
>>
>> http://marc.info/?l=dri-devel&m=135628734704029
>>
>> HTH.
>>
>> --
>> Regards/Gruss,
>> Boris.
>
> How do you trigger the issue ? Does it happens right away on boot ?
>
> Cheers,
> Jerome

Sorry for utterly unclear description. I meant it randomly crashes 
desktop in case I got it booting by removing graphical boot option. In 
that case Cinnamon desktop "freezes", I was able to move mouse cursor 
but clicking buttons or moving windows etc. didn't worked at all. Only 
mouse cursor moves. It was possible to switch to console by ctrl+alt+fN.

When Fedora graphical boot was enabled (options rhgb quiet) and I 
selected Kernel from the grub, it makes just blank screen and after 
10sec or so monitor switches off saying "no signal". Nothing happened 
after that, boot was forced. I use dm-crypt and normally about the first 
thing is to show is graphical lock screen asking passphrase.

I did some grepping from the syslog and that same message is seen:

Jan  2 03:35:34 localhost kernel: [ 1164.433117] radeon 0000:01:05.0: 
GPU lockup CP stall for more than 10000msec
Jan  2 03:35:34 localhost kernel: [ 1164.433121] radeon 0000:01:05.0: 
GPU lockup (waiting for 0x0000000000000003 last fence id 0x0000000000000002)

After I reverted bisected patch it has been working just fine. I has 
been running whole day without problems.

regards
Antti

-- 
http://palosaari.fi/
