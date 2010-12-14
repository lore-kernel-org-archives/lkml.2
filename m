Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203Ab0LNXUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 18:20:16 -0500
Received: from smtp-out.google.com ([74.125.121.35]:54188 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab0LNXUN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 18:20:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=E/TLyl9n8N4t8xtIITaq0HpdhC2nq+1FYBKlf90MXnc0XIUzODBZu3mJBBKGnstMwn
         Xy3OcR5vPrMGwsutOmcA==
MIME-Version: 1.0
In-Reply-To: <1292366864.3446.875.camel@calx>
References: <20101214212846.17022.64836.stgit@mike.mtv.corp.google.com>
 <20101214213048.17022.58746.stgit@mike.mtv.corp.google.com>
 <1292362957.3446.851.camel@calx> <AANLkTi=Q+LaS7yaU_4ThkhMUM-q8S3JTuwMWqAikQPgH@mail.gmail.com>
 <1292364378.3446.854.camel@calx> <AANLkTineeFcSNx09P=2SZGcBHeq5p_LQ54nU=uGVv_Ck@mail.gmail.com>
 <1292366864.3446.875.camel@calx>
From: Mike Waychison <mikew@google.com>
Date: Tue, 14 Dec 2010 15:19:50 -0800
Message-ID: <AANLkTinugLaeuHjOAY6s=Vhwo-VOYr9dz7OE7GZFH+xK@mail.gmail.com>
Subject: Re: [PATCH v3 21/22] netoops: Add user-programmable boot_id
To: Matt Mackall <mpm@selenic.com>
Cc: simon.kagstrom@netinsight.net, davem@davemloft.net, nhorman@tuxdriver.com,
        adurbin@google.com, linux-kernel@vger.kernel.org, chavey@google.com,
        Greg KH <greg@kroah.com>, netdev@vger.kernel.org,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        akpm@linux-foundation.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 2:47 PM, Matt Mackall <mpm@selenic.com> wrote:
> On Tue, 2010-12-14 at 14:33 -0800, Mike Waychison wrote:
>> On Tue, Dec 14, 2010 at 2:06 PM, Matt Mackall <mpm@selenic.com> wrote:
>> > What happens if you oops before userspace is available?
>> >
>>
>> Either one of two general cases:
>>   - The crash is a one-off and the machine comes back.  The boot
>> number sequence will see a hole in it, which is a clue that something
>> bad happened.
>>   - The machine is in a crash loop.  This has the same failure mode
>> for us as if the machine never made it onto the network due to
>> whatever reason: bad cables, bad firmware, bad ram, ...
>>
>> In both cases, we can detect that something is wrong and handle it.
>> Note that our firmware is responsible for incrementing the boot
>> sequence at bootup, which is why the above works.   In general though,
>> our machines do make it up to userland -- staying alive once booted is
>> the hard part ;)
>
> Interesting. Is this Google-specific firmware magic?

Ya, this is a Google-ism.  I'd be surprised if there weren't other
platforms that had the same thing though (though I don't know of
anything standard on x86).

> I'd probably accept
> a hook in random.c to fold a number into the UUID, which would unify
> things.

I'm not sure there is a _good_ way to support this, is there?  I just
read through RFC 4122 and UUIDs seem to be pretty well structured;
it's probably not such a great idea to allow folks to override
portions of it.  Like I mentioned in my last email though, I'm okay
pushing this boot sequence ID down into the user blob which acts like
a place for "vendor extensions" if there isn't a good place for it in
the kernel.
