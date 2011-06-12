Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab1FLVII (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 17:08:08 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:38314 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab1FLVIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 17:08:06 -0400
X-SENDER-IP: [85.230.175.203]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aql0AIQq9U1V5q/LPGdsb2JhbABSiRGdPQsBAQEBNzKIcr4zDoYWBJYRiwI
X-IronPort-AV: E=Sophos;i="4.65,355,1304287200"; 
   d="scan'208";a="197521193"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sun, 12 Jun 2011 23:15:00 +0200
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid-multitouch: fix broken eGalax
Message-ID: <20110612211500.GA19269@polaris.bitmath.org>
References: <1307859728-3446-1-git-send-email-benjamin.tissoires@enac.fr>
 <20110612152915.GA18794@polaris.bitmath.org>
 <BANLkTikRPnNNVp=78BxvYZzp5A2HbBYEUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikRPnNNVp=78BxvYZzp5A2HbBYEUg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> >> With this patch, the detection is made only when the field ContactID
> >> has been detected inside the collection.
> >
> > The patch introduces an order dependence by relying on ContactID
> > occuring early on, which seems unnecessary. How about checking for the
> > presence of ContactID instead, and simply modify the logic which uses
> > last_field_index and last_slot_field?
> 
> That's exactly what it does. A touch report has to contain the
> contactID field. And each touch is at least in one collection (some
> devices send one touch per collection, others only one collection for
> the whole report).
> The idea is when hardware makers introduce several input mode for
> their device, they has to put them in different collections.

Ah, right you are, the ensured presence of ContactID is enough to
prove that the patch code is equivalent.

> The logic behind the last_field_index and last_slot_field are only for
> multitouch. So it does not matter if the contactID comes first or last
> in the collection, it will set the right index/field.

Thanks for the clarification.

    Reviewed-by: Henrik Rydberg <rydberg@euromail.se>

Cheers,
Henrik
