Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab0I2IHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 04:07:21 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37499 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab0I2IHR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 04:07:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RCYSc9JNaewkqPnopiyjsglydbmbCx+2yHTZJQ/NvzuWv4bRLntvyN7zlvYt+Arth+
         Qyd0STNpEI0o4DP/5Qxpn5NnZg3sPr+fWKECcK7B6Skt3pX+PB0e8iPCqAIZVsotx/xf
         enbubkgq/CqeadIIzrFwrRP6DJRYhLqQme+q4=
MIME-Version: 1.0
In-Reply-To: <20100928152733.GE13563@erda.amd.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
	<1285549026-5008-6-git-send-email-ying.huang@intel.com>
	<20100927100901.GC32222@erda.amd.com>
	<AANLkTimY5hr3DgN9=v83Z289MkzjgX8k0WzdTWZbGorj@mail.gmail.com>
	<20100927133816.GP13563@erda.amd.com>
	<1285636761.20791.133.camel@yhuang-dev>
	<20100928152733.GE13563@erda.amd.com>
Date: Wed, 29 Sep 2010 16:07:17 +0800
Message-ID: <AANLkTimzBaQxTJFq5opMG+crpsC-gf+KDjq9Hcs_r0SR@mail.gmail.com>
Subject: Re: [PATCH -v2 6/7] x86, NMI, Add support to notify hardware error
 with unknown NMI
From: huang ying <huang.ying.caritas@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Huang Ying <ying.huang@intel.com>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 11:27 PM, Robert Richter <robert.richter@amd.com> wrote:
> On 27.09.10 21:19:21, Huang Ying wrote:
>> On Mon, 2010-09-27 at 21:38 +0800, Robert Richter wrote:
>> > On 27.09.10 08:47:53, huang ying wrote:
>> >
>> > > >>  arch/x86/kernel/hwerr.c    |   55 +++++++++++++++++++++++++++++++++++++++++++++
>> > > >
>> > > > Instead of creating this file the code should be implemented in
>> > > >
>> > > >  arch/x86/kernel/cpu/intel.c
>> > > >
>> > > > Similar AMD NB code is implemented in amd.c and k8.c.
>> > >
>> > > Why? This file is not vendor specific.
>> >
>> > No, it only implements an Intel specific PCI device, nothing else.
>>
>> You can add AMD specific PCI device here too. We will add more device ID
>> in the future.
>
> I think it is not worth to introduce this file. There is no generic
> code in and we have over places for vendor specific code.

It's not vendor specific code. It is general code. In fact it is a
white list for systems that can treat unknown NMI as hardware error
(no broken hardware to generate unknown NMI). If you can find an
appropriate existing file, I am very glad to put the contents of this
file into it.

>> No. We do NOT catch unknown NMIs for a certain hardware here. We put the
>> code here because we think it is general instead of hardware specific.
>>
>> It should be a general rule to treat unknown NMI as hardware error. But
>> to avoid to confuse some users have broken hardware (which will generate
>> unknown NMI not for hardware error), we use a white list (machines with
>> HEST or workable chipset via PCI ID).
>
> Ok, a white list makes sense. This was not obvious in your
> implementation.

I have some comments in my original code.

+/*
+ * On some platform, hardware errors may be notified via unknown
+ * NMI. These platform is identified via the PCI ID of host bridge.
+ *
+ * The PCI ID of host bridge instead of DMI ID is used, so that the
+ * checking can be done based on the platform instead of motherboard.
+ * This should be simpler and sufficient.
+ */

If you think that is not obvious enough, I will change the comments to
make it more obvious.

Best Regards,
Huang Ying
