Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab0GFLfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 07:35:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60835 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab0GFLfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 07:35:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 3/6] autofs/autofs4: move compat_ioctl handling into fs
Date: Tue, 6 Jul 2010 13:35:00 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
       Al Viro <viro@zeniv.linux.org.uk>, autofs@linux.kernel.org
References: <1278195310-25590-1-git-send-email-arnd@arndb.de> <20100705195837.GF5240@nowhere> <1278378690.3070.6.camel@localhost>
In-Reply-To: <1278378690.3070.6.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007061335.00264.arnd@arndb.de>
X-Provags-ID: V02:K0:vgTcSf6GOyK7ixcB2PqLHsJeQayeHNjQhd1l3tVMPPs
 6NikPSfehaErfDUISAaymREadyu5HX+tHfD9e7/2yxYtofr0Wy
 IF0epIBIlswvai2dR5CCGS0O79pfQpufZ4GE0Rbx/2X8JcS/jm
 FKOem1uTEIY3s7TUWXb+hpCs3jrmdO8JyCd0UEpfknzRNLXMfk
 rc1j23JSg1npAY9jW56KQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 July 2010, Ian Kent wrote:
> So it makes no difference whether the patches are combined, if it breaks
> autofs then it probably won't be fixed but it may cause the replacement
> to happen sooner.

Well, the main point of applying the patch now is to avoid breaking the
autofs module when we remove the .ioctl operation.

> As far as the patch goes that should be fine and we should be able to
> remove the BKL from autofs4 soon after but I'm not brave enough to try
> just yet.

Well, the only use of the BKL in autofs4 is in the ioctl function. You
can probably replace that trivially with a global mutex, but from a quick
inspection, even that should not be needed: The only ioctl command in
autofs4 that does not already seem to have adequate locking is
autofs4_get_set_timeout, which is even easier to change and still harmless
if you don't do it at all.

	Arnd
