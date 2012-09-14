Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab2INNxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:53:42 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60501 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab2INNxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:53:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAAcnjCR1x5_0o13qM5UJsWBh2D2xoSMw5WE4ky0Mzfz_v=6PqQ@mail.gmail.com>
References: <CAAcnjCR2c0qVCJEwH91ajnZ_vKHNFiUv8EUUU7x9ZTD+L5nOBg@mail.gmail.com>
 <20120913213535.GA21642@srcf.ucam.org> <CAAcnjCR1x5_0o13qM5UJsWBh2D2xoSMw5WE4ky0Mzfz_v=6PqQ@mail.gmail.com>
From: Paolo Giarrusso <p.giarrusso@gmail.com>
Date: Fri, 14 Sep 2012 15:53:19 +0200
Message-ID: <CAAcnjCTc2MuqvpznuUwBzoSu2NcX-fZqWO=O8yQLzy+g076d-w@mail.gmail.com>
Subject: Fwd: Linux hfsplus corrupts chflags bits?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re-sending to LKML - it was rejected because my phone sent the mail
also in HTML.]

On Thu, Sep 13, 2012 at 11:35 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> There was a similar problem with the userflags field - we were writing
> random data.
Ouch, sorry for the noise! I'm pretty sure it's exactly the same
problem: I wrote rootflags but meant userflags.
I might be wrong, but I think that's the case because your bugfix was
merged after 3.3. Instead I was running 3.2.

Somewhat unrelatedly, I noticed that most flags can't be set even by
ioctl, so Linux backup utilities can't preserve those flags.
Is that something which could be fixed, say by exposing them as
extended attributes?

I'll doublecheck that all randomly set flags are indeed userflags. To
be sure: userflags contains flags which can be set by the owner, while
rootflags can only be altered by the superuser, right? So I can check
here on Darwin's man chflags
(https://developer.apple.com/library/mac/#documentation/Darwin/Reference/ManPages/10.6/man1/chflags.1.html)

Cheers,
--
Paolo 'Blaisorblade' Giarrusso - Ph.D. Student
http://www.informatik.uni-marburg.de/~pgiarrusso/
