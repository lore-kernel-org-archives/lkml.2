Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab1LHRPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 12:15:39 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:50936 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751502Ab1LHRPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 12:15:38 -0500
X-Sasl-enc: tSx+wd1sP6IglgnlEvclp6MwHqICW2AByPsUxOpQLnrn 1323364537
Subject: Re: chroot(2) and bind mounts as non-root
From: Colin Walters <walters@verbum.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: John Stoffel <john@stoffel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 08 Dec 2011 12:15:17 -0500
In-Reply-To: <201112081704.22453.arnd@arndb.de>
References: <1323280461.10724.13.camel@lenny>
	 <20191.49202.793643.397028@quad.stoffel.home>
	 <201112081704.22453.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1323364518.10724.65.camel@lenny>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-08 at 17:04 +0000, Arnd Bergmann wrote:

> I think the better question to ask is what is missing from 'schroot', which
> is commonly used for exactly this purpose. Is it just about avoing the
> suid bit for /usr/bin/schroot or something else?

The trust model for schroot is that it only allows executing code
downloaded from URLs in /etc/schroot/schroot.conf.  That means it
requires root for the initial setup to edit that config file, which
disqualifies it from my use case (no part of the compilation should
require root).

In my approach, you can keep the OS tree (/usr/include, /usr/bin/gcc)
owned by the user - there is absolutely no root-owned process running
under any indirect control of the user (except the tiny bit for my new
setuid binary).

Now ultimately to *run* your installed program locally (say you're
hacking on a system daemon like gdm), then clearly you need root.  But
nothing before that should.  And if you're not running it locally (e.g.
you're cross compiling, running a build server which distributes
binaries to other machines), then there is no root required.


