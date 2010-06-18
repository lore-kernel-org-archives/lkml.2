Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761017Ab0FRLe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 07:34:57 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59785 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645Ab0FRLe4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 07:34:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=If4evaj0CPRheOoSGyue7m4AB+O6SLbjwXtvjYk8oscjlscpkU38oU2cicLDILehYc
         MY1kYPLRS1D8S+xkOC3fVeexA3ZPcZ4+nSU1boG7wTnBxVPEhU3IKsY+iNQNspUasvpV
         ZoIzM6lKBeJXRWf9MK/AYfwELzwfAGtD6Imcc=
MIME-Version: 1.0
In-Reply-To: <20100618094838.GD23977@elte.hu>
References: <1276334896-7075-1-git-send-email-ying.huang@intel.com>
	<20100612102558.GA4000@elte.hu>
	<4C15A5D1.1040104@jp.fujitsu.com>
	<20100618094838.GD23977@elte.hu>
Date: Fri, 18 Jun 2010 19:34:55 +0800
Message-ID: <AANLkTimqRwAjrQ_b8BZ28lEn_Gaz5-SpLULWASHD1fVn@mail.gmail.com>
Subject: Re: [RFC 1/3] Unified NMI delayed call mechanism
From: huang ying <huang.ying.caritas@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Huang Ying <ying.huang@intel.com>,
       "Fr??d??ric Weisbecker" <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ingo,

On Fri, Jun 18, 2010 at 5:48 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:
>
>> (2010/06/12 19:25), Ingo Molnar wrote:
>> >
>> > * Huang Ying <ying.huang@intel.com> wrote:
>> >
>> >> NMI can be triggered even when IRQ is masked. So it is not safe for NMI
>> >> handler to call some functions. One solution is to delay the call via self
>> >> interrupt, so that the delayed call can be done once the interrupt is
>> >> enabled again. This has been implemented in MCE and perf event. This patch
>> >> provides a unified version and make it easier for other NMI semantic handler
>> >> to take use of the delayed call.
>> >
>> > Instead of introducing this extra intermediate facility please use the same
>> > approach the unified NMI watchdog is using (see latest -tip): a perf event
>> > callback gives all the extra functionality needed.
>> >
>> > The MCE code needs to be updated to use that - and then it will be integrated
>> > into the events framework.
>>
>> Hi Ingo,
>>
>> I think this "NMI delayed call mechanism" could be a part of "the events
>> framework" that we are planning to get in kernel soon. [...]
>
> My request was to make it part of perf events - which is a generic event
> logging framework. We dont really need/want a second 'events framework'
> as we have one already ;-)

This patchset is simple and straightforward, it is just a delayed
execution mechanism, not another 'events framework'. There are several
other NMI users other than perf, should we integrate all NMI users
into perf framework?

>> [...]  At least APEI will use NMI to report some hardware events (likely
>> error) to kernel.  So I suppose we will go to have a delayed call as an
>> event handler for APEI.
>
> Yep, that makes sense. I wasnt arguing against the functionality itself, i was
> arguing against the illogical layering that limits its utility. By making it
> part of perf events it becomes a generic part of that framework and can be
> used by anything that deals with events and uses that framework.

I think the the 'layering' in the patchset helps instead of 'limits'
its utility. It is designed to be as general as possible, so that it
can be used by both perf and other NMI users. Do you think so?

Best Regards,
Huang Ying
