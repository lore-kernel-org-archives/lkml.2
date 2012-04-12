Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761835Ab2DLC0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 22:26:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51196 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757247Ab2DLC0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 22:26:43 -0400
Date: Thu, 12 Apr 2012 03:26:28 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kay Sievers <kay@vrfy.org>, "Ted Ts'o" <tytso@mit.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Greg Kroah-Hartman <gregkh@linux-foundation.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: RFC: deprecating/removing the legacy mode of devpts
Message-ID: <20120412022627.GJ6589@ZenIV.linux.org.uk>
References: <4F80892A.7050104@zytor.com>
 <20120407202056.472d8ad9@pyramind.ukuu.org.uk>
 <da8cd76d-6116-44a9-a7b3-7a501cb3a8a9@email.android.com>
 <20120407212705.GD11295@thunk.org>
 <4F80B9AC.2010103@zytor.com>
 <CAPXgP12Zp7aHev8Sh=3W0zHA-vZoR9TpTW8c7ep9vTQQQScBPg@mail.gmail.com>
 <4F81D254.9090000@zytor.com>
 <CAPXgP10-_kS7VtdWonBhOxKJD2KatB9SznZ_xUUaxBz7-boT2A@mail.gmail.com>
 <20120412010804.GI6589@ZenIV.linux.org.uk>
 <1ec3667a-e6f4-4032-a94b-89a6957c6252@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ec3667a-e6f4-4032-a94b-89a6957c6252@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 06:56:10PM -0700, H. Peter Anvin wrote:
> Just replace /dev/ptmx with a pts/ptmx symlink... something that works already.

It does *not* work for static setups - try to boot stock 3.3 on the root
fs with such a symlink and you've got a dangling symlink.  Have fun
trying to bisect something with repeated jumps back and forth across the
point where such change goes in...

It will also do no good on setups like e.g. debian/stable, with stock
udev - you need to edit /lib/udev/rules.d/50-udev-default.rules to get
that link created, with quite a bit of interesting kludgery to avoid the
same kind of crap (i.e. setup breaking when you boot an older kernel).
