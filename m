Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859Ab0JXPdO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 11:33:14 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49236 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab0JXPdN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 11:33:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=GZNoccUo/U/Dxl1z98ry/WnTrnFJnelRYXTv4ox9n1s3WgQslFgpArwuv1cDJ2tJVl
         Xd6AzsnMJznT3NIzUR+stfgIMR9EAc3sH62nJjnKEmFwgGOXv8ADm/eqo/adtUXfeNqN
         gSGpT/QeLOmlGYOJUNF6g6aZrk7L0Eq8nxh10=
MIME-Version: 1.0
In-Reply-To: <AANLkTinohRReVsYoetEjqAp-XrL9C2jxGgXLVnLafSUM@mail.gmail.com>
References: <AANLkTinbeAn4ObFSb4f4znjYHGNKTMnfV7eQja+cnsLe@mail.gmail.com>
 <20100911065725.GA6279@fancy-poultry.org> <AANLkTikTq=GTy-XPD6ye6kStASNL4Pa07wHhH_ABmpm1@mail.gmail.com>
 <AANLkTim7RvpOcBajyqCkrBP8EW-FwNysvwuF5MaDJiFV@mail.gmail.com>
 <AANLkTi=PCd1=w-mkc=Sj4EEda=PnTv0JGyV1Ysxq4ej4@mail.gmail.com>
 <AANLkTikLSFFpbgX+rBR5banBygmB6rRvzMBYKfPcFPuJ@mail.gmail.com>
 <4C8C9834.8060201@redhat.com> <AANLkTi=8jJMz3f0VGwg+6P+BJEfxj6i-jBkGmqx8hCVg@mail.gmail.com>
 <AANLkTinohRReVsYoetEjqAp-XrL9C2jxGgXLVnLafSUM@mail.gmail.com>
From: dave b <db.pub.mail@gmail.com>
Date: Mon, 25 Oct 2010 02:32:52 +1100
Message-ID: <AANLkTikqhMbW7sWbbU_we5YE9Y9U=MPUTm553AmCyH51@mail.gmail.com>
Subject: Fwd: [dm-crypt] [BUG] bad performance and system stalls when using dm-crypt
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am forwarding this to the linux kernel mailing list to see if anyone
is actually interested with this bug or not. I suspect that the patch
to allow DM-CRYPT to use multiple cpus(Scale to multiple CPUs) will
remove most of the problem but *not* all of it. As I previously was
triggering the bug on a single core system.

See https://bugzilla.kernel.org/show_bug.cgi?id=18302 for the original thread.
I filed this as bug  18302 at
https://bugzilla.kernel.org/show_bug.cgi?id=18302 .



---------- Forwarded message ----------
From: dave b <db.pub.mail@gmail.com>
Date: 7 October 2010 04:58
Subject: Re: [dm-crypt] [BUG] bad performance and system stalls when
using dm-crypt
To: Milan Broz <mbroz@redhat.com>
Cc: dm-crypt@saout.de


On 12 September 2010 21:45, dave b <db.pub.mail@gmail.com> wrote:
> On 12 September 2010 19:07, Milan Broz <mbroz@redhat.com> wrote:
>> On 09/12/2010 10:36 AM, dave b wrote:
>>>
>>> Should I forward my 'bug' to the linux kernel maliing list ?
>>
>> Better report it to kernel bugzilla, it is better for tracking.
>> (Also see https://bugzilla.kernel.org/show_bug.cgi?id=17892 )
>
> Will do :)
>

Ok no one has responded to that bug ... :/
On a system lock up I ssh into the box and saw wait time was 83% in top.
I also saw that kcrypd was using 23% of cpu time - and that only one
core was in use.
1012 root      20   0     0    0    0 S   11  0.0  30:15.46 kcryptd

The system was stalled for 20minutes ...

load average: 19.16, 15.74, 11.43

--
Let me take you a button-hole lower.            -- William Shakespeare, "Love's
Labour's Lost"
