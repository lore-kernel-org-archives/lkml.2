Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab0GMPpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 11:45:15 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50637 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab0GMPpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 11:45:13 -0400
Date: Tue, 13 Jul 2010 11:35:31 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Alejandro Riveira =?iso-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>,
        Martin Steigerwald <Martin@lichtvoll.de>, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: rt2x00: slow wifi with correct basic rate bitmap (was Re:
 stable? quality assurance?)
Message-ID: <20100713153530.GC3835@tuxdriver.com>
References: <201007110918.42120.Martin@lichtvoll.de>
 <AANLkTimCwi2uJqqPaq3U30f3rvdDizu1BnaaXgvNeC9k@mail.gmail.com>
 <201007111651.42963.Martin@lichtvoll.de>
 <20100713131112.26a3da54@varda>
 <4C3C6106.3000909@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C3C6106.3000909@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 02:50:14PM +0200, Stefan Richter wrote:
> Alejandro Riveira Fernández wrote:
> >  I for one stopped booting into -rc kernels.
> >  The fact that still have to patch my kernels with a *one* liner
> >  since 2.6.29 kernel [1] does not give me confidence on the "test
> >  report/bisect and it will be fixed" promise some have made in this
> >  threath
> >  
> >  [1] https://bugzilla.kernel.org/show_bug.cgi?id=13362
> 
> There were promises made in this thread?  Then I must have read a
> different mailinglist or so.
> 
> I do not know why your WLAN regression has not been fixed yet, but at
> least it seems rather plausible why commit
> 7e0986c17f695952ce5d61ed793ce048ba90a661 is not going to be reverted (if
> such a revert is the one-liner that you are referring to).
> 
> Why is one reporter's rt2500 OK now though but not yours?  Are there
> different card revisions or firmwares out there that require quirk handling?

The patch (7e0986c1) corrects an obvious error.  Reverting it might
improve your (i.e. Alejandro) performance, but it seems likely to
cause connectivity problems for others.

The fact that reverting 7e098c1 helps you suggests that rt2500usb
isn't using the basic_rates map properly.  But after reviewing the
code and the data I have, I can't see what would be causing that.
It is at least possible that your AP is sending bad rate information.
Have you tried this device with other APs?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
