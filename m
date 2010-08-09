Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab0HIIxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 04:53:00 -0400
Received: from www84.your-server.de ([213.133.104.84]:40984 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab0HIIw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 04:52:59 -0400
Subject: Re: [PATCH] Add quick erase format option
From: Stefani Seibold <stefani@seibold.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
In-Reply-To: <1281343038.12908.25.camel@localhost>
References: <1281342353-18180-1-git-send-email-stefani@seibold.net>
	 <1281343038.12908.25.camel@localhost>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 09 Aug 2010 10:52:54 +0200
Message-ID: <1281343974.18398.13.camel@wall-e.seibold.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 09.08.2010, 09:37 +0100 schrieb David Woodhouse:
> On Mon, 2010-08-09 at 09:25 +0100, stefani@seibold.net wrote:
> > From: Stefani Seibold <stefani@seibold.net>
> > 
> > This patch add a quick format option which skips erasing of already erased
> > flash blocks. This is useful for first time production environments where
> > the flash arrived erased.
> > 
> > Signed-off-by: Stefani Seibold <stefani@seibold.net> 
> 
> This scares me, given the lengths we had to go to in JFFS2 to cope with
> blocks which *look* like they're erased, but which actually start losing
> data as soon as you start writing to them because the erase didn't
> complete.
> 

I know the drawback. This is why it is only an option which must be
enabled. And in most use cases there is a subsequent ubimkvol, which
will fail if the flash is not correct initialized.

Flash are normally delivered erased. So this save in our production
environment (Nokia Siemens Networks) about 5 minutes per device (256 MB
NOR CFI Flash).

The old JFFS2 was very fast to install the first time on a flash, it was
only a simple mount of the MTD partition. 

Which the quick format option i have now only a slightly first time
installation overhead compared to JFFS2. Without this option the
overhead is more than 5 minutes.

- Stefani


