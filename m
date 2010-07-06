Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab0GFNRB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 09:17:01 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:53146 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751649Ab0GFNRA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 09:17:00 -0400
X-Sasl-enc: EeY2HYtQF4G3kZIigTqFCF5IK/R+NuaK7jAu606O1PuK 1278422219
References: <1278195310-25590-1-git-send-email-arnd@arndb.de> <20100705195837.GF5240@nowhere> <1278378690.3070.6.camel@localhost> <201007061335.00264.arnd@arndb.de>
Message-Id: <202899B0-BADE-4CD0-B0E4-1A2FC99397D6@themaw.net>
From: Ian Kent <raven@themaw.net>
To: Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <201007061335.00264.arnd@arndb.de>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Mailer: iPad Mail (7B367)
Mime-Version: 1.0 (iPad Mail 7B367)
Subject: Re: [PATCH 3/6] autofs/autofs4: move compat_ioctl handling into fs
Date: Tue, 6 Jul 2010 21:17:16 +0800
Cc: Frederic Weisbecker <fweisbec@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       "autofs@linux.kernel.org" <autofs@linux.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/07/2010, at 7:35 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> 
> Well, the only use of the BKL in autofs4 is in the ioctl function. You
> can probably replace that trivially with a global mutex, but from a quick
> inspection, even that should not be needed: The only ioctl command in
> autofs4 that does not already seem to have adequate locking is
> autofs4_get_set_timeout, which is even easier to change and still harmless
> if you don't do it at all.

That's right of course.

Even this shouldn't be a problem as it is called by a single instance, per autofs mount, of the daemon only. A fair amount of effort has gone into trying to make the autofs4 module independent of the BKL over time. However I would still rather not do the change concurrently with the ioctl changes.

Ian
> 
