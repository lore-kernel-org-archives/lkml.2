Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab1CIJDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 04:03:50 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47119 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811Ab1CIJDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 04:03:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=JVr/OpsB2wddxNvHaOw5GvudQ18wZfneWXps+tvOqHl4Li13RIL32CeBRDxNvNtKuE
         T2+CnjCMwqkn0X3UNcMOr6LFkWRvCWiiDut7CCCGWOFPHyVygBE7AIv5nIWLuCkZqs7B
         PJ5fU4ld3TFn9z53f55RFJeUAkCYRMeEOoJKI=
MIME-Version: 1.0
In-Reply-To: <20110309084222.GA3569@polaris.bitmath.org>
References: <1299601979-4871-1-git-send-email-benjamin.tissoires@enac.fr>
	<1299601979-4871-2-git-send-email-benjamin.tissoires@enac.fr>
	<20110309084222.GA3569@polaris.bitmath.org>
Date: Wed, 9 Mar 2011 10:03:45 +0100
X-Google-Sender-Auth: 5lOWmb1yb37DfhhZ5UYwk4xiWa8
Message-ID: <AANLkTin4KsPWRfFEEYXkjWdnEnXyiMyDGc6eEWFA_kWx@mail.gmail.com>
Subject: Re: [PATCH 1/4] hid-multitouch: Auto detection of maxcontacts
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 9, 2011 at 09:42, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> This patch enables support of autodetection of maxcontacts.
>> We can still manually provide maxcontact in case the device
>> lies on it.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>
> It seems quite alright to let the classes contain the expected number
> of contacts, so I do not really see the reason for that part of the
> patch. How about keeping the maxcontacts in the class, and then do
> max(hid-provided-maxcontacts, default-maxcontacts)?
>

Yep, I've got three particular reasons:
- 3M: there are two devices now, 1968 and 2256. The first one is a 10
touches only, whereas the second one is a 60 touches.
- autodetection of multitouch devices. I have some patches on my tree
(that we do not want to go upstream right now for some reasons) that
allows us to plug any unknown multitouch devices and to let
hid-multitouch handling it. As most of the devices are 2 touches only,
and as the generic way to work with a multitouch devices is to iterate
over all the slots, using 10 touches by default infers a lot of
instructions that can be avoided.
- finally, it simplifies the writing of the new CLS (we just need to
know how the device works to add the right quirks).

Cheers,
Benjamin
