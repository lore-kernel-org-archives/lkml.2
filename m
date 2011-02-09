Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab1BIEbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 23:31:37 -0500
Received: from mail001.aei.ca ([206.123.6.130]:42327 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756326Ab1BIEbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 23:31:35 -0500
From: Ed Tomlinson <edt@aei.ca>
To: "Gadiyar, Anand" <gadiyar@ti.com>
Subject: Re: [BUG] usb problems in .38-rc3+
Date: Tue, 8 Feb 2011 23:31:26 -0500
User-Agent: KMail/1.13.6 (Linux/2.6.38-rc4-crc; KDE/4.6.0; x86_64; ; )
Cc: Oliver Neukum <oneukum@suse.de>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-usb@vger.kernel.org
References: <201102051417.58953.edt@aei.ca> <201102072115.20858.edt@aei.ca> <AANLkTinpKwe2vWH3=Ur+N76a6KyfuFp0V-EznXXS7m+p@mail.gmail.com>
In-Reply-To: <AANLkTinpKwe2vWH3=Ur+N76a6KyfuFp0V-EznXXS7m+p@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102082331.27644.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 February 2011 01:46:16 Gadiyar, Anand wrote:
> On Tue, Feb 8, 2011 at 7:45 AM, Ed Tomlinson <edt@aei.ca> wrote:
> > I tried bisecting without much luck.  It started with about 4000 commits to check.  It was still bad
> > when it reached the first 1000 commits post .37.  Then all boots started crashing.  I think its possible
> > to restrict a bisect to a directory - if so, what dir should I try?
> >
> 
> Maybe drivers/ or drivers/usb would be enough for a first attempt?
> I usually start there.
> 
> You could just do:
> 
> git bisect start -- [path]
> 
> to restrict bisection to commits that touch [path].

This is as far as I can get:

# bad: [100b33c8bd8a3235fd0b7948338d6cbb3db3c63d] Linux 2.6.38-rc4
# good: [3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5] Linux 2.6.37
# good: [387c31c7e5c9805b0aef8833d1731a5fe7bdea14] Linux 2.6.37-rc8
# good: [90a8a73c06cc32b609a880d48449d7083327e11a] Linux 2.6.37-rc7
# good: [c8ddb2713c624f432fa5fe3c7ecffcdda46ea0d4] Linux 2.6.37-rc1
git bisect start 'v2.6.38-rc4' 'v2.6.37' 'v2.6.37-rc8' 'v2.6.37-rc7' 'v2.6.37-rc1' '--' 'drivers/usb' 'drivers/bluetooth'
# good: [5cdc5bd8b2b1190cb54548c03194b154b4892e2a] Merge branch 'musb-hw' of git://gitorious.org/usb/usb into musb
git bisect good 5cdc5bd8b2b1190cb54548c03194b154b4892e2a
# bad: [f2c565e223af39ed38be5c84b1a37b591b22db83] xHCI: replace dev_dbg() with xhci_dbg()
git bisect bad f2c565e223af39ed38be5c84b1a37b591b22db83
# good: [2af10844eb6ed104f9505bf3a7ba3ceb02264f31] USB: Merge 2.6.37-rc5 into usb-next
git bisect good 2af10844eb6ed104f9505bf3a7ba3ceb02264f31
# bad: [3e5b08cbbf78bedd316904ab0cf3b27119433ee5] Merge branch 'usb-next' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6
git bisect bad 3e5b08cbbf78bedd316904ab0cf3b27119433ee5
# good: [1051b9f0f9eab8091fe3bf98320741adf36b4cfa] Merge branch 'for-rmk' of git://git.pengutronix.de/git/imx/linux-2.6 into devel-stable
git bisect good 1051b9f0f9eab8091fe3bf98320741adf36b4cfa

After this the kernel does not build.

Any clues?
Ed
