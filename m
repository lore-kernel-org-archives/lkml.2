Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab0KRLMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 06:12:03 -0500
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:49930 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751408Ab0KRLMA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 06:12:00 -0500
X-AuditID: 12074422-b7c3eae000000a70-54-4ce509ff0e9a
Subject: Re: Challenges with doing hardware bring up with Linux first
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <AANLkTim4jVaZxYp8nSgJyy28iwxcxbPeNUzxTfoHAX4S@mail.gmail.com>
Date: Thu, 18 Nov 2010 06:11:49 -0500
Cc: linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
        Charles Marker <Charles.Marker@atheros.com>,
        Jouni Malinen <Jouni.Malinen@atheros.com>,
        Kevin Hayes <kevin@atheros.com>, Zhifeng Cai <zhifeng.cai@atheros.com>,
        "Luis R. Rodriguez" <mcgrof@gmail.com>,
        Don Breslin <Don.Breslin@atheros.com>,
        Doug Dahlby <Doug.Dahlby@atheros.com>, Julia Lawall <julia@diku.dk>
Content-Transfer-Encoding: 8BIT
Message-Id: <F46C52ED-8DB8-4347-957D-B9D84406D53F@mit.edu>
References: <AANLkTim4jVaZxYp8nSgJyy28iwxcxbPeNUzxTfoHAX4S@mail.gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
X-Mailer: Apple Mail (2.1082)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis,

I'm having a little trouble understanding what it is your proposing.

I *think* you are suggesting that

a)  Some portion of the "OS agnostic crap" be relicensed under a BSD or Apache-style license.   And I think what you are suggesting would fall in that camp is the parts of the Linux 802.11 stack?

b)  That the "OS agnostic crap" be moved into staging.

Can we ignore where the code lives for now?   I think (b) doesn't make any sense at all.

And as far as (b) is concerned, I think what you are suggesting isn't so much about the code, but trying to somehow encourage, via the carrot of making ti easy to push vendors into agreeing that the Linux 802.11 wireless API should be considered the OS independent interface layer that random vendors creating 802.11 drivers can interface against.

And to make that easy, you want to relicense the 802.11 stack under a BSD/Apache license so that it makes life easy for people who are creating drivers for Windows XP.   Do I have that right?

Assuming I understand the motivations of your proposal and what it is you were proposing in the first place, might another course of action which might prove as efficient, if not more so in the long term, is for some volunteer (perhaps at Atheros) to create some freely licensed new code that creates a glue layer between the Linux interfaces that wireless drivers use to plug into Linux's 802.11 layer, and to the 802.11 layer for Windows 7 and Mac OS X.    Furthermore, to make this glue layer GPL with the exception clauses that allows the glue code to link into Windows 7 and Mac OS X.

What this provides for is a wonderful leverage for hardware vendors.   If they provide GPL'ed code for their core hardware drivers that link against the Linux 802.11 layer, at one fell swoop they also get Windows 7 and Mac OS X drivers for free!   Better yet, it doesn't require getting permission from the Linux world, since what is necessary is the existence of new glue code that allows the hardware dependent code that previously was Linux specific, and which now allows it to plug into the glue code which then allows it to become hardware independent code for Windows 7 and Mac OS X.

-- Ted

