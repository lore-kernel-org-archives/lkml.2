Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab0GFRhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 13:37:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755660Ab0GFRhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 13:37:15 -0400
Message-ID: <4C3369C3.9010001@redhat.com>
Date: Tue, 06 Jul 2010 14:37:07 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.4) Gecko/20100628 Red Hat/3.1-1.el6 Lightning/1.0b2 Thunderbird/3.1
MIME-Version: 1.0
To: kagen101@gmail.com
CC: Aldo Cedillo <aldobrett11@gmail.com>, gregkh@suse.de,
       olimpiu.pascariu@gmail.com, julia@diku.dk, tj@kernel.org,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: cx25821: fix brace coding style issue in  cx25821-audio-upstream.c
References: <1278238174.17566.4.camel@dermezel>	 <AANLkTil_Pu76aEje-5FP9nmxba--pmmAX3YkqNdzN3xX@mail.gmail.com> <1278437084.5396.81.camel@dermezel>
In-Reply-To: <1278437084.5396.81.camel@dermezel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 06-07-2010 14:24, Joe Eloff escreveu:
> On Tue, 2010-07-06 at 12:12 -0500, Aldo Cedillo wrote:
>>> Subject: [PATCH] Staging: cx25821: fix brace coding style issue in cx25821-audio-upstream.c
>>>  This is a patch to the cx25821.c file that fixes up a brace warning found by the checkpatch.pl tool
>>>  Signed-off-by: Joe Eloff <kagen101@gmail.com>
>>>
>>> ---
>>>  drivers/staging/cx25821/cx25821-audio-upstream.c |    4 ++--
>>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.c b/drivers/staging/cx25821/cx25821-audio-upstream.c
>>> index eb39d13..e7346ec 100644
>>> --- a/drivers/staging/cx25821/cx25821-audio-upstream.c
>>> +++ b/drivers/staging/cx25821/cx25821-audio-upstream.c
>>> @@ -762,9 +762,9 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
>>>                       str_length + 1);
>>
>>
>> I haven't tried checkpatch.pl over that file, but in the CodingStyle
>> document you can read this:
>>
>> Do not unnecessarily use braces where a single statement will do.
>>
>> if (condition)
>>         action();
>>
>> This does not apply if one branch of a conditional statement is a single
>> statement. Use braces in both branches.
>>
>> if (condition) {
>>         do_this();
>>         do_that();
>> } else {
>>         otherwise();
>> }
>>
>> Which one is the correct style? I ask these because I have seen this
>> in other parts of the kernel. So maybe I can help to homogenize this.
>>
>>>                /* Default if filename is empty string */
>>> -               if (strcmp(dev->input_audiofilename, "") == 0) {
>>> +               if (strcmp(dev->input_audiofilename, "") == 0)
>>>                        dev->_audiofilename = "/root/audioGOOD.wav";
>>> -               }
>> I believe only this one has to go.
>>> +
>>>        } else {
>> So the first brace closes the brace of the if line.
>>>                str_length = strlen(_defaultAudioName);
>>>                dev->_audiofilename = kmalloc(str_length + 1, GFP_KERNEL);
>>
>> Thanks,
>> Aldo Brett
> 
> Thats good to know thanks for pointing that out, I have picked up a few
> discrepancies with interpretation and checkpatch.pl.
> Am noting it and trying to patch checkpatch.pl as I continue :).
> 
> I think checkpatch.pl points this out as the opposite to interpretation
> thou otherwise I would not have patched it I guess.
> 
> Current TODO on checkpatch:
> 
> 1. type i = 0 ; /* space before ; is not picked up by checkpatch.
> 2. What you mentioned is interpreted different by checkpatch.pl 

If you intend to submit more patches to cx25821, please generate it against my tree, as
the driver suffered a major cleanup recently.
	http://git.linuxtv.org/v4l-dvb.git
	branch devel/for_v2.6.36

Cheers,
Mauro.
