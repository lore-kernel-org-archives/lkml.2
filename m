Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760592Ab2FGKsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 06:48:16 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:54326 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760067Ab2FGKsO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 06:48:14 -0400
MIME-Version: 1.0
In-Reply-To: <1339065932.23343.18.camel@twins>
References: <20120607071531.GA4849@quad>
	<1339064319.23343.13.camel@twins>
	<CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
	<1339065932.23343.18.camel@twins>
Date: Thu, 7 Jun 2012 12:48:12 +0200
Message-ID: <CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on SandyBridge
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, mingo@elte.hu,
        ming.m.lin@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 12:45 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2012-06-07 at 12:35 +0200, Stephane Eranian wrote:
>> > This will only warn about the PEBS issue once you try and use a PEBS
>> > counter. Shouldn't we do this on boot? IOW. put check_pebs_quirks()
>> > inside the existing quirk code instead of here?
>> >
>> The warning could also be done on boot. But the check has to be done
>>  when the event is created.
>
> Is this because of the ucode loader not having done its thing yet etc..?
>
>> The other thing is that as it is now, if you
>> get an error, you check dmesg and it's obvious what is wrong. With
>> the boot warning, you'd have to look back all the way to the early boot
>> messages. Whatever you prefer, I am fine.
>
> We could do both I guess. But the event creation one needs a rate
> limiter.

Let's keep things simple, move the warning on boot, keep the quiet check
on creation.
