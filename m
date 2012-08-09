Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab2HIH1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 03:27:32 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46301 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755695Ab2HIH1a convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 03:27:30 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAB=NE6V7Tx1ioDafPmOprwzd0Q61dDe8XK5gBghXHVROXOBA=Q@mail.gmail.com>
References: <CAB=NE6WZWEO=b5Usx4RKDLC--TvLWnOom0P+HmXsxh7QZQQXQA@mail.gmail.com>
	<CAFub=KRtuTDn1DnHP0aKZT6RBeA2kNkLm6ud-4Z=1ESPs==h0g@mail.gmail.com>
	<CAB=NE6V7Tx1ioDafPmOprwzd0Q61dDe8XK5gBghXHVROXOBA=Q@mail.gmail.com>
Date: Thu, 9 Aug 2012 09:27:29 +0200
Message-ID: <CA+icZUV51Bk=jxnfrGL4xo6MQXnVdhUCago_RPZM-iL+twpF1A@mail.gmail.com>
Subject: Re: Using vanilla kernels headers to do backport testing -- issues
 with memcpy()
From: Sedat Dilek <sedat.dilek@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 5:30 AM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
> On Wed, Aug 8, 2012 at 5:43 AM, Ozan Çağlayan <ozancag@gmail.com> wrote:
>> On Tue, Aug 7, 2012 at 10:28 PM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
>
>>> mcgrof@garbanzo ~/compat (git::master)$ objdump -T
>>> /home/mcgrof/compat-ksrc/lib/modules/3.4.4-030404-generic/build/scripts/genksyms/genksyms
>
> <-- snip -->
>
>>> Bleh:
>>>
>>> 0000000000000000      DF *UND*  0000000000000000  GLIBC_2.14  memcpy
>
> <-- snip -->
>
>> Can't we just rebuild genksyms in compat? I already have glibc 2.15 on
>> my system so I can't test this but normally this should adapt to the
>> build environment as it rebuilds and relinks the binary.
>
> Indeed! Implemented and pushed upstream:
>
> https://github.com/mcgrof/compat/commit/42faf2dc8d8bbbdc5b8913183fcd021a27e953c9
>

I am not an English native but this sentence sounds a bit strange to
me ("used" followed by "require" and double "Linux"?).
I can imagine what you want to express but have no better wording right now.

180 +  echo -e "   This was added since kernels >= 3.4 used require"
181 +  echo -e "   a glibc >= 2.14 for memcpy(), and not all Linux"
182 +  echo -e "   Linux distributions have such glibc.

- Sedat -

> So if you run into this issue all you have to do now is run:
>
> ./bin/get-compat-kernels -r
>
> New users of the script will automatically have this run after it
> downloads and installs the kernel headers.
>
> Case closed, thanks :)
>
>   Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
