Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab0FGDZE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 23:25:04 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44456 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab0FGDZC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 23:25:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OyIXm6bUMLl+WuLnF1Gvbm9ekCOe1Q8aWDmwWP4/xrKjEYP878gUzAGfcZnulF9OP6
         CUTp1amsnJMqqpQfN2/zVchrSQpEqqT4/ZjPggD9gtBmBQ0qNfYrtyMvSm2HY2cSvwII
         hUekgH06cmcNTCJ3usCdMizpCjA0Im9Wt/Cbc=
MIME-Version: 1.0
In-Reply-To: <1275860015-6643-1-git-send-email-jslaby@suse.cz>
References: <4C0C0DD8.5030106@gmail.com>
	<1275860015-6643-1-git-send-email-jslaby@suse.cz>
Date: Mon, 7 Jun 2010 13:25:01 +1000
Message-ID: <AANLkTimnMudoLsQl2Nu9_5eVM3QoSiAJv1WrbbA4Dam0@mail.gmail.com>
Subject: Re: BUG kmalloc-4096: Poison overwritten (2.6.35-rc2)
From: Dave Airlie <airlied@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>, frankpzh@gmail.com,
       Greg KH <gregkh@suse.de>, =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 7, 2010 at 7:33 AM, Jiri Slaby <jslaby@suse.cz> wrote:
> On 06/06/2010 11:06 PM, Justin P. Mattock wrote:
>> On 06/05/2010 11:27 PM, Jiri Slaby wrote:
>>> On 06/06/2010 08:12 AM, Justin P. Mattock wrote:
>>>> =============================================================================
>>>>
>>>>
>>>> [    0.002046] BUG kmalloc-4096: Poison overwritten
>>>> [    0.002051]
>>>> -----------------------------------------------------------------------------
>>>>
>>>>
>>>> [    0.002052]
>>>> [    0.002063] INFO: 0xffff88003ec09e00-0xffff88003ec09e9f. First byte
>>>> 0x20 instead of 0x6b
>>>> [    0.002073] INFO: Slab 0xffffea0000dba1c0 objects=7 used=1
>>>> fp=0xffff88003ec09048 flags=0x40000000000040c3
>>>> [    0.002082] INFO: Object 0xffff88003ec09048 @offset=4168
>>>> fp=0xffff88003ec0a090
>>>> [    0.002083]
>>>> [    0.002093] Bytes b4 0xffff88003ec09038:  00 00 00 00 00 00 00 00 5a
>>>> 5a 5a 5a 5a 5a 5a 5a ........ZZZZZZZZ
>>>> [    0.002114]   Object 0xffff88003ec09048:  6b 6b 6b 6b 6b 6b 6b 6b 6b
>>>> 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>>> ...
>>>> 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>>>> [    0.002999]   Object 0xffff88003ec09df8:  6b 6b 6b 6b 6b 6b 6b 6b 20
>>>> 07 20 07 20 07 20 07 kkkkkkkk........
>>>> [    0.002999]   Object 0xffff88003ec09e08:  20 07 20 07 20 07 20 07 20
>>>> 07 20 07 20 07 20 07 ................
>>>> [    0.002999]   Object 0xffff88003ec09e18:  20 07 20 07 20 07 20 07 20
>>>> 07 20 07 20 07 20 07 ................
>>>> [    0.002999]   Object 0xffff88003ec09e28:  20 07 20 07 20 07 20 07 20
>>>> 07 20 07 20 07 20 07 ................
>>>> [    0.002999]   Object 0xffff88003ec09e38:  20 07 20 07 20 07 20 07 20
>>>> 07 20 07 20 07 20 07 ................
>>>> [    0.002999]   Object 0xffff88003ec09e48:  20 07 20 07 20 07 20 07 20
>>>> 07 20 07 20 07 20 07 ................
>>>> [    0.002999]   Object 0xffff88003ec09e58:  20 07 20 07 20 07 20 07 20
>>>> 07 20 07 20 07 20 07 ................
>>>> [    0.002999]   Object 0xffff88003ec09e68:  20 07 20 07 20 07 20 07 20
>>>> 07 20 07 20 07 20 07 ................
>>>> [    0.002999]   Object 0xffff88003ec09e78:  20 07 20 07 20 07 20 07 20
>>>> 07 20 07 20 07 20 07 ................
>>>> [    0.002999]   Object 0xffff88003ec09e88:  20 07 20 07 20 07 20 07 20
>>>> 07 20 07 20 07 20 07 ................
>>>> [    0.002999]   Object 0xffff88003ec09e98:  20 07 20 07 20 07 20 07 6b
>>>> 6b 6b 6b 6b 6b 6b 6b ........kkkkkkkk
>>>> [    0.002999]   Object 0xffff88003ec09ea8:  6b 6b 6b 6b 6b 6b 6b 6b 6b
>>>
>>> Just guessing, grey spaces which should go to video ram?
>>>
>>
>>
>> o.k. I bisected this down to this commit:
>> 962400e8fd29
>> reverting gets dmesg to not
>> have a Poison overwritten..
>
> This definitely makes sense.
>
>> as for the screen blankness I think this
>> did cause it..keep in mind the blankness(black)
>> is not everytime(every so often)
>> here's some images of it:
>> http://www.flickr.com/photos/44066293@N08/4676350524/
>> http://www.flickr.com/photos/44066293@N08/4676350016/
>
> Yes, as I guessed, the "grey spaces" were written to some random space
> instead of video ram where they should overwrite (clear) the characters
> which you see on the pictures.
>
> Does the patch below help?
>

This helps a lot of issues on KMS systems,. can you get it to Linus?

Acked-by: Dave Airlie <airlied@redhat.com>

Dave.
