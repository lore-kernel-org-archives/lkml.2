Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab1HKI6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 04:58:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33826 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238Ab1HKI63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 04:58:29 -0400
Message-ID: <4E4399B3.3020909@suse.cz>
Date: Thu, 11 Aug 2011 10:58:27 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
Cc: Arnaud Lacombe <lacombar@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 2/2] Enable 'make CONFIG_FOO=y oldconfig'
References: <1312067499.22074.59.camel@i7.infradead.org>  <CACqU3MWn-OQVfLH96E+AeTCEjUw5+girXbuNgmUvXrEQuBe4vg@mail.gmail.com>  <4E4140B3.7090802@suse.cz>  <CACqU3MU4wJb3ij6skod-ZiM+Q0OMTXNdbJ+qWjJW8VZNEP+x1g@mail.gmail.com>  <4E4280BA.9050109@suse.cz> <1312981658.2989.39.camel@i7.infradead.org>  <CACqU3MUJkM3Y2o2Jx1eQxZkW2T-Dby1JCaks6SqTz_FB17hSvw@mail.gmail.com>  <1312985888.2989.46.camel@i7.infradead.org>  <CACqU3MXozgu0kr-4w=bGejcEi8MrxH-PhKa0Ji0zrLu7ZEFomg@mail.gmail.com>  <1312993987.2989.53.camel@i7.infradead.org>  <CACqU3MXC_eDqgWDwnVe8KsqoAMTPQNiP6YMHD5G+1sMBhMwXzA@mail.gmail.com>  <1312999168.2989.61.camel@i7.infradead.org>  <CACqU3MWB+4n5Acd-GboH5WbCzfZFiAc0wNvOkn_5O+--7jLE8A@mail.gmail.com>  <1313002322.2989.88.camel@i7.infradead.org>  <CACqU3MU2J25q-wWJ8LNcMkwi3uMigz_+0=XcrNiPC0TGiJHZqA@mail.gmail.com>  <1313018232.2989.114.camel@i7.infradead.org>  <CACqU3MVyjzr47N9v23SGaSjiEOGoEaP1-TZ4Z_RyVNgVXgPEwg@mail.gmail.com> <1313052168.18037.9.camel@i7.infradead.org>
In-Reply-To: <1313052168.18037.9.camel@i7.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.8.2011 10:42, David Woodhouse wrote:
> On Wed, 2011-08-10 at 23:29 -0400, Arnaud Lacombe wrote:
>> how is that supposed to work with your other patches ?
> 
> You cannot perform build targets with CONFIG symbols overridden.
> 
>> % make CONFIG_NET=y allyesconfig drivers/ata/ 
>         ^^^^^^^ override           ^^^^^^^^^^ build target
> 
>> Makefile:504: *** Cannot perform build targets with CONFIG symbols
>> overridden.  Stop.
> 
>  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ error message which
> told you that, if you'd been paying the slightest bit of attention
> rather than just making pointless noise.

I would much rather see include/config/auto.conf reset all configuration
variables to match what kconfig computed. I.e. use 'undefine CONFIG_FOO'
instead of '# CONFIG_FOO is not set'. Additionally print this for any
CONFIG_* variable found in the environment, even if the symbol is not
visible in the current configuration. The include/config/auto.conf file
is only used internally, so it should be safe to change the format.

Michal
