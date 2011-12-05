Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408Ab1LETRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:17:32 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46600 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab1LETRa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:17:30 -0500
MIME-Version: 1.0
In-Reply-To: <20111206060654.0e8bebe0@notabene.brown>
References: <20111205125416.6093ecd8@notabene.brown>
	<CAK=Wgbb-6eV6aDxTdi3qFLZmu0cHSZvHRUpUEr3YQ=4tO5sCPw@mail.gmail.com>
	<20111206060654.0e8bebe0@notabene.brown>
Date: Mon, 5 Dec 2011 13:17:29 -0600
X-Google-Sender-Auth: hP_Uke5maR-EYdXxFSpaV8vdY8g
Message-ID: <CAMLZHHRPvTSMAte_MO2VA-0B8_x=iPiY5L1T=pEBqn+zp62Arw@mail.gmail.com>
Subject: Re: [PATCH] mmc/sdio: don't allow interface to runtime-suspend until
 probe is finished.
From: Daniel Drake <dsd@laptop.org>
To: NeilBrown <neilb@suse.de>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-mmc@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, Joe Woodward <jw@terrafix.co.uk>,
        Chris Ball <cjb@laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 5, 2011 at 1:06 PM, NeilBrown <neilb@suse.de> wrote:
> The chip has a requirement that the reset line is held down during power-on,
> and raised shortly after (I don't know exactly how short).  So if you just
> remove power and give it back, the chip doesn't come up properly.

In another thread, Marvell confirmed that performing a SDIO reset is
sufficient, no reset line tweaking is needed in the face of a reset.

However, I would certainly advise playing with this reset line at the
point of failure - you could confirm if it is or isn't being tweaked
at this particular point, and if its not, you could try adjusting the
code to manipulate this line at this point to see if it helps at all.

Another area of experimentation is detailed here:
http://article.gmane.org/gmane.linux.kernel.mmc/11475
especially if you can confirm that mmc_send_if_cond is the source of
the failure.

Thanks,
Daniel
