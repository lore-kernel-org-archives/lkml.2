Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965342Ab1KJQyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 11:54:36 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51093 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab1KJQyd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 11:54:33 -0500
MIME-Version: 1.0
In-Reply-To: <4EBBD936.40705@teksavvy.com>
References: <4EA89972.5060101@teksavvy.com>
	<20111026.194045.2019668159403582571.davem@davemloft.net>
	<4EA8B283.3010105@teksavvy.com>
	<20111026.221719.2216112919297458522.davem@davemloft.net>
	<4EB19BBE.5050602@teksavvy.com>
	<4EBAB8F5.1010101@teksavvy.com>
	<4EBBD936.40705@teksavvy.com>
Date: Thu, 10 Nov 2011 08:54:31 -0800
Message-ID: <CANEJEGuS1w_rPsjOfY8TqP=TewjRLSdEeR+OmaGB3G4LQZg82Q@mail.gmail.com>
Subject: Re: [PATCH v2] drivers/net/usb/asix: resync from vendor's copy
From: Grant Grundler <grundler@google.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>,
        Michal Marek <mmarek@suse.cz>, Freddy Xin <freddy@asix.com.tw>,
        "ASIX Allan Email [office]" <allan@asix.com.tw>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ASIX (Freddy Xin and Allan)

On Thu, Nov 10, 2011 at 6:01 AM, Mark Lord <kernel@teksavvy.com> wrote:
> On 11-11-09 12:31 PM, Mark Lord wrote:
>> Second pass (for review) at updating the in-kernel asix usb/network driver
>> from the v4.1.0 vendor GPL version of the driver, obtained from here:
>>
>>   http://www.asix.com.tw/download.php?sub=searchresult&PItemID=84&download=driver
>>
>> The original vendor copy used a local "axusbnet" middleware (rather than "usbnet").
>> I've converted it back to using "usbnet", made a ton of cosmetic changes
>> to get it to pass checkpatch.pl, and removed a small amount of code duplication.
>>
>> The tx/rx checksum code has been updated per Ben's comments,
>> and the duplicated MII_* definitions have been removed.
>> I've changed the version string to be "4.1.0-kernel",
>> to reflect the vendor's code version while also distinguishing
>> this port from the original vendor code.
>>
>> It can use more work going forward, but it is important to get it upstream
>> sooner than later -- the current in-kernel driver fails with many devices,
>> both old and new.  This updated version works with everything I have available
>> to test with, and also handles suspend / resume (unlike the in-kernel one).
>>
>> Signed-off-by: Mark Lord <mlord@pobox.com>
> ...
>
> Okay, the vendor has told me to cease development on this now.
> They prefer instead to feed small parts of their mainline driver
> to Grant Grundler as issues arise, rather than to get the whole
> thing upstream.

Hi Mark,
I'm very surprise a second time now. It's partly my own fault since
I'm not following netdev.  Until you contacted me privately 8 days
ago, I didn't know that you had been working with ASIX on asix.c. That
was the first surprise.

The second surprise is ASIX suggested I'm going to be the conduit for
all their patches upstream. I never committed to that.  I was very
clear that I would help them get started by feeding 3 small patches to
"upstream". I've fulfilled that commitment (3 fixes plus one cleanup).
  I have one more patch (work in progress:
https://gerrit.chromium.org/gerrit/11485 ) I'd like to see go in and
then they have to start "catching their own fish".

The statement above implies Google has an economic interest in their
products and AFAIK that's not true. We do not buy their product in
volume. Getting this working has sort of been my 20% project over the
past couple of months. It would have been cheaper buy USB ethernet
dongles from a vendor with working Linux support and *give* them to
our partners who need them.

Lastly, offlist I have expressed my opinion about 5K line patches to
you and to ASIX.  I'm not allowed to push such large patches into
Chromium.org (upstream first!) and I was certain on their own, ASIX
wouldn't get that upstream in one shot. No one knows them. No one
trusts them. Asix never mentioned that they had already hired you to
do it (and I am pretty sure you could have). So I feel a bit blind
sided (as you probably do to) by how events are unfolding here. ASIX
may still need help to *continue* upstreaming additional functionality
(e.g. CSO/TSO) and I will remind ASIX of that in future
communications.

*sigh*

cheers,
grant


> So be it.
>
> Cheers
>
