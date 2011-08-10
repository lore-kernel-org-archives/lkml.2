Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab1HJOUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:20:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:52863 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab1HJOUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:20:53 -0400
Subject: Re: [RESEND][PATCH 0/5] Support for the TS-5500 board
From: David Woodhouse <dwmw2@infradead.org>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Ike Panhc <ike.pan@canonical.com>, linux-kernel@vger.kernel.org,
        mjg@redhat.com, platform-driver-x86@vger.kernel.org
Date: Wed, 10 Aug 2011 15:20:46 +0100
In-Reply-To: <20110810100629.715c3bb7@v0nbox>
References: <1311887450-22235-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	 <20110809233208.1a71122e@lenov0n> <4E421CD8.3090606@canonical.com>
	 <CAHR064hamS0gHqQR5a5UAanN89CzzW94sjW6SB3=8MAcf6pkMg@mail.gmail.com>
	 <20110810100629.715c3bb7@v0nbox>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312986047.2989.47.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 10:06 -0400, Vivien Didelot wrote:
> > And btw, I'm not sure we really want to put all these drivers in
> > arch/x86/platform/ts5500/ a re-create the arm driver mess.
> > drivers/leds/, drivers/gpio/  and drivers/mtd/ are probably a best
> > choice.
> 
> In fact, this set of patches is a rewrite of the first RFC set, where
> we discussed that arch/x86/platform/ could be a good place, as the
> TS-5500 is a specific platform with its platform devices (the
> corresponding thread is here: https://lkml.org/lkml/2011/5/3/60). 

Just expose these devices in the device-tree. You shouldn't *need* a new
MTD device driver; physmap_of should be just fine.

If your bootloader doesn't pass one, your platform-specific code should
just register its own device-tree blob during early boot. And your
device drivers should just match against the devices therein.

-- 
dwmw2

