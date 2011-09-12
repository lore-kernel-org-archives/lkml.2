Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab1ILN7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 09:59:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774Ab1ILN7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 09:59:41 -0400
Message-ID: <4E6E0F43.6070307@redhat.com>
Date: Mon, 12 Sep 2011 09:55:15 -0400
From: Jarod Wilson <jarod@redhat.com>
User-Agent: Postbox 2.5.2 (Macintosh/20110804)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Sandy Harris <sandyinchina@gmail.com>, Steve Grubb <sgrubb@redhat.com>,
        Neil Horman <nhorman@redhat.com>, Tomas Mraz <tmraz@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert.xu@redhat.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: add blocking facility to urandom
References: <1314974248-1511-1-git-send-email-jarod@redhat.com> <1315464117.11199.51.camel@vespa.frost.loc> <20110908125234.GD13657@hmsreliant.think-freely.org> <201109080911.12921.sgrubb@redhat.com>            <CACXcFmnnMLHq2VE35i4QK4wNePXHJc6T73VQNTmJo7WEz34DaQ@mail.gmail.com> <118704.1315706746@turing-police.cc.vt.edu>
In-Reply-To: <118704.1315706746@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Fri, 09 Sep 2011 10:21:13 +0800, Sandy Harris said:
>> Barring a complete failure of SHA-1, an enemy who wants to
>> infer the state from outputs needs astronomically large amounts
>> of both data and effort.
>
> So let me get this straight - the movie-plot attack we're defending against is
> somebody readin literally gigabytes to terabytes (though I suspect realistic
> attacks will require peta/exabytes) of data from /dev/urandom, then performing
> all the data reduction needed to infer the state of enough of the entropy pool
> to infer all 160 bits of SHA-1 when only 80 bits are output...
>
> *and* doing it all without taking *any* action that adds any entropy to the
> pool, and *also* ensuring that no other programs add any entropy via their
> actions before the reading and data reduction completes. (Hint - if the
> attacker can do this, you're already pwned and have bigger problems)
>
> /me thinks RedHat needs to start insisting on random drug testing for
> their security experts at BSI.  EIther that, or force BSI to share the
> really good stuff they've been smoking, or they need to learn how huge
> a number 2^160 *really* is....

Well, previously, we were looking at simply improving random entropy 
contributions, but quoting Matt Mackall from here:

http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg05799.html

'I recommend you do some Google searches for "ssl timing attack" and 
"aes timing attack" to get a feel for the kind of seemingly impossible 
things that can be done and thereby recalibrate your scale of the 
impossible.'

:)

Note: I'm not a crypto person. At all. I'm just the "lucky" guy who got 
tagged to work on trying to implement various suggestions to satisfy 
various government agencies.

-- 
Jarod Wilson
jarod@redhat.com


