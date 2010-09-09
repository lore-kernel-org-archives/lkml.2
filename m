Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab0IILQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 07:16:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51107 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab0IILQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 07:16:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] annotating the remaining BKL users
Date: Thu, 9 Sep 2010 13:15:54 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
        Sam Ravnborg <sam@ravnborg.org>, Jan Blunck <jblunck@suse.de>,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
References: <201009082255.33035.arnd@arndb.de> <AANLkTikfLb+kDZN8aodPwxFuL_VOuyb7AH=eF60MwrWG@mail.gmail.com>
In-Reply-To: <AANLkTikfLb+kDZN8aodPwxFuL_VOuyb7AH=eF60MwrWG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009091315.54910.arnd@arndb.de>
X-Provags-ID: V02:K0:YYrCqeB1CZnmqJGcmRFucmPB3vs2G0QKpy72+A6ChDF
 mFNBcdomvOMyuyQ07Y6eFz9tGk3Ebmykt1fQgp040FrSQU3UuW
 RdU7QLgx4jGGfWXUI/PkdjbphofLZ8m+KNmLRN/7VQd1C5GfQ+
 l3vTJ+gNEKAsywan9l1fpac78Zz9YmmsJ5vi+dSmPFw/IeaIR8
 oVvkc1B/Yizw28aTjVTgg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 September 2010, Linus Torvalds wrote:
> On Wed, Sep 8, 2010 at 1:55 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > I'd like to hear preferences for one approach or the other,
> > especially from Linus, so we can give this some better testing
> > in -next before the merge window.
> 
> Hmm. I like your patch. It seems to have a good balance of "select
> BKL" (for architectures that require it for some reason) and "depends
> on BKL" (for individual modules).

Actually, I was using "select" only for the cases where there is no
other option, like architectures that unconditionally reuire it.

> That said, I'd also like to see a comment _why_ the architectures in
> question depends on the BKL. Some of those look pretty historical (the
> sparc32 register window spill code? Does it _really_ need the BKL at
> all, or is that just a remnant of "let's get the BKL at each kernel
> entry").

Right. I'm pretty sure we can trivially fix all the arch code, I just
had no incentive to start that yet and instead did the annotations.
 
> So with the added rule that "each select BKL needs a quick comment
> why", I'd be happy with it. And maybe it would make people take a
> second look.

Ok. Making people take a look was also a reason why I posted this patch
separately. I might actually add comments to all of the "depends on BKL"
as well to make it clear which category they all fall into and motivate
janitors to take care of the easy ones.

As mentioned in another thread, the only nontrivial ones besides
fs/{locks.c,lockd} (which we need to fix before the BKL can become
optional) are probably:

drivers/{media,staging,usb/gadget,char/raw}
fs/{autofs,coda,hpfs,isofs,ncpfs,nfs,smbfs,udf,ufs}
net/{appletalk,ipx,irda,ax25}

	Arnd
