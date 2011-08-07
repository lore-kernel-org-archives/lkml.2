Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab1HGQPJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 12:15:09 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:59816 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab1HGQPH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 12:15:07 -0400
MIME-Version: 1.0
In-Reply-To: <20110807154456.GA695@liondog.tnic>
References: <4E3C8B8A.3080007@zytor.com> <44eea096d708c5c3273e41ced354073ebd62a1d6.1312599769.git.luto@mit.edu>
 <20110806064552.GA13220@elte.hu> <20110807121913.GA7007@liondog.tnic>
 <CAObL_7Et-CcamO+X4D5tvH3oWh9=Zog0t=MzOnyqNPzmGqmm2A@mail.gmail.com> <20110807154456.GA695@liondog.tnic>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sun, 7 Aug 2011 12:14:46 -0400
X-Google-Sender-Auth: ulB_8KD_FHZN7NsLeo6ynG1LXEQ
Message-ID: <CAObL_7EWkNhWDW6oMsAk6fa0Drhf=zQhJ1+sFmynk=ohq+RevQ@mail.gmail.com>
Subject: Re: [RFC v2] x86-64: Allow emulated vsyscalls from user addresses
To: Borislav Petkov <bp@alien8.de>, Andrew Lutomirski <luto@mit.edu>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        lueckintel@yahoo.com, kimwooyoung@gmail.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 7, 2011 at 11:44 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Sun, Aug 07, 2011 at 08:58:56AM -0400, Andrew Lutomirski wrote:
>> > Also, what do we do with userspace which decides to hardcode "int 0x4[012]"
>> > somewhere in the meantime?
>>
>> Break it?  Any code that does that will get an unconditional warning
>> with this patch.
>
> Ok, I hope you're right. Because I'm sure you remember the last
> prominent time the kernel broke userspace in the face of powertop.
> Although having the warning should be fine, i.e. along the lines of "you
> silly userspace process have been warned."

We have an advantage this time: why would anyone want to use them?
They're annoying to use and they're slower than syscalls.

We could resurrect the patch that randomized the vectors at boot, but
that was IMO ugly.

--Andy
