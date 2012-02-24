Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab2BXXPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 18:15:37 -0500
Received: from r00tworld.com ([212.85.137.150]:53456 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932404Ab2BXXPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 18:15:36 -0500
From: "PaX Team" <pageexec@freemail.hu>
To: Greg KH <gregkh@linuxfoundation.org>, David Windsor <dwindsor@gmail.com>
Date: Sat, 25 Feb 2012 00:14:43 +0200
MIME-Version: 1.0
Subject: Re: [kernel-hardening] Re: Add overflow protection to kref
Reply-to: pageexec@freemail.hu
CC: Roland Dreier <roland@purestorage.com>, Djalal Harouni <tixxdz@opendz.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>,
        Ubuntu security discussion <ubuntu-hardened@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org, spender@grsecurity.net
Message-ID: <4F4819E3.23795.217CF269@pageexec.freemail.hu>
In-reply-to: <CAEXv5_jEW6EA6nOd6pMJbh6PTd=+piHqzNA8Fb+gt2VGroba0A@mail.gmail.com>
References: <CAEXv5_gkTsPHDFh+wQqD3P3D-Z+uCN-_1bVyHfHV=u7bS-tgeA@mail.gmail.com>, <20120224183726.GB23284@kroah.com>, <CAEXv5_jEW6EA6nOd6pMJbh6PTd=+piHqzNA8Fb+gt2VGroba0A@mail.gmail.com>
X-mailer: Pegasus Mail for Windows (4.63)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Sat, 25 Feb 2012 00:14:52 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 Feb 2012 at 14:04, David Windsor wrote:

> Suggestions on recovering from an overflow here?

do what PaX does? :)

1. saturate the refcount
2. report the event (pax_report_refcount_overflow)
3. kill the triggering userland process (this may be optional but it's a good measure
   if you have stuff like grsecurity's lockout feature)

> 2. Detect the overflow before it happens, don't increment the counter,
> issue a warning but no BUG.
> This could also lead to some "undefined" behavior in subsystems.

it's called a memory leak :).

