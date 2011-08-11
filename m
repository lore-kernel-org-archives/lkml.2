Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1HKPYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 11:24:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58882 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab1HKPYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 11:24:06 -0400
Message-ID: <4E43F413.5000104@suse.cz>
Date: Thu, 11 Aug 2011 17:24:03 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
Cc: Arnaud Lacombe <lacombar@gmail.com>, Andreas Schwab <schwab@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 2/2] Enable 'make CONFIG_FOO=y oldconfig'
References: <1312067499.22074.59.camel@i7.infradead.org>  <1312985888.2989.46.camel@i7.infradead.org>  <CACqU3MXozgu0kr-4w=bGejcEi8MrxH-PhKa0Ji0zrLu7ZEFomg@mail.gmail.com>  <1312993987.2989.53.camel@i7.infradead.org>  <CACqU3MXC_eDqgWDwnVe8KsqoAMTPQNiP6YMHD5G+1sMBhMwXzA@mail.gmail.com>  <1312999168.2989.61.camel@i7.infradead.org>  <CACqU3MWB+4n5Acd-GboH5WbCzfZFiAc0wNvOkn_5O+--7jLE8A@mail.gmail.com>  <1313002322.2989.88.camel@i7.infradead.org>  <CACqU3MU2J25q-wWJ8LNcMkwi3uMigz_+0=XcrNiPC0TGiJHZqA@mail.gmail.com>  <1313018232.2989.114.camel@i7.infradead.org>  <CACqU3MVyjzr47N9v23SGaSjiEOGoEaP1-TZ4Z_RyVNgVXgPEwg@mail.gmail.com>  <1313052168.18037.9.camel@i7.infradead.org> <4E4399B3.3020909@suse.cz>  <1313061012.18037.17.camel@i7.infradead.org> <m3r54std0x.fsf@hase.home>  <1313062813.18037.24.camel@i7.infradead.org> <4E43C363.3000103@suse.cz>  <CACqU3MVUeHTZ+cQYucYd8TvGoUOrwVhpxVpho-fqz3MkBTCTMQ@mail.gmail.com> <1313075243.5632.6.camel@macbook.infradead.org>
In-Reply-To: <1313075243.5632.6.camel@macbook.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.8.2011 17:07, David Woodhouse wrote:
> On Thu, 2011-08-11 at 10:57 -0400, Arnaud Lacombe wrote:
>>
>> FWIW, this is the broken behavior I have been pointing all along...
>>
>> If kconfig hard failed on such case, we would not need such Kbuild
>> black-magic.
>>
>> From my point of view, if environment override there should be, it
>> should behave the same as the all.config logic and hard fail when an
>> override has not been met. 
>> Code wise, this would translate as backend code path being the same. 
>  
> 
> The patches I have so far *do* behave the same as the all.config logic,
> because the back end code *is* fairly much the same. I was looking at
> the all.config logic when I wrote the patch to kconfig.
> 
> It *doesn't* currently hard fail. But I'm more than happy to make it do
> so. I think you're right; that makes most sense.

One of my use cases for all.config is

$ cp .../older-working-config all.config
$ make KCONFIG_ALLCONFIG=1 allmodconfig

i.e. reuse what is possible from an older config and enable all new
options. Surely it sometimes results in suboptimal configuration with
unwanted debug options enabled, but most of the time it works. I won't
be happy if you make it hard fail because of renamed or removed config
options.

Michal
