Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab2HIDaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 23:30:55 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46147 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab2HIDay convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 23:30:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAFub=KRtuTDn1DnHP0aKZT6RBeA2kNkLm6ud-4Z=1ESPs==h0g@mail.gmail.com>
References: <CAB=NE6WZWEO=b5Usx4RKDLC--TvLWnOom0P+HmXsxh7QZQQXQA@mail.gmail.com>
 <CAFub=KRtuTDn1DnHP0aKZT6RBeA2kNkLm6ud-4Z=1ESPs==h0g@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Wed, 8 Aug 2012 20:30:33 -0700
X-Google-Sender-Auth: _PVGoktDjkYBUOhLD8sidHs2twY
Message-ID: <CAB=NE6V7Tx1ioDafPmOprwzd0Q61dDe8XK5gBghXHVROXOBA=Q@mail.gmail.com>
Subject: Re: Using vanilla kernels headers to do backport testing -- issues
 with memcpy()
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 8, 2012 at 5:43 AM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> On Tue, Aug 7, 2012 at 10:28 PM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:

>> mcgrof@garbanzo ~/compat (git::master)$ objdump -T
>> /home/mcgrof/compat-ksrc/lib/modules/3.4.4-030404-generic/build/scripts/genksyms/genksyms

<-- snip -->

>> Bleh:
>>
>> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.14  memcpy

<-- snip -->

> Can't we just rebuild genksyms in compat? I already have glibc 2.15 on
> my system so I can't test this but normally this should adapt to the
> build environment as it rebuilds and relinks the binary.

Indeed! Implemented and pushed upstream:

https://github.com/mcgrof/compat/commit/42faf2dc8d8bbbdc5b8913183fcd021a27e953c9

So if you run into this issue all you have to do now is run:

./bin/get-compat-kernels -r

New users of the script will automatically have this run after it
downloads and installs the kernel headers.

Case closed, thanks :)

  Luis
