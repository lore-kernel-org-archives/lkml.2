Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab1HKOX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:23:26 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38254 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab1HKOXZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 10:23:25 -0400
MIME-Version: 1.0
In-Reply-To: <4E43DA3F.7090709@suse.cz>
References: <1312465977-12388-1-git-send-email-corentin.chary@gmail.com>
	<1313052783-27607-1-git-send-email-corentin.chary@gmail.com>
	<1313062101.8300.23.camel@x61.thuisdomein>
	<CAHR064h8souTS7HZBk_6Kc0uRqRhJDGaB_4pFgHGJRSAF_50ig@mail.gmail.com>
	<4E43DA3F.7090709@suse.cz>
Date: Thu, 11 Aug 2011 16:23:23 +0200
Message-ID: <CAHR064h0_t4crVYWUkUe5AdOZ7kOv_D4thm7-AdLAErzNHfXsQ@mail.gmail.com>
Subject: Re: [PATCH] scripts: add extract-vmlinux
From: Corentin Chary <corentin.chary@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Paul Bolle <pebolle@tiscali.nl>, linux-kernel@vger.kernel.org,
        Dick Streefland <dick@streefland.net>,
        WANG Cong <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 3:33 PM, Michal Marek <mmarek@suse.cz> wrote:
> On 11.8.2011 15:08, Corentin Chary wrote:
>> On Thu, Aug 11, 2011 at 1:28 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
>>> On Thu, 2011-08-11 at 10:53 +0200, Corentin Chary wrote:
>>>> +try_decompress()
>>>> +{
>>>> +     for     pos in `tr "$1\n$2" "\n$2=" < "$img" | grep -abo "^$2"`
>>>> +     do
>>>> +             pos=${pos%%:*}
>>>> +             tail -c+$pos "$img" | $3 > $tmp 2> /dev/null
>>>
>>> Perhaps a few comments on the above lines would be nice. Without those
>>> comments I must guess you're finding compressed data somewhere in the
>>> input file. It also seems you're looping through the entire input file.
>>> Or are (sequences of) commands like the above considered obvious?
>>
>> It's copied from extract-ikconfig, there was no comment in it, so I
>> assumed it's obvious.
>> Basically it uses brute force (tm) to find well known headers and try
>> to decompress from here.
>
> And explanation of the "tr" trick would not hurt though. It replaces the
> binary magic with an ascii sequence on a new line (for older grep
> versions to get it right) and tries all occurrences of that sequence, am
> I right? But I wouldn't call it "obvious" :).

It's that commented in the header of both scripts ? (I can move down
the command if wanted)

>
>>>> +# That didn't work, so retry after decompression.
>>>> +try_decompress '\037\213\010' xy    gunzip
>>>> +try_decompress '\3757zXZ\000' abcde unxz
>>>> +try_decompress 'BZh'          xy    bunzip2
>>>> +try_decompress '\135\0\0\0'   xxx   unlzma
>>>> +try_decompress '\211\114\132' xy    'lzop -d'
>>>
>>> Perhaps you could first test whether these commands are available before
>>> running try_decompress() with them?
>>
>> Same as before, if it's ok for extract-ikconfig not to check the
>> command, then it's ok for me.
>> If it's not, then we should patch both.
>
> Also, if you have lzma to build a lzma-compressed kernel, then you very
> likely also have unlzma.
>
> Michal
>



-- 
Corentin Chary
http://xf.iksaif.net
