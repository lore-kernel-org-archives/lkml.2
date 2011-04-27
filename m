Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab1D0JMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 05:12:49 -0400
Received: from imp03.mtu.ru ([62.5.255.20]:48721 "EHLO imp03.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338Ab1D0JMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 05:12:48 -0400
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Apr 2011 05:12:47 EDT
Message-ID: <4DB7DC28.5090900@pavlinux.ru>
Date: Wed, 27 Apr 2011 13:04:40 +0400
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ru; rv:1.9.2.14) Gecko/20110221 Microsoft/666 Notepad
MIME-Version: 1.0
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>	<20110426190531.GA4556@p183>	<1303845468.18763.32.camel@gandalf.stny.rr.com>	<20110426192029.GA4686@p183>	<BANLkTinxvyxSK9f+kkQugNkQEBf1O65bLQ@mail.gmail.com>	<1303846642.18763.37.camel@gandalf.stny.rr.com>	<1303847110.24299.50.camel@Joe-Laptop>	<BANLkTimf44AgMAViHrSEz78ifHUYb8ji6g@mail.gmail.com>	<1303847902.18763.38.camel@gandalf.stny.rr.com>	<BANLkTike-s90heETJsZ+z7Kim8f-hN=UPw@mail.gmail.com>	<BANLkTimPJQ4QvbBVOURx_Jmuhwnf=zK9tQ@mail.gmail.com> <BANLkTik0vZC6afD_hrRQxpq6xOk-Ma0tMA@mail.gmail.com>
In-Reply-To: <BANLkTik0vZC6afD_hrRQxpq6xOk-Ma0tMA@mail.gmail.com>
X-Enigmail-Version: 1.1.2
OpenPGP: id=03742489
Content-Type: multipart/mixed;
 boundary="------------050402060403040308090601"
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050402060403040308090601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

27.04.2011 12:49, Miguel Ojeda пишет:
> On Wed, Apr 27, 2011 at 10:42 AM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> On Wed, Apr 27, 2011 at 10:29, Miguel Ojeda
>> <miguel.ojeda.sandonis@gmail.com> wrote:
>>> On Tue, Apr 26, 2011 at 9:58 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>>>> On Tue, 2011-04-26 at 16:47 -0300, Thiago Farina wrote:
>>>>
>>>>>> $ grep -rP --include=*.[ch] "\bstrcmp.*==\s*0\b" * | wc -l
>>>>>> 1143
>>>>>> $ grep -rP --include=*.[ch] "\!\s*strcmp\s*\(" *  | wc -l
>>>>>> 1663
>>>>>>
>>>>>> Can you count how many misuses of strcmp have been
>>>>>> corrected?
>>>>>
>>>>>> Do you plan to convert the existing 2800?
>>>>>
>>>>> I'd work on this without any problem.
>>>>
>>>> Nothing a perl script can't do either.
>>>
>>> If you are really going to do that, please use a coccinelle's semantic
>>> patch (which is designed precisely for that purpose) and document it

> Hi, on the contrary: I don't agree with the change unless a policy ...

I came up with the best :)

# cd /usr/src/linux-2.6

# for i in `grep strncmp ./ -R | cut -d: -f1,1`; \
    do \
       sed -i '/strncmp/ s//memcmp/g;' $i; \
done;





-- 

                                                         Pavel.

--------------050402060403040308090601
Content-Type: application/pgp-keys;
 name="0x03742489.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0x03742489.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v2.0.16 (GNU/Linux)

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
rHTb
=e6te
-----END PGP PUBLIC KEY BLOCK-----

--------------050402060403040308090601--
