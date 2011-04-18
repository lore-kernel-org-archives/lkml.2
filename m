Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab1DRJUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 05:20:31 -0400
Received: from be1ssnxpe1.nxp.com ([57.67.164.69]:49011 "EHLO
	be1ssnxpe1.nxp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1DRJU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 05:20:27 -0400
X-Greylist: delayed 1592 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Apr 2011 05:20:27 EDT
From: Arjan Mels <arjan.mels@nxp.com>
To: Greg KH <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "stable-review@kernel.org" <stable-review@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Arjan Mels <arjan.mels@gmx.net>,
        Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>,
        Max Vozeler <max@vozeler.com>
Date: Mon, 18 Apr 2011 10:50:11 +0200
Subject: RE: [12/74] staging: usbip: bugfixes related to kthread conversion
Thread-Topic: [12/74] staging: usbip: bugfixes related to kthread conversion
Thread-Index: Acv9jjHaZjbLaK0+RvSYwb9cpN96bQAB6rkw
Message-ID: <81F20834D108E141A9502ADE39F489D60DBA6CE617@eu1rdcrdc1wx031.exi.nxp.com>
References: <20110413155144.231263288@clark.kroah.org>
 <201104172215.01736.arnd@arndb.de> <20110418060255.GC22168@suse.de>
In-Reply-To: <20110418060255.GC22168@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-04-18_03:2011-04-18,2011-04-18,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3I9Kfw5006308

I agree that the bugfix will do no harm on older versions. I have however not seen this particular deadlock occurring on versions before the kthread conversion: the thread termination works differently here (not by polling), so the fix is probably not necessary on older versions.

Apologies for not responding to this before: these were my first patches and I had not realized bugfixes would also be backported to older versions.

Best Regards,

Arjan Mels

â–¬â–¬â–¬â–¬â–¬â–¬â–¬â–¬â–¬â–¬â–¬â–¬â–¬â–¬â–¬â–¬â–¬â–¬â–¬â–¬â–¬â–¬â–¬â–¬â–¬â–¬â–¬â–¬â–¬â–¬â–¬â–¬
Arjan Mels
Principal Engineer
Device Physics / Wafer Technology and Foundry Organization (WT&FO) / Operations

NXP Semiconductors 
FB 3.057, Gerstweg 2, 6534AE Nijmegen, The Netherlands 
Phone : + 31 24 353 5330
E-mail : arjan.mels@nxp.com
XFB : nlv07682@seri02


-----Original Message-----
From: Greg KH [mailto:gregkh@suse.de] 
Sent: Monday, April 18, 2011 08:03
To: Arnd Bergmann
Cc: linux-kernel@vger.kernel.org; stable@kernel.org; stable-review@kernel.org; torvalds@linux-foundation.org; akpm@linux-foundation.org; alan@lxorguk.ukuu.org.uk; Arjan Mels; Takahiro Hirofuchi; Max Vozeler
Subject: Re: [12/74] staging: usbip: bugfixes related to kthread conversion

On Sun, Apr 17, 2011 at 10:15:01PM +0200, Arnd Bergmann wrote:
> On Wednesday 13 April 2011, Greg KH wrote:
> > From: Arjan Mels <arjan.mels@gmx.net>
> > 
> > commit d2dd0b07c3e725d386d20294ec906f7ddef207fa upstream.
> > 
> > When doing a usb port reset do a queued reset instead to prevent a
> > deadlock: the reset will cause the driver to unbind, causing the
> > usb_driver_lock_for_reset to stall.
> > 
> > Signed-off-by: Arjan Mels <arjan.mels@gmx.net>
> > Cc: Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>
> > Cc: Max Vozeler <max@vozeler.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> 
> I think either the subject line is misleading or the patch is not
> needed in -stable. The kthread conversion was done in 2.6.38, so
> any bug introduced by it would not need to be fixed in an earlier
> version, afaict.

Yes, the Subject: was incorrect, and I only realized it after it was
committed to the tree, sorry.

The bug fixes were still real.

thanks,

greg k-h
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
