Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab1F3TNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 15:13:47 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:63235 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab1F3TNo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 15:13:44 -0400
MIME-Version: 1.0
In-Reply-To: <4E0CC824.40909@zytor.com>
References: <20110622063441.GA1740@x4.trippels.de> <4E048C0D.7020403@suse.cz>
 <20110624135100.GB1708@x4.trippels.de> <201106241833.15424.arnd@arndb.de>
 <BANLkTi=9e-it8nd2s-vcbEfc1h8tnSmj8A@mail.gmail.com> <4E0CBFF0.2040205@zytor.com>
 <BANLkTikKq64RPyT3CS8U+zdc2HmqHYZt4Q@mail.gmail.com> <4E0CC5F4.7010002@zytor.com>
 <BANLkTimf=21wbscEZRtfm+XFue713w7ZNA@mail.gmail.com> <4E0CC824.40909@zytor.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 30 Jun 2011 15:13:24 -0400
X-Google-Sender-Auth: PEvePRL1oOwwXQopw3B4TNNV830
Message-ID: <BANLkTi=dGPz4MpSKUNWaA_W1t4C_+zV=0w@mail.gmail.com>
Subject: Re: {PATCH] fix __packed in exported kernel headers
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Michal Marek <mmarek@suse.cz>, Joe Perches <joe@perches.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 15:01, H. Peter Anvin wrote:
> On 06/30/2011 11:58 AM, Mike Frysinger wrote:
>> On Thu, Jun 30, 2011 at 14:52, H. Peter Anvin wrote:
>>> On 06/30/2011 11:48 AM, Mike Frysinger wrote:
>>>> without fallback logic (#ifndef xxx...#define xxx...#endif), i think
>>>> that's throwing an unreasonable amount of requirements onto userspace
>>>> consumers
>>>
>>> Unclear.  Too much "smarts" in kernel headers is a constant headache to
>>> userspace consumers.
>>
>> not even being able to include a header without hitting a build
>> failure without first declaring some magic defines (which,
>> realistically, the vast majority of people will be doing exactly the
>> same as they'll be using gcc) is unreasonable.  hence my suggestion
>> about compiler.h.
>
> Not unless the kernel uses its own namespace for these defines.  The
> thing is, most libraries have their own macro library for this, and
> collisions are both likely and bad.

while that's true for exporting compiler.h, namespacing is irrelevant
to my requirement -- the headers should have sane/usable defaults.
-mike
