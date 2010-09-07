Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab0IGH3D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 03:29:03 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42753 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab0IGH25 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 03:28:57 -0400
MIME-Version: 1.0
X-Originating-IP: [81.243.35.243]
In-Reply-To: <201009061400.05637.trenn@suse.de>
References: <AANLkTikvbn3+JPc7pnGZk-H4B71MHTu+-vjuzfJw_7PC@mail.gmail.com>
	<201009061243.00479.trenn@suse.de>
	<AANLkTik8_ixOcFy=c4hPZknyUqPYB+2hzQTNK9wVok4q@mail.gmail.com>
	<201009061400.05637.trenn@suse.de>
Date: Tue, 7 Sep 2010 09:28:56 +0200
Message-ID: <AANLkTik08ezo2ui-P7mSqSt4VR6wzWYH0hAyNTZALbi0@mail.gmail.com>
Subject: Re: [PATCH] tracing, perf: add more power related events
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Thomas Renninger <trenn@suse.de>
Cc: discuss@lesswatts.org, linux-pm@lists.linux-foundation.org,
        Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Mon, Sep 6, 2010 at 2:00 PM, Thomas Renninger <trenn@suse.de> wrote:
> On Monday 06 September 2010 13:27:13 Jean Pihet wrote:
>> On Mon, Sep 6, 2010 at 12:42 PM, Thomas Renninger <trenn@suse.de> wrote:
> ...
>> In order to reach an efficient low power mode you
>> need to ensure that all clocks in a clock domain are idled or cut off
>> (automatically by the HW or with the intervention of SW drivers).
>>
>> The HW complexity requires the tracing of all those clocks/power
>> states, that is why new events are proposed.
> Hm, but if the HW can switch clocks behind your back, how do you
> realize that to throw a perf clock power event then?
Such clocks are automatically shut off when there is no activity on
the module, this allows the system to reach a lower power state. All
that is needed is to ensure the modules are correctly configured to
shut off unneeded clocks automatically.

> Theoretically you need to poll to keep track of HW switching the
> clocks?
No. I would not poll hundreds of clocks.
Furthermore there is no event to be thrown away, in the case the
reached power mode is not 'deep' enough you need a trace point showing
what blocked the transition. There is still work to do to achieve
that, it is coming soon.

>
>    Thomas
>

Note: a re-spin of the patch has been sent on a new thread.

Jean
