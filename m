Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab2CRXRa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 19:17:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51269 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086Ab2CRXR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 19:17:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Christian Lamparter <chunkeey@googlemail.com>
Subject: [PATCH 0/3] firmware_class: Fix problem with async requests (was: Re: [RFC] firmware loader: retry ...)
Date: Mon, 19 Mar 2012 00:15:42 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203032122.36745.chunkeey@googlemail.com> <201203180129.38469.rjw@sisk.pl> <201203181343.40760.chunkeey@googlemail.com>
In-Reply-To: <201203181343.40760.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203190015.42495.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, March 18, 2012, Christian Lamparter wrote:
> On Sunday 18 March 2012 01:29:38 Rafael J. Wysocki wrote:
> > The patch below (untested) goes slightly into that direction, although not as
> > far as to modify fw_create_instance().  It does, however, split
> > _request_firmware() into "prepare", "load" and "cleanup" parts and moves
> > the usermodehelper check along with the read-locking of umhelper_sem down
> > to the callers, ie. request_firmware() and request_firmware_work_func().
> > 
> > The difference between them is that request_firmware() fails immediately
> > with a WARN_ON() if it sees usermodehelper_disabled set after acquiring
> > umhelper_sem, while request_firmware_work_func() waits for
> > usermodehelper_disabled to be unset, with a timeout (the wait time is
> > subtracted from the _request_firmware() timeout).  The reason why
> > request_firmware_work_func() does it this way is that it can't wait for
> > usermodehelper_disabled to be unset with umhelper_sem held and it has to
> > call _request_firmware() under umhelper_sem (otherwise user space might be
> > frozen out from under it).
> > 
> > I'm falling asleep now, but hopefully the patch isn't totally busted. :-)
> > It should be split into a series of patches, though.
> I'm happy to report that my test system [with the patch applied] suspended
> and resumed without any incidents.

Thanks for testing!

The following three patches should result in analogous code, although slightly
cleaned up.

Thanks,
Rafael

