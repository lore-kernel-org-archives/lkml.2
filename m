Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456Ab2IEVJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 17:09:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:44617 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971Ab2IEVJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 17:09:34 -0400
Message-ID: <1346879334.19098.1.camel@pasglop>
Subject: Re: A workaround for request_firmware() stuck in module_init
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ming Lei <ming.lei@canonical.com>, Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kay Sievers <kay@vrfy.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 06 Sep 2012 07:08:54 +1000
In-Reply-To: <20120905173011.7a1111f0@pyramind.ukuu.org.uk>
References: <s5hd3222azc.wl%tiwai@suse.de>
	 <CACVXFVP-A7M2dG9bOvAnpzR60=iTYSw=WCOEwgo9KeuioxKanQ@mail.gmail.com>
	 <s5hd32122hw.wl%tiwai@suse.de>
	 <CACVXFVNE1GHAQJTrQy2AYgUBfq5kv42EjJJ7J+2q3jzXG-E=MQ@mail.gmail.com>
	 <s5hpq61j9qx.wl%tiwai@suse.de>
	 <CACVXFVOu86J5=1DLDrpLCd-pyk1jm2HT7ks1uzCXm9nURCRo2A@mail.gmail.com>
	 <20120905140304.5c5c58a4@pyramind.ukuu.org.uk>
	 <CACVXFVO+OgvLoFMcDD0gcQnbzUW=SyR=wiSMyT-FtpjWW5sWdw@mail.gmail.com>
	 <20120905173011.7a1111f0@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 17:30 +0100, Alan Cox wrote:
> 
> > Linus has said that he doesn't like to load firmware in probe(), but
> in some
> > situation the drivers have to load firmware in its probe():
> 
> You don't want to load firmware in probe because of the locking
> problems
> - you can trigger a load of another device on the same bus - the defer
>   dodges that nicely 

But then you have cases where probe() -> register_with_my_subsystem() ->
open(). Network devices come to mind. IE. udev must be able to deal with
a synchronous firmware load from probe I'm afraid.

The only other option would be to make full operation of the driver
delayed even from open(), which is possible with network devices at
least but generally very complex to implement.

Cheers,
Ben.


