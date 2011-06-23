Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499Ab1FWOZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 10:25:09 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:56494 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab1FWOZH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 10:25:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sImfPCOR7XZFXibtBG/SRTrA9IQE8av2vFrjEP2oatia3Ei+Y7OX9eprxvpNfsROlN
         QQ70EjLVtirvuaiDT8pGD3ynkj6wLuvUhwFWTQ24UxXrKo9AIT24yb80LSLC0WDRM2tf
         Ybp3+i3EaVAKojYr65qbQPLp6/gXJdlaxGMLc=
MIME-Version: 1.0
In-Reply-To: <BANLkTin9bQ4hzs-odYU-Gxy-f-T+HLLAdQ@mail.gmail.com>
References: <BANLkTi=y1roManmZGMLBXSFbBVqK_KqDZg@mail.gmail.com>
	<20110623153116.404f2a63.taeuber@bbaw.de>
	<BANLkTinOb-4Xm_W2fmzivk6jBJwjeHYKVA@mail.gmail.com>
	<BANLkTimXH8K91cZ69oPRu=wbYt9JgBadfA@mail.gmail.com>
	<BANLkTin9bQ4hzs-odYU-Gxy-f-T+HLLAdQ@mail.gmail.com>
Date: Thu, 23 Jun 2011 16:25:06 +0200
Message-ID: <BANLkTinci016e1U67ubn=bq3=Zsi3q99Aw@mail.gmail.com>
Subject: Re: extra slash in current path
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: yuyichao-mit <yuyichao@mit.edu>
Cc: =?ISO-8859-1?Q?Lars_T=E4uber?= <taeuber@bbaw.de>,
        linux-kernel@vger.kernel.org, linux-c-programming@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 4:11 PM, yuyichao-mit <yuyichao@mit.edu> wrote:
> On Thu, Jun 23, 2011 at 9:54 AM, richard -rw- weinberger
> <richard.weinberger@gmail.com> wrote:
>> On Thu, Jun 23, 2011 at 3:32 PM, yuyichao-mit <yuyichao@mit.edu> wrote:
>>> On Thu, Jun 23, 2011 at 9:31 AM, Lars Täuber <taeuber@bbaw.de> wrote:
>>>> Hi,
>>>>
>>>> Am Thu, 23 Jun 2011 09:14:18 -0400
>>>> yuyichao-mit <yuyichao@mit.edu> schrieb:
>>>>> The problem is like this:
>>>>>
>>>>> $ cd /
>>>>> $ pwd
>>>>> /
>>>>>
>>>>> $ cd /
>>>>> $ pwd
>>>>> //
>>>>
>>>> didn't you mean?:
>>>> $ cd //
>>>> $ pwd
>>>> //
>>>
>>> yes, exactly.
>>>
>>> Sorry for the typo (copy-paste~~~)
>>>
>>
>> Is this really a kernel issue?
>> rw@raccoon:~> cd //
>> rw@raccoon://> pwd
>> //
>> rw@raccoon://> ls -l /proc/self/cwd
>> lrwxrwxrwx 1 rw users 0 23. Jun 15:53 /proc/self/cwd -> /
>
> well, that's true, but this is indeed the retrun value of get_current_dir_name.
>
> #include <unistd.h>
> #include <stdio.h>
>
> int main()
> {
>        char *cwd = get_current_dir_name();
>        printf("%s\n", cwd);
>        return 0;
> }
>
> $ cd //
> $ pwd
> //
> $ main
> //
>
> so is this a glibc stuff??

I guess glibc does some caching.

> (that's y I also send to linux-c-programming.)

Ah, ok.

-- 
Thanks,
//richard
