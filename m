Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab0LVVKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 16:10:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47022 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848Ab0LVVJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 16:09:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [linux-pm] [PATCH 2/2] i2c: Factor out runtime suspend checks from PM operations
Date: Wed, 22 Dec 2010 22:08:59 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc7+; KDE/4.4.4; x86_64; ; )
Cc: Rabin Vincent <rabin@rab.in>, Ben Dooks <ben-linux@fluff.org>,
        Jean Delvare <khali@linux-fr.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org,
        patches@opensource.wolfsonmicro.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1292855593-30608-1-git-send-email-broonie@opensource.wolfsonmicro.com> <AANLkTi=KOq65TS299rB=K961=mVXnriyqNxdHzJey5rD@mail.gmail.com> <20101222152550.GA16099@opensource.wolfsonmicro.com>
In-Reply-To: <20101222152550.GA16099@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012222208.59577.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 22, 2010, Mark Brown wrote:
> On Wed, Dec 22, 2010 at 08:40:23PM +0530, Rabin Vincent wrote:
> 
> > Shouldn't you be deleting the pm_runtime_* stuff from here?  There is
> > already done in pm_generic_restore() iff the callback exists and returns
> > zero.
> 
> I guess; it's not clear why this is being done by the bus at all or how
> it interacts with the legacy stuff.

It is done, because when the driver's ->resume() or ->restore() brings the
device up (which should have happened if it returned 0), we need to mark
the device as "active" for runtime PM.

Since __pm_generic_resume() does that, it's not necessary to do it in the
bus type callbacks (in the "legacy" case we known that runtime PM is not
supported).

Thanks,
Rafael
