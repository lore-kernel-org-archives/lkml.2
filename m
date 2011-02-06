Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754Ab1BFKHu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 05:07:50 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40522 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab1BFKHs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 05:07:48 -0500
MIME-Version: 1.0
In-Reply-To: <1296952626.4133.77.camel@Joe-Laptop>
References: <AANLkTikj+FU8OF_-KFr2hmTSWqTHMK5JnrnTVyn-XtxQ@mail.gmail.com>
	<1296952626.4133.77.camel@Joe-Laptop>
Date: Sun, 6 Feb 2011 10:07:45 +0000
Message-ID: <AANLkTi=fdwiVRavB-NbDNcpGLVNyH7ybpEzRYm1fkWGD@mail.gmail.com>
Subject: Re: [PATCH] printk-formats.txt documentation update
From: Andrew Murray <amurray@mpcdata.com>
To: Joe Perches <joe@perches.com>
Cc: linux-embedded@vger.kernel.org,
        linux kernel <linux-kernel@vger.kernel.org>,
        Jiri Kosina <trivial@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the feedback - I will truncate to 80 characters and
implement Joe's advice.

Thanks,

Andrew Murray

On 6 February 2011 00:37, Joe Perches <joe@perches.com> wrote:
> On Sun, 2011-02-06 at 00:15 +0000, Andrew Murray wrote:
>> From: Andrew Murray <amurray@mpc-data.co.uk>
>> This patch updates the incomplete documentation concerning the printk
>> extended format specifiers.
>> Signed-off-by: Andrew Murray <amurray@mpc-data.co.uk>
>> ---
>> diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
> []
>> @@ -9,7 +9,42 @@ If variable is of Type,              use printk format specifier:
>>               size_t                  %zu or %zx
>>               ssize_t                 %zd or %zx
>>
>> -Raw pointer value SHOULD be printed with %p.
>> +Raw pointer value SHOULD be printed with %p. The kernel supports
>> +the following extended format specifiers for pointer types:
>
> I think it'd be better if each extension were individually described
> with an example output.
>
>> +
>> +     General:
>> +
>> +     %pF     function pointer with offset, e.g. module_start
>> +     %pf     function pointer without offset, e.g. module_start+0x0/0x62 [hello]
>
> with/without inversion?
>
>> +     %pS     text symbol with offset
>> +     %ps     text symbol without offset
>> +     %pR     struct resource with decoded flags, e.g. [mem 0x0-0x1f 64 bit pref]
>> +     %pr     struct resource with raw flags, e.g. [mem 0x0-0x1f flags 0x201]
>> +
>> +     MAC/FDDI addresses:
>> +
>> +     %pM     colon-seperated 6-byte MAC address in hex notation, e.g. 00:01:02:03:04:05
>
> spelling: separated
>
>> +     %pm     non-colon-seperated 6-byte MAC address is hex notation, e.g. 000102030405
>> +     %pMF    6-byte dash-separated FDDI hex notation
>> +
>> +     IPv4 addresses:
>> +
>> +     %pI4    IPv4 dot-seperated decimal without leading 0's, e.g. 1.2.3.4
>> +     %pi4    IPv4 dot-seperated decimal with leading 0's, 001.002.003.004
>> +     %p[Ii]4[hl] IPv4 dot-seperated decimal with/without leading 0's for
>> +             host (h), little (l) or network/big (default) endian order
>> +
>> +     IPv6 addresses:
>> +     %pI6    IPv6 colon-seperated network-order 16 bit hex with leading 0's,
>> +             e.g. 0001:0203:...:0708
>> +     %pi6    IPv6 non-colon-seperated network-order 16 bit hex with leading 0's,
>> +             e.g. 000102...0f
>> +     %pI6c   IPv6 address as described by
>> +             http://tools.ietf.org/html/draft-ietf-6man-text-addr-representation-00,
>> +             e.g. 1::708
>> +
>> +     %pU[bBlL] 16 byte UUID/GUID in big or little endian using lower or upper case
>
> Maybe a simple 2 line table without the e.g.:
>
>        %p<extension1>  sample output1
>                        description1
>        %p<extension2>  sample output2
>                        description2
>
>
>



-- 
Andrew Murray, Embedded Linux Group
MPC Data Limited
e-mail: amurray@mpc-data.co.uk  web: www.mpc-data.co.uk
tel: +44 (0) 1225 710600               fax: +44 (0) 1225 710601
ddi: +44 (0) 1225 710665

MPC Data Limited is a company registered in England and Wales with
company number 05507446
Registered Address: County Gate, County Way, Trowbridge, Wiltshire, BA14 7FJ
VAT no: 850625238

The information in this email and in the attached documents is
confidential and may be
legally privileged. Any unauthorized review, copying, disclosure or
distribution is
prohibited and may be unlawful. It is intended solely for the
addressee. Access to this
email by anyone else is unauthorized. If you are not the intended
recipient, please
contact the sender by reply email and destroy all copies of the
original message. When
addressed to our clients any opinions or advice contained in this
email is subject to
the terms and conditions expressed in the governing contract.
