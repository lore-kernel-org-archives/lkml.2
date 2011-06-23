Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467Ab1FWOL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 10:11:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61587 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab1FWOL1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 10:11:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=BZuTsBYyJSksbWYxyo0L0ATxygo82DHJghoI5qLzIUoTJaOkI9o1Igqu5I84SAQyJ8
         O1P9toAw2uXAjFj5XvIZtT1Y7oQoumW2ofK0WxJ6SnU27iC5W/P9r3eOEw0Sy/ijkUQL
         61SdDOPialf6NQTJ3b+GTU8YIyEOMt46cfIAg=
MIME-Version: 1.0
In-Reply-To: <BANLkTimXH8K91cZ69oPRu=wbYt9JgBadfA@mail.gmail.com>
References: <BANLkTi=y1roManmZGMLBXSFbBVqK_KqDZg@mail.gmail.com>
 <20110623153116.404f2a63.taeuber@bbaw.de> <BANLkTinOb-4Xm_W2fmzivk6jBJwjeHYKVA@mail.gmail.com>
 <BANLkTimXH8K91cZ69oPRu=wbYt9JgBadfA@mail.gmail.com>
From: yuyichao-mit <yuyichao@mit.edu>
Date: Thu, 23 Jun 2011 10:11:04 -0400
X-Google-Sender-Auth: 7hSsWOxrGrBFPGbwkXeUGWnOwcE
Message-ID: <BANLkTin9bQ4hzs-odYU-Gxy-f-T+HLLAdQ@mail.gmail.com>
Subject: Re: extra slash in current path
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: =?ISO-8859-1?Q?Lars_T=E4uber?= <taeuber@bbaw.de>,
        linux-kernel@vger.kernel.org, linux-c-programming@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 9:54 AM, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
> On Thu, Jun 23, 2011 at 3:32 PM, yuyichao-mit <yuyichao@mit.edu> wrote:
>> On Thu, Jun 23, 2011 at 9:31 AM, Lars Täuber <taeuber@bbaw.de> wrote:
>>> Hi,
>>>
>>> Am Thu, 23 Jun 2011 09:14:18 -0400
>>> yuyichao-mit <yuyichao@mit.edu> schrieb:
>>>> The problem is like this:
>>>>
>>>> $ cd /
>>>> $ pwd
>>>> /
>>>>
>>>> $ cd /
>>>> $ pwd
>>>> //
>>>
>>> didn't you mean?:
>>> $ cd //
>>> $ pwd
>>> //
>>
>> yes, exactly.
>>
>> Sorry for the typo (copy-paste~~~)
>>
>
> Is this really a kernel issue?
> rw@raccoon:~> cd //
> rw@raccoon://> pwd
> //
> rw@raccoon://> ls -l /proc/self/cwd
> lrwxrwxrwx 1 rw users 0 23. Jun 15:53 /proc/self/cwd -> /

well, that's true, but this is indeed the retrun value of get_current_dir_name.

#include <unistd.h>
#include <stdio.h>

int main()
{
        char *cwd = get_current_dir_name();
        printf("%s\n", cwd);
        return 0;
}

$ cd //
$ pwd
//
$ main
//

so is this a glibc stuff??
(that's y I also send to linux-c-programming.)

>
> --
> Thanks,
> //richard
>
