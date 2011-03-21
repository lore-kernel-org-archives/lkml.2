Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab1CUWBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 18:01:17 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58076 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976Ab1CUWBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 18:01:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=rgr19HSoqAlVYSyqXPShZJ6y/ngCE8uT8Sz8oyoYYgJcrOOV3qs2+dW+9UUrTBoSit
         niN4xrW8UAziENKEP0tcgFTJsw4Vzc3FB+qJ0g8tcVIgxvjLeU/AA3wDslgt7SIzkgyM
         EeKn3WYHB4pRWRyYyDsfWU9FlJXV1Oj2ZfrKk=
MIME-Version: 1.0
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C14F5A4A0@USINDEVS01.corp.hds.com>
References: <4d8797d74168a6441@agluck-desktop.sc.intel.com>
	<5C4C569E8A4B9B42A84A977CF070A35B2C14F5A465@USINDEVS01.corp.hds.com>
	<AANLkTinG0381opyEFtM4P-OuFoG++b7kvpTC4McoL9E8@mail.gmail.com>
	<5C4C569E8A4B9B42A84A977CF070A35B2C14F5A4A0@USINDEVS01.corp.hds.com>
Date: Mon, 21 Mar 2011 15:01:14 -0700
X-Google-Sender-Auth: 5pdQTYP_G3n5rN3Rq4CTH0ThHLg
Message-ID: <AANLkTi=o3fN+aXSodZL_MyDnFczaXCmOjFwReD1jDZQP@mail.gmail.com>
Subject: Re: [RFC] pstore: Don't use persistent store for normal shutdown
From: Tony Luck <tony.luck@intel.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 2:47 PM, Seiji Aguchi <seiji.aguchi@hds.com> wrote:
> I think we should introduce a tunable parameter specifying how much data stores into persistent
> ram when normal shutdown happens.

Currently pstore has a /sys/fs/pstore hook to change the amount of data saved.
Christoph Hellwig convinced me that a mount option would be better, so there
is a patch pending to change this:
  http://marc.info/?l=linux-fsdevel&m=130048763005234&w=2

I can add more options easily (apart from thinking of good names for
the options :-)

But this is beginning to feel over engineered ... I think I'll wait to see
if there are some other (better) ideas before I rush to do this.

-Tony
