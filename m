Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292Ab0LNWAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 17:00:09 -0500
Received: from smtp-out.google.com ([216.239.44.51]:46450 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab0LNWAH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 17:00:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=v7KCFkHNg4cEnCXp6fxI/OJsTMYCCMYZJXKNN3WYSdG5Q4b+82SiRvmdfiTgROwc2m
         5Dic70dh9AYWBfHP2OVA==
MIME-Version: 1.0
In-Reply-To: <1292362957.3446.851.camel@calx>
References: <20101214212846.17022.64836.stgit@mike.mtv.corp.google.com>
 <20101214213048.17022.58746.stgit@mike.mtv.corp.google.com> <1292362957.3446.851.camel@calx>
From: Mike Waychison <mikew@google.com>
Date: Tue, 14 Dec 2010 13:59:44 -0800
Message-ID: <AANLkTi=Q+LaS7yaU_4ThkhMUM-q8S3JTuwMWqAikQPgH@mail.gmail.com>
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

On Tue, Dec 14, 2010 at 1:42 PM, Matt Mackall <mpm@selenic.com> wrote:
> On Tue, 2010-12-14 at 13:30 -0800, Mike Waychison wrote:
>> Add support for letting userland define a 32bit boot id.  This is useful
>> for users to be able to correlate netoops reports to specific boot
>> instances offline.
>
> This sounds a lot like the pre-existing /proc/sys/kernel/random/boot_id
> that's used by kerneloops.org.

Could be.  I'm looking at it now... There is no documentation for this
boot_id field?

Reusing this guy would work, except that it doesn't appear to allow
arbitrary values to be set.  We need to inject our boot sequence
number (which is figured out in userland) in the packet somehow as we
need to correlate it to our other monitoring systems.

I agree that having the uuid included in the netoops messages would be
very useful.

netoops is probably the wrong place to have a system-wide boot
sequence ID set in retrospect.  For our purposes, I can have it
encoded into the 'user_blob' portion of the packet if folks don't
think the kernel should have any notion of boot sequence number
programmable by userland.
