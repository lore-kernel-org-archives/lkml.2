Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab0KONmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 08:42:45 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:47915 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755561Ab0KONmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 08:42:44 -0500
X-Sasl-enc: lOJTbO/r4l2N88zAL1+MqP8I/Zgw8BQH6+pcJyYlxyz3 1289828563
Subject: Re: autofs4 hang in 2.6.37-rc1
From: Ian Kent <raven@themaw.net>
To: Avi Kivity <avi@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, autofs@linux.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1289828296.3248.54.camel@localhost>
References: <4CDFDC2B.6040205@redhat.com> <4CE00194.3070601@redhat.com>
	 <1289785533.3248.18.camel@localhost>  <201011150954.34289.arnd@arndb.de>
	 <1289827341.3248.49.camel@localhost>  <4CE13539.1020106@redhat.com>
	 <1289828296.3248.54.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 21:42:38 +0800
Message-ID: <1289828558.3248.58.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 21:38 +0800, Ian Kent wrote:
> On Mon, 2010-11-15 at 15:27 +0200, Avi Kivity wrote:
> > On 11/15/2010 03:22 PM, Ian Kent wrote:
> > > >  Ian, if you can prove that the lock is not needed, I think we shold
> > > >  just remove it.
> > >
> > > I don't think I can prove it but I will have a long look at the code.
> > > I don't think it is needed and I expect I'll recommend it be removed.
> > 
> > I've been running with the lock removed for a while with no ill effect.  
> > Of course it doesn't prove anything but at least it's a workaround for me.
> 
> Yeah, I tried pretty hard over quite a long time, with the expectation
> that the BKL would be removed, to try and make the code independent of
> it. At one point patched the kernel to use the unlocked ioctl entry
> point during some development testing and found only one fix that was
> needed, although a lot has changed since then too.

Hahaha, although as you say, I won't really know if there are races
until I get people really hammering autofs. But, since that's were this
is at maybe that's reason enough to remove it so we can get people to
start applying pressure to the code so we find and fix any problems.

> 
> Ian
> 


