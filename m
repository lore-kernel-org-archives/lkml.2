Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab0LMUYk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 15:24:40 -0500
Received: from capside.net ([81.19.98.74]:37350 "EHLO eul0600410.eu.verio.net"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755034Ab0LMUYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 15:24:39 -0500
Date: Mon, 13 Dec 2010 21:24:30 +0100
From: =?iso-8859-1?Q?L=2E_Alberto_Gim=E9nez?= <agimenez@sysvalve.es>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH v2] Staging: rt2860: include KERN_* in printk
Message-ID: <20101213202429.GA6811@bart.evergreen.loc>
Mail-Followup-To: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
	devel@linuxdriverproject.org, Greg Kroah-Hartman <gregkh@suse.de>
References: <1292176591-26081-4-git-send-email-agimenez@sysvalve.es>
 <1292198324-12072-1-git-send-email-agimenez@sysvalve.es>
 <20101213183032.GA6147@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101213183032.GA6147@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 10:30:32AM -0800, Greg KH wrote:
> On Mon, Dec 13, 2010 at 12:58:44AM +0100, L. Alberto Giménez wrote:
> > Fix checkpatch complains.
> > 
> > The change of the DBGPRINT_ERR macro causes the change on the callers.
> 
> What change?

-#define DBGPRINT_ERR(Fmt)           \
-{                                   \
-    printk("ERROR! ");          \
-    printk Fmt;                  \
-}
+#define DBGPRINT_ERR(fmt, args...) printk(KERN_ERR fmt, ##args)

Recommended by Joe. I agree that it is cleaner and more compliant.
That macro needed that the callers use two parens, as in:

DBGPRINT_ERR(("MlmeInit failed, Status[=0x%08x]\n", Status));

With the introduced change, all calls to the DBGPRINT_ERR macro must be
translated to a regular single-parenthesized.

DBGPRINT_ERR("NICInitializeAdapter failed, Status[=0x%08x]\n", Status);

Yes, it's crap code, but I own an eeepc 901 and this was the perfect excuse to
get my harnds dirty :)

> 
> > 
> > Signed-off-by: L. Alberto Giménez <agimenez@sysvalve.es>
> > ---
> >  drivers/staging/rt2860/chip/rtmp_phy.h      |   14 ++++++------
> >  drivers/staging/rt2860/common/ba_action.c   |    6 ++--
> >  drivers/staging/rt2860/common/cmm_data.c    |    2 +-
> >  drivers/staging/rt2860/common/cmm_mac_pci.c |   10 ++++----
> >  drivers/staging/rt2860/common/cmm_mac_usb.c |    2 +-
> >  drivers/staging/rt2860/common/cmm_wpa.c     |   22 +++++++-----------
> >  drivers/staging/rt2860/common/ee_efuse.c    |   15 +++++++++---
> >  drivers/staging/rt2860/common/mlme.c        |   13 +++++------
> >  drivers/staging/rt2860/common/rt_rf.c       |    3 +-
> >  drivers/staging/rt2860/common/rtmp_init.c   |   24 ++++++++-----------
> >  drivers/staging/rt2860/common/rtmp_mcu.c    |    4 +-
> >  drivers/staging/rt2860/common/spectrum.c    |    2 +-
> >  drivers/staging/rt2860/pci_main_dev.c       |    2 +-
> >  drivers/staging/rt2860/rt_linux.c           |   21 ++++++++---------
> >  drivers/staging/rt2860/rt_linux.h           |    6 +----
> >  drivers/staging/rt2860/rt_main_dev.c        |    2 +-
> >  drivers/staging/rt2860/rt_usb.c             |   32 +++++++++++++-------------
> >  drivers/staging/rt2860/sta/assoc.c          |    2 +-
> >  drivers/staging/rt2860/sta/auth.c           |    3 +-
> >  drivers/staging/rt2860/sta/connect.c        |    3 +-
> >  drivers/staging/rt2860/sta/rtmp_data.c      |    2 +-
> >  drivers/staging/rt2860/sta/sync.c           |    6 ++--
> >  drivers/staging/rt2860/usb_main_dev.c       |   12 +++++-----
> >  23 files changed, 99 insertions(+), 109 deletions(-)
> 
> That's a lot of different changes all in one patch.  Care to break it up
> into a few different patches so it makes more sense?

I can break it up, but it made sense to me to group all KERN_* changes. That
included the DBGPRINT_ERR fix, that caused *a lot* of files to be changed as
well (to fix the macro call too).

Anyway, if you want me to split it up, please confirm :)

Regards,
-- 
L. Alberto Giménez
JabberID agimenez@jabber.sysvalve.es
GnuPG key ID 0x3BAABDE1
