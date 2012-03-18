Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab2CRMns (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 08:43:48 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57622 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab2CRMnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 08:43:47 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC] firmware loader: retry _nowait requests when userhelper is not yet available
Date: Sun, 18 Mar 2012 13:43:40 +0100
User-Agent: KMail/1.13.7 (Linux/3.3.0-rc7-wl+; KDE/4.7.4; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203032122.36745.chunkeey@googlemail.com> <CA+55aFxiJABjKJz4J6Dwk8Jy4=Vds2P15XTVtX8_j6TDkTwXEg@mail.gmail.com> <201203180129.38469.rjw@sisk.pl>
In-Reply-To: <201203180129.38469.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203181343.40760.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 March 2012 01:29:38 Rafael J. Wysocki wrote:
> The patch below (untested) goes slightly into that direction, although not as
> far as to modify fw_create_instance().  It does, however, split
> _request_firmware() into "prepare", "load" and "cleanup" parts and moves
> the usermodehelper check along with the read-locking of umhelper_sem down
> to the callers, ie. request_firmware() and request_firmware_work_func().
> 
> The difference between them is that request_firmware() fails immediately
> with a WARN_ON() if it sees usermodehelper_disabled set after acquiring
> umhelper_sem, while request_firmware_work_func() waits for
> usermodehelper_disabled to be unset, with a timeout (the wait time is
> subtracted from the _request_firmware() timeout).  The reason why
> request_firmware_work_func() does it this way is that it can't wait for
> usermodehelper_disabled to be unset with umhelper_sem held and it has to
> call _request_firmware() under umhelper_sem (otherwise user space might be
> frozen out from under it).
> 
> I'm falling asleep now, but hopefully the patch isn't totally busted. :-)
> It should be split into a series of patches, though.
I'm happy to report that my test system [with the patch applied] suspended
and resumed without any incidents.

Regards,
	Christian
