Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab2EMNFr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 09:05:47 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:41343 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921Ab2EMNFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 09:05:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bojan Smojver <bojan@rexursive.com>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
Date: Sun, 13 May 2012 15:10:37 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        bp@alien8.de
References: <1336515735.2097.23.camel@shrek.rexursive.com> <201205122347.08176.rjw@sisk.pl> <8b0184d9-0c54-4f6e-b0b7-ce1b7d854b9e@email.android.com>
In-Reply-To: <8b0184d9-0c54-4f6e-b0b7-ce1b7d854b9e@email.android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205131510.37664.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, May 13, 2012, Bojan Smojver wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> >On Wednesday, May 09, 2012, Bojan Smojver wrote:
> >> On Wed, 2012-05-09 at 13:40 +0530, Srivatsa S. Bhat wrote:
> >> > > +             error = suspend_devices_and_enter(PM_SUSPEND_MEM);
> >> > 
> >> > 
> >> > I can imagine running into a host of problems here, since the
> >suspend
> >> > sequence is not carried out fully, from the beginning.
> >> > 
> >> > For example, this will skip sending out the PM_SUSPEND_PREPARE and
> >the
> >> > PM_POST_SUSPEND notifiers. Worse, we actually send out the
> >> > PM_HIBERNATION_PREPARE
> >> > and PM_POST_HIBERNATION notifiers and then do a suspend instead,
> >> > underneath!
> >> > 
> >> > (Similar cases for the rest of the notifiers sent during suspend vs
> >> > hibernation).
> >> > 
> >> > Don't we need to handle such things properly, in order to make
> >> > suspend-to-both
> >> > work reliably? 
> >> 
> >> Honest answer - I have absolutely no idea. I've seen the code of
> >> suspend-utils (i.e. user mode stuff) and it seems to me that it does
> >> exactly this. Could be wrong of course, just like many times before.
> >> 
> >> Rafael?
> >
> >Sorry, that has fallen out of my radar somehow.
> >
> >Srivatsa is right, we should generally pay attention to those details.
> >
> >I think we should generally use a different "prepare" notification for
> >the
> >save-image-and-suspend case.
> >
> >Thanks,
> >Rafael
> 
> 
> OK, I will try to rework then, if that is the case.
> 
> What I don't understand is this: should the hibernation fail for some reason,
> we would get the same hibernation code unwind that failure, right?

Yes, if the failure happens before we attempt to suspend.

> So, a suspend after the image write will be just one long "failure", after
> which hibernation code has to unwind again. No?

Hmm.  Good question.  It should be like this I think, although there may be
some corner cases lurking.

Thanks,
Rafael
