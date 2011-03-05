Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab1CELYd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 06:24:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54076 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab1CELYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 06:24:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [PATCH] power: disable hibernation if module loading is disabled
Date: Sat, 5 Mar 2011 12:24:18 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc7+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, security@kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        linux-pm@lists.linux-foundation.org
References: <1299255084-4390-1-git-send-email-segoon@openwall.com> <201103042330.25079.rjw@sisk.pl> <20110305103444.GA26773@albatros>
In-Reply-To: <20110305103444.GA26773@albatros>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103051224.18621.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, March 05, 2011, Vasiliy Kulikov wrote:
> On Fri, Mar 04, 2011 at 23:30 +0100, Rafael J. Wysocki wrote:
> > modules_disabled surely is not the right interface to disable hibernation
> > and I don't really think there's a bug because it doesn't work as you'd like
> > it to.  In fact, there would be a bug if it did work that way.
> 
> What do you mean here?  Do you agree that you may read kernel image,
> slightly change it (including e.g. possible checksums, I didn't bother
> to check how much one should change), and write it back?

Yes, you can, but that's not the point.  The point is that calling an interface
that disables all possible functionality modifying kernel memory
"modules_disabled" is completely dumb.  Sorry, but that's how it goes.

As I said before, if you want to have such an interface, call it properly
and introduce it along with documentation instead of changing an existing
one in a backwards-incopmatible fashion that in addition is totally
confusing.

Moreover, how are you going to protect your "protect kernel memory from
modification" interface itself from root access?
