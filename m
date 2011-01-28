Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab1A1Smi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 13:42:38 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:32931 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753199Ab1A1Smh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 13:42:37 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 28 Jan 2011 19:43:26 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hid-multitouch: work on default classes and renaming
 of classes
Message-ID: <20110128184326.GB2553@polaris.bitmath.org>
References: <1296230680-2871-1-git-send-email-benjamin.tissoires@enac.fr>
 <20110128171852.GA2586@polaris.bitmath.org>
 <AANLkTimB2bA9JuhNox8UCsHkGEGyUQLBPnELBR0-=-ie@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimB2bA9JuhNox8UCsHkGEGyUQLBPnELBR0-=-ie@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.248.192.164
X-Scan-Result: No virus found in message 1PitHB-00073f-3u.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PitHB-00073f-3u 230d2f77dee2adda43677d6cd705e739
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> This patch introduce also MT_CLS_DUAL_DEFAULT which has the same purpose
> >> than MT_CLS_DEFAULT, but for dual touch panels.
> >
> > But it is used anywhere?
> 
> Hi Henrik,
> 
> In it's current form, no. I often rely on it to make a quick patch
> (just adding the ids in hid-ids, hid-core and hid-multitouch) to test
> a new (dual touch) device. I thought it would be useful to be
> mainstream.

I see. However, it is just as easy to keep as a local patch. Quite
generally, there really is a difference between what we do in our
computers and what ends up in mainline, and it is almost always for a
good reason.

> >> @@ -65,10 +66,11 @@ struct mt_class {
> >>  };
> >>
> >>  /* classes of device behavior */
> >> -#define MT_CLS_DEFAULT       1
> >> -#define MT_CLS_DUAL1 2
> >> -#define MT_CLS_DUAL2 3
> >> -#define MT_CLS_CYPRESS       4
> >> +#define MT_CLS_DEFAULT                               1
> >> +#define MT_CLS_DUAL_DEFAULT                  2
> >> +#define MT_CLS_DUAL_INRANGE_CONTACTID                3
> >> +#define MT_CLS_DUAL_INRANGE_CONTACTNUMBER    4
> >> +#define MT_CLS_CYPRESS                               10
> >
> > There is no need to change the numbering for unchanged names.
> 
> I just wanted to keep device-specific at the end of the list. Hence
> the 10 to keep a little space between generic and devices:
> MT_CLS_DUAL_CONFIDENCE_CONTACT* are coming...

It is very often the case that one would like to modify something to
keep to a certain aesthetic classification or idea, but there is a
very good reason not to do it. In order to maintain more than one
branch, for instance a stable tree and several distributions, having
simple patches makes a huge difference in maintenance burden. Not to
mention how hard it can be to merge trees with unrelated changes in
them. So please, keep patches short, sweet and to the point.

Thanks,
Henrik
