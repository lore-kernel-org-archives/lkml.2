Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466Ab1FWPCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 11:02:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62035 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758185Ab1FWPCr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 11:02:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=gd1ANuj2Je6MlDdS4QxyT4kORq0PoRkRt2qffwilP37g8Me4mg28Gb7yGp3ueIeKqH
         FOjtdw5amiWmTNJPZn70nhMy68NX3ZAdlg5XWR3Vt/iuP6nAm3Nw1/WrPbjc4ZhfjMgY
         zyknPI7dlCuH5nvYQvHrvYdrlcQovV8+UE6io=
MIME-Version: 1.0
In-Reply-To: <BANLkTimdzyT6w2LoKtTjhHTKF5d6zWXFGw@mail.gmail.com>
References: <BANLkTi=y1roManmZGMLBXSFbBVqK_KqDZg@mail.gmail.com>
 <20110623153116.404f2a63.taeuber@bbaw.de> <BANLkTinOb-4Xm_W2fmzivk6jBJwjeHYKVA@mail.gmail.com>
 <BANLkTimXH8K91cZ69oPRu=wbYt9JgBadfA@mail.gmail.com> <BANLkTin9bQ4hzs-odYU-Gxy-f-T+HLLAdQ@mail.gmail.com>
 <4E034E2A.1010100@msgid.tls.msk.ru> <20110623165206.d88dcbb3.taeuber@bbaw.de> <BANLkTimdzyT6w2LoKtTjhHTKF5d6zWXFGw@mail.gmail.com>
From: =?UTF-8?B?5L+e6aKQ6LaF?= <yyc1992@gmail.com>
Date: Thu, 23 Jun 2011 11:02:26 -0400
Message-ID: <BANLkTi=AeqT1CmiiNUXOcxYPe9=ORKME9g@mail.gmail.com>
Subject: Re: extra slash in current path
To: linux-kernel@vger.kernel.org, linux-c-programming@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 10:52 AM, Lars Täuber <taeuber@bbaw.de> wrote:
> Am Thu, 23 Jun 2011 18:31:06 +0400
> Michael Tokarev <mjt@tls.msk.ru> schrieb:
>> 23.06.2011 18:11, yuyichao-mit wrote:
>>
>> >>>> $ cd //
>> >>>> $ pwd
>> >>>> //
>>
>> The current directory is cached in $PWD environment
>> variable by shell (bash at least).  This variable is
>> checked in glibc (getcwd() et al) - if it is set and
>> stat($PWD) is the same as stat("."), that value is used.
>
> It also is somehow cached inside bash/dash for it's built in commands.
> $ cd //
> $ export PWD=5

this PWD=5 is not necessary.

> $ pwd
> //
> $ /bin/pwd
> /

$ export PWD=////
$ /bin/pwd
/
$ pwd
//
$ echo $PWD
////
$ a.out (simply output get_current_dir_name())
////
so getcwd indeed use $PWD (for symlink?) but pwd and /bin/pwd both
simplify the output although bash simplify it in a strange way~~~

~~interesting

>
>
> Regards
> Lars
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
