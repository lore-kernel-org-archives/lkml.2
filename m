Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab1IHIsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 04:48:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932397Ab1IHIsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 04:48:35 -0400
Date: Thu, 8 Sep 2011 10:49:13 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Jonathan Nieder <jrnieder@gmail.com>, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>, linux-kernel@vger.kernel.org
Subject: Re: iwl4965: "MAC is in deep sleep!" freezes
Message-ID: <20110908084913.GB2195@redhat.com>
References: <bbdbd01d4965ae789384bc1f9d0a2426@imap.dd24.net>
 <20110902233806.GA22157@elie>
 <20110905091918.GC2221@redhat.com>
 <265f56a4dc9f5d3edeca3d101e445353@imap.dd24.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <265f56a4dc9f5d3edeca3d101e445353@imap.dd24.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 05, 2011 at 09:42:01AM +0000, Christoph Anton Mitterer wrote:
> On Mon, 5 Sep 2011 11:19:18 +0200, Stanislaw Gruszka <sgruszka@redhat.com>
> wrote:
> > this look like firmware hang. This happen just after module load, that's
> > good news, because it allow to log relative small amount debug messages
> > to see what possibly driver do wrong to crash firmware.
> Note, that the effects of - usually but not always - frozen system while
> the errors are printed (sometimes keyboard input seems still be possible
> during that) ... happen over and over again... say about every  10 minutes
> or so.
> Not just the first time the modules is loaded.
> Is the firmware loaded over and over again?
I think is not, but even if is, kernel should not crash. Can you grab
crash logs using photo camera, serial cable or netconsole, to allow to 
see where exactly crash happen and fix it.

> > Please configure syslog to log kernel debug messages.
> Will mail it later.

Firmware hang seems to happen when REPLY_LEDS_CMD command is send.
No idea if attached patch could help or not, but is worth to try it.
It prevent to send LED command asynchronously, when possibly some
other commands are pending in firmware.

If it does not help, please provide the same way captured debug
messages from 2.6.38 kernel, where drivers works. I'll compare
it with broken driver logs to figure out what broken driver
do differently.

Thanks
Stanislaw
