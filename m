Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab2APWBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 17:01:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36867 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab2APWBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 17:01:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: Re: [Regression] Commit "tpm: Introduce function to poll for result of self test" breaks suspend
Date: Mon, 16 Jan 2012 23:05:15 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
References: <201201160022.07176.rjw@sisk.pl> <201201162142.34096.rjw@sisk.pl> <4F149360.70604@linux.vnet.ibm.com>
In-Reply-To: <4F149360.70604@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201201162305.15662.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 16, 2012, Stefan Berger wrote:
> On 01/16/2012 03:42 PM, Rafael J. Wysocki wrote:
> > On Monday, January 16, 2012, Stefan Berger wrote:
> >> On 01/15/2012 06:22 PM, Rafael J. Wysocki wrote:
> >>> Hi Stefan,
> >>>
> >> Hi Rafael,
> >>
> > That doesn't show anything too.
> >
> > However, after reverting the above commit I get:
> >
> > $ find /sys/devices -name caps | xargs cat
> > Manufacturer: 0x49465800
> > TCG version: 1.2
> > Firmware version: 1.2
> >
> > and system suspend works, although "find /sys/devices -name pcrs | xargs cat"
> > still doesn't show anything.
> 
> My guess is your TPM is disabled and/or deactivated and it that mode 
> doesn't like the sequence of commands we are sending to it. Well, I 
> guess the best is to revert the patch for now. I'll send a patch for this.

Thanks!

> What does
> 
> find /sys/devices -name active | xargs cat
> 
> currently show? If it shows a '0',

Yes, it does.

> can you try one other thing? Go into your machine's BIOS and find the TPM
> menu and enable/activate the device and try again the
> 'find's and suspend/resume again?

Well, so the problem with that is that it requires Windows to be installed
to change the settings (i.e. the machine has no BIOS setup as we know it).
So, practically, I really can't do that.

Thanks,
Rafael
