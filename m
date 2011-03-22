Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab1CVIyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 04:54:50 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64275 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab1CVIys convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 04:54:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EU4lYjpp7C9U1MXvCTlC3/Hi0A8AY8tgGWLtGnMHBu2ghSn7cjXiwQ3G/j+lG7Qrun
         inauinHirAleubRVmxzRcv0N38r/knaUREw6alSVWrKdul9DS/1l6Yy3+y8oX4EQdabn
         p7UGuXKC+q0Lx5E04cnVCjjShHtPAcp4pR4lQ=
MIME-Version: 1.0
In-Reply-To: <1300783365.2735.12.camel@localhost>
References: <4d8797d74168a6441@agluck-desktop.sc.intel.com>
	<1300783365.2735.12.camel@localhost>
Date: Tue, 22 Mar 2011 16:54:48 +0800
Message-ID: <AANLkTinu4jOGqhxutVZb_pwkFi+2oz4OfDqGEcOG_QUf@mail.gmail.com>
Subject: Re: [RFC] pstore: Don't use persistent store for normal shutdown
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Artem.Bityutskiy@nokia.com
Cc: "ext Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 4:42 PM, Artem Bityutskiy
<Artem.Bityutskiy@nokia.com> wrote:
> On Mon, 2011-03-21 at 11:24 -0700, ext Luck, Tony wrote:
>> In commit 04c6862c055fb687c90d9652f32c11a063df15cf
>> kmsg_dump: add kmsg_dump() calls to the reboot, halt, poweroff and emergency_restart paths
>>
>> Seiji Aguchi added kmsg_dump options for all the "normal" ways
>> that a system can be shut down (KEXEC, RESTART, HALT and POWEROFF).
>> It doesn't seem useful to save the kernel log to persistent store
>> in these cases.
>>
>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>>
>> ---
>>
>> My /dev/pstore changes have been merged - and I immediately noticed that they
>> now save a record on every shutdown.  Some simple detective work with git found
>> that kmsg_dump now has some new "reasons" for calling its subscribers.
>>
>> This patch excludes the four "normal shutdown" cases from being logged
>> to persistent store, on the assumption that we don't want to clutter up
>> a limited amount of storage space with routine data.  My presumption is
>> that there is some other subscriber to kmsg_dump that is doing something
>> with these reason codes ... is that right?  Or do you think that we should
>> save the tail of kernel log into persistent store for every shutdown?
>>
>> Perhaps we could save less data for these new reasons? Other ideas?
>
> If you ask me, this smells like policy in the kernel. I'd look into the
> direction of having only the mechanisms in the kernel and letting the
> user-space making policy decisions by choosing what he wants to filter
> out and what he wants to store via some pstore interfaces.
>

I agree, it would be nice if we can have another mount option for this.

Thanks.
