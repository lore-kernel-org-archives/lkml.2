Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab1HKPvD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 11:51:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:55805 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab1HKPvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 11:51:00 -0400
Subject: Re: [PATCH 2/2] Enable 'make CONFIG_FOO=y oldconfig'
From: David Woodhouse <dwmw2@infradead.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Arnaud Lacombe <lacombar@gmail.com>, Andreas Schwab <schwab@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Date: Thu, 11 Aug 2011 16:50:34 +0100
In-Reply-To: <4E43F413.5000104@suse.cz>
References: <1312067499.22074.59.camel@i7.infradead.org>
	  <1312985888.2989.46.camel@i7.infradead.org>
	  <CACqU3MXozgu0kr-4w=bGejcEi8MrxH-PhKa0Ji0zrLu7ZEFomg@mail.gmail.com>
	  <1312993987.2989.53.camel@i7.infradead.org>
	  <CACqU3MXC_eDqgWDwnVe8KsqoAMTPQNiP6YMHD5G+1sMBhMwXzA@mail.gmail.com>
	  <1312999168.2989.61.camel@i7.infradead.org>
	  <CACqU3MWB+4n5Acd-GboH5WbCzfZFiAc0wNvOkn_5O+--7jLE8A@mail.gmail.com>
	  <1313002322.2989.88.camel@i7.infradead.org>
	  <CACqU3MU2J25q-wWJ8LNcMkwi3uMigz_+0=XcrNiPC0TGiJHZqA@mail.gmail.com>
	  <1313018232.2989.114.camel@i7.infradead.org>
	  <CACqU3MVyjzr47N9v23SGaSjiEOGoEaP1-TZ4Z_RyVNgVXgPEwg@mail.gmail.com>
	  <1313052168.18037.9.camel@i7.infradead.org> <4E4399B3.3020909@suse.cz>
	  <1313061012.18037.17.camel@i7.infradead.org> <m3r54std0x.fsf@hase.home>
	  <1313062813.18037.24.camel@i7.infradead.org> <4E43C363.3000103@suse.cz>
	  <CACqU3MVUeHTZ+cQYucYd8TvGoUOrwVhpxVpho-fqz3MkBTCTMQ@mail.gmail.com>
	 <1313075243.5632.6.camel@macbook.infradead.org> <4E43F413.5000104@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 8bit
Message-ID: <1313077836.18037.34.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 17:24 +0200, Michal Marek wrote:
> 
> One of my use cases for all.config is
> 
> $ cp .../older-working-config all.config
> $ make KCONFIG_ALLCONFIG=1 allmodconfig
> 
> i.e. reuse what is possible from an older config and enable all new
> options. Surely it sometimes results in suboptimal configuration with
> unwanted debug options enabled, but most of the time it works. I won't
> be happy if you make it hard fail because of renamed or removed config
> options. 

On the other hand, 'make CONFIG_FOO=y oldconfig' probably *should* fail.
Perhaps it should set what it *can*, if you try to set multiple options
at once — but if it can't set all of them, it should exit with failure
status... which will mean that no subsequent build target will happen.

-- 
dwmw2

