Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab2CMO6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 10:58:22 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:36358 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab2CMO6U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 10:58:20 -0400
MIME-Version: 1.0
In-Reply-To: <CANejiEWYCxY_hLwgyN08_cXC64c82irkNPytTjOpYyER7pTGow@mail.gmail.com>
References: <20120312030412.375458948@fusionio.com>
	<alpine.LRH.2.02.1203121806120.23719@diagnostix.dwd.de>
	<4F5EFEB6.4060402@kernel.org>
	<alpine.LRH.2.02.1203131213480.15848@diagnostix.dwd.de>
	<CANejiEWYCxY_hLwgyN08_cXC64c82irkNPytTjOpYyER7pTGow@mail.gmail.com>
Date: Tue, 13 Mar 2012 11:58:19 -0300
X-Google-Sender-Auth: f3_J0XCoO2lpa5kKZMvmaDH3rs4
Message-ID: <CABYL=To_A_n7K1SbUESSLi-vqb9TwPxaCQzxbneL+8bJ=kEcsA@mail.gmail.com>
Subject: Re: [patch 0/7] Add TRIM support for raid linear/0/1/10
From: Roberto Spadim <roberto@spadim.com.br>
To: Shaohua Li <shli@kernel.org>
Cc: Holger Kiehl <Holger.Kiehl@dwd.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "neilb@suse.de" <neilb@suse.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

could you send informations about yours devices? maybe a devices with
a diferent block sizes? are you running a virtual machine? a real one?

Em 13 de março de 2012 11:15, Shaohua Li <shli@kernel.org> escreveu:
> 2012/3/13 Holger Kiehl <Holger.Kiehl@dwd.de>:
>> On Tue, 13 Mar 2012, Shaohua Li wrote:
>>
>>> On 3/13/12 2:22 AM, Holger Kiehl wrote:
>>> > Hello,
>>> >
>>> > On Mon, 12 Mar 2012, Shaohua Li wrote:
>>> >
>>> >> The patches add TRIM support for raid linear/0/1/10. I'll add TRIM
>>> support for
>>> >> raid 4/5/6 later. The implementation is pretty straightforward and
>>> >> self-explained.
>>> >>
>>> > First, thanks for this patch!
>>> >
>>> > I have applied those patches against 3.3.0-rc7 and during boot the
>>> > kernel
>>> > reports a lot of the following:
>>> >
>>> > Mar 12 18:56:00 c3po kernel: [ 7.611045] md/raid0:md3: make_request bug:
>>> can't convert block across chunks or bigger than 512k 18861064 512
>>> > Mar 12 18:56:00 c3po kernel: [ 7.611047] md/raid0:md3: make_request bug:
>>> can't convert block across chunks or bigger than 512k 18862088 512
>>> > Mar 12 18:56:00 c3po kernel: [ 7.611049] md/raid0:md3: make_request bug:
>>> can't convert block across chunks or bigger than 512k 18863112 512
>>> > Mar 12 18:56:00 c3po kernel: [ 7.611052] md/raid0:md3: make_request bug:
>>> can't convert block across chunks or bigger than 512k 18864136 512
>>> > Mar 12 18:56:00 c3po kernel: [ 7.611054] md/raid0:md3: make_request bug:
>>> can't convert block across chunks or bigger than 512k 18865160 512
>>> > Mar 12 18:56:00 c3po kernel: [ 7.611056] md/raid0:md3: make_request bug:
>>> can't convert block across chunks or bigger than 512k 18866184 512
>>> Looks our SMTP server does something stupid. Sorry if you get two copies
>>> of the mail.
>>>
>>> Thanks for testing. Looks I fixed a sanity check in bio.c but there are
>>> similar check in raid0/10 which I forgot to fix. Below patch should fix
>>> it.
>>> please try.
>>>
>> Now I get following messages during boot (and it takes a very long time):
>>
>>   Mar 13 10:23:25 c3po kernel: [  251.355041]   bio ffff88019e0abc70,
>> biotail ffff88019e0ddc00, buffer           (null), len 0
>>   Mar 13 10:23:25 c3po kernel: [  251.355052] request botched: dev sdb:
>> type=1, flags=916c081
>>   Mar 13 10:23:25 c3po kernel: [  251.355054]   sector 52929353, nr/cnr 0/8
>>   Mar 13 10:23:25 c3po kernel: [  251.355055]   bio ffff88019e0aba70,
>> biotail ffff88019e0dda00, buffer           (null), len 0
>>   Mar 13 10:23:25 c3po kernel: [  251.355068] request botched: dev sdc:
>> type=1, flags=916c081
>>   Mar 13 10:23:25 c3po kernel: [  251.355069]   sector 52929346, nr/cnr
>> 0/1016
>>   Mar 13 10:23:25 c3po kernel: [  251.355071]   bio ffff88019e0aae00,
>> biotail ffff88019e0db380, buffer           (null), len 0
>>   Mar 13 10:23:25 c3po kernel: [  251.373583] request botched: dev sda:
>> type=1, flags=916c081
>>   Mar 13 10:23:25 c3po kernel: [  251.373585]   sector 52929354, nr/cnr
>> 0/1016
>>   Mar 13 10:23:25 c3po kernel: [  251.373587]   bio ffff88019e0aba00,
>> biotail ffff88019e0ddc00, buffer           (null), len 0
>>   Mar 13 10:23:25 c3po kernel: [  251.373597] request botched: dev sdb:
>> type=1, flags=916c081
>>   Mar 13 10:23:25 c3po kernel: [  251.373599]   sector 52929354, nr/cnr
>> 0/1016
>>   Mar 13 10:23:25 c3po kernel: [  251.373600]   bio ffff88019e0ab800,
>> biotail ffff88019e0dda00, buffer           (null), len 0
>>   Mar 13 10:23:25 c3po kernel: [  251.373612] request botched: dev sdc:
>> type=1, flags=916c081
>>   Mar 13 10:23:25 c3po kernel: [  251.373614]   sector 52929347, nr/cnr 0/8
>>   Mar 13 10:23:25 c3po kernel: [  251.373616]   bio ffff88019e0aaa70,
>> biotail ffff88019e0db380, buffer           (null), len 0
>>   Mar 13 10:23:25 c3po kernel: [  251.392135] request botched: dev sda:
>> type=1, flags=916c081
>>   Mar 13 10:23:25 c3po kernel: [  251.392137]   sector 52929355, nr/cnr 0/8
>>   Mar 13 10:23:25 c3po kernel: [  251.392139]   bio ffff88019e0ab670,
>> biotail ffff88019e0ddc00, buffer           (null), len 0
>>   Mar 13 10:23:25 c3po kernel: [  251.392150] request botched: dev sdb:
>> type=1, flags=916c081
>>   Mar 13 10:23:25 c3po kernel: [  251.392152]   sector 52929355, nr/cnr 0/8
>>   Mar 13 10:23:25 c3po kernel: [  251.392153]   bio ffff88019e0ab470,
>> biotail ffff88019e0dda00, buffer           (null), len 0
>>
>> After boot the system runs fine, but as soon as I do something (make clean
>> of
>> kernel tree with a sync) I get the same messages as above and it takes a
>> long time to sync:
>>
>>   Mar 13 10:44:59 c3po kernel: [ 1550.740528] request botched: dev sda:
>> type=1, flags=9164081
>>   Mar 13 10:44:59 c3po kernel: [ 1550.740533]   sector 12580617, nr/cnr
>> 0/776
>>   Mar 13 10:44:59 c3po kernel: [ 1550.740537]   bio ffff8801a362b670,
>> biotail ffff8801a30f3d80, buffer           (null), len 0
>>   Mar 13 10:44:59 c3po kernel: [ 1550.747141] request botched: dev sdb:
>> type=1, flags=9164081
>>   Mar 13 10:44:59 c3po kernel: [ 1550.747144]   sector 12579841, nr/cnr
>> 0/248
>>   Mar 13 10:44:59 c3po kernel: [ 1550.747148]   bio ffff88019e0dd200,
>> biotail ffff88019e0dd200, buffer           (null), len 0
>>   Mar 13 10:44:59 c3po kernel: [ 1550.749429] request botched: dev sdc:
>> type=1, flags=9164081
>>   Mar 13 10:44:59 c3po kernel: [ 1550.749432]   sector 12579841, nr/cnr
>> 0/248
>>   Mar 13 10:44:59 c3po kernel: [ 1550.749436]   bio ffff8801a362b600,
>> biotail ffff8801a362b600, buffer           (null), len 0
>>   Mar 13 10:44:59 c3po kernel: [ 1550.755332] request botched: dev sda:
>> type=1, flags=916c081
>>   Mar 13 10:44:59 c3po kernel: [ 1550.755335]   sector 12580618, nr/cnr
>> 0/248
>>   Mar 13 10:44:59 c3po kernel: [ 1550.755339]   bio ffff8801a30f3d80,
>> biotail ffff8801a30f3d80, buffer           (null), len 0
>>   Mar 13 10:44:59 c3po kernel: [ 1550.806832] request botched: dev sdb:
>> type=1, flags=9164081
>>   Mar 13 10:44:59 c3po kernel: [ 1550.806836]   sector 12266497, nr/cnr
>> 0/1000
>>   Mar 13 10:44:59 c3po kernel: [ 1550.806840]   bio ffff8801a4dca800,
>> biotail ffff88019e0c9000, buffer           (null), len 0
>>   Mar 13 10:44:59 c3po kernel: [ 1550.811972] request botched: dev sda:
>> type=1, flags=9164081
>>   Mar 13 10:44:59 c3po kernel: [ 1550.811976]   sector 12266497, nr/cnr
>> 0/1000
>>   Mar 13 10:44:59 c3po kernel: [ 1550.811979]   bio ffff88019e0dd200,
>> biotail ffff8801a3794000, buffer           (null), len 0
>>   Mar 13 10:44:59 c3po kernel: [ 1550.814081] request botched: dev sdc:
>> type=1, flags=9164081
>>   Mar 13 10:44:59 c3po kernel: [ 1550.814084]   sector 12265497, nr/cnr 0/24
>>   Mar 13 10:44:59 c3po kernel: [ 1550.814087]   bio ffff8801a4dca870,
>> biotail ffff8801a37f4080, buffer           (null), len 0
>>   Mar 13 10:44:59 c3po kernel: [ 1550.819150] request botched: dev sdc:
>> type=1, flags=916c081
>>   Mar 13 10:44:59 c3po kernel: [ 1550.819153]   sector 12265498, nr/cnr
>> 0/1000
>>
>> Please give me any hints what I can try next.
> Thanks for testing. This is very wield, the req->__data_len is wrong.
> Is this a clean build?
> didn't success to reproduce it, will check tomorrow again.
>
> Thanks,
> Shaohua
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Roberto Spadim
Spadim Technology / SPAEmpresarial
