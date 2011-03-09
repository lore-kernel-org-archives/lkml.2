Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab1CIJhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 04:37:47 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:57048 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756745Ab1CIJho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 04:37:44 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 9 Mar 2011 10:38:09 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] hid-multitouch: Auto detection of maxcontacts
Message-ID: <20110309093809.GA3980@polaris.bitmath.org>
References: <1299601979-4871-1-git-send-email-benjamin.tissoires@enac.fr>
 <1299601979-4871-2-git-send-email-benjamin.tissoires@enac.fr>
 <20110309084222.GA3569@polaris.bitmath.org>
 <AANLkTin4KsPWRfFEEYXkjWdnEnXyiMyDGc6eEWFA_kWx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin4KsPWRfFEEYXkjWdnEnXyiMyDGc6eEWFA_kWx@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1PxFnh-0004pt-51.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PxFnh-0004pt-51 436a8f427dc304fff966adbbb1f2fb19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 10:03:45AM +0100, Benjamin Tissoires wrote:
> On Wed, Mar 9, 2011 at 09:42, Henrik Rydberg <rydberg@euromail.se> wrote:
> > Hi Benjamin,
> >
> >> This patch enables support of autodetection of maxcontacts.
> >> We can still manually provide maxcontact in case the device
> >> lies on it.
> >>
> >> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> >
> > It seems quite alright to let the classes contain the expected number
> > of contacts, so I do not really see the reason for that part of the
> > patch. How about keeping the maxcontacts in the class, and then do
> > max(hid-provided-maxcontacts, default-maxcontacts)?
> >
> 
> Yep, I've got three particular reasons:
> - 3M: there are two devices now, 1968 and 2256. The first one is a 10
> touches only, whereas the second one is a 60 touches.

Right, so increasing the number of touches based on device information
seems like a good idea.

> - autodetection of multitouch devices. I have some patches on my tree
> (that we do not want to go upstream right now for some reasons) that
> allows us to plug any unknown multitouch devices and to let
> hid-multitouch handling it. As most of the devices are 2 touches only,
> and as the generic way to work with a multitouch devices is to iterate
> over all the slots, using 10 touches by default infers a lot of
> instructions that can be avoided.

Right, so keeping the default number of touches per class seems like a
good idea.

> - finally, it simplifies the writing of the new CLS (we just need to
> know how the device works to add the right quirks).

Right, we always need to know how the device works. :-)

Cheers,
Henrik
