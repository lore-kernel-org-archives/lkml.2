Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab1EMGYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 02:24:19 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35168 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab1EMGYS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 02:24:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=YQKBGCYCnEpOSQZCpgLYj+UY1HxDopc4Juvmew25FcxbZ6dBxBpN59srt+kEN0Nvmz
         Wun71PMWLxo4rrL3DK5Ipp7DVLIfLzAHmfDf4G4Dr/Nk/Iz+uadiInfJlNvneTUlWtKw
         E4ie3SfQ/NEP3BsKrlAzHJ0rRdUAMbHRPKbkk=
MIME-Version: 1.0
In-Reply-To: <20110513061252.GV28888@outflux.net>
References: <BANLkTim8mAzZbdOhBodaOFKM5esP-Q+K7g@mail.gmail.com>
	<20110512.140630.1779004012724490077.davem@davemloft.net>
	<20110512183741.GA22269@redhat.com>
	<20110512.150132.1679483014638599288.davem@davemloft.net>
	<BANLkTimUko9Y-spdzQFDEvZBjaKSaJrHBw@mail.gmail.com>
	<20110513061252.GV28888@outflux.net>
Date: Fri, 13 May 2011 09:24:17 +0300
X-Google-Sender-Auth: 4MWrxHoR27fHZZ6dA0ziJZHkm_Y
Message-ID: <BANLkTim39AFWkNHi6BOpdoOqzJTX1e96gg@mail.gmail.com>
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
From: Pekka Enberg <penberg@kernel.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: David Miller <davem@davemloft.net>, davej@redhat.com, eranian@google.com,
        acme@redhat.com, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kees,

On Fri, May 13, 2011 at 9:12 AM, Kees Cook <kees.cook@canonical.com> wrote:
> Hi Pekka,
>
> On Thu, May 12, 2011 at 10:58:53PM +0300, Pekka Enberg wrote:
>> On Thu, May 12, 2011 at 10:01 PM, David Miller <davem@davemloft.net> wrote:
>> > From: Dave Jones <davej@redhat.com>
>> > Date: Thu, 12 May 2011 14:37:41 -0400
>> >
>> >> On Thu, May 12, 2011 at 02:06:30PM -0400, David Miller wrote:
>> >>  > I hate this too, and I think it's absolutely rediculous.
>> >>  >
>> >>  > Also, like you, I lost an entire afternoon trying to figure out why
>> >>  > this started happening.
>> >>  >
>> >>  > I wish we could revert this change.
>> >>
>> >> At least it can be permanently disabled..
>> >>
>> >> echo kernel.kptr_restrict = 0 >> /etc/sysctl.conf
>> >
>> > Regardless, what to do about all of the "perf is broken" reports?
>>
>> Lets revert the commit 9f36e2c448007b54851e7e4fa48da97d1477a175
>> ("printk: use %pK for /proc/kallsyms and /proc/modules"), please! I
>> too have been wondering what's going on with perf reporting insane
>> symbols and this should definitely not be enabled by default.
>
> No, reverting that is not the answer. If perf has a problem with the
> kptr_restrict feature, it should just disable it in /proc/sys when it
> runs and restore it when finished. Since our defaults should be secure
> for the average user (who does not use perf), it's fine the way it
> is. Anyone using perf can adjust this for their use-case (that is why
> there is a /proc/sys tunable).

No, it's the other way around. See commit
411f05f123cbd7f8aa1edcae86970755a6e2a9d9 ("vsprintf: Turn
kptr_restrict off by default") in Linus' tree for details.

                        Pekka
