Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934347Ab1J3SFI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 14:05:08 -0400
Received: from lo.gmane.org ([80.91.229.12]:57205 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934313Ab1J3SFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 14:05:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andy Moreton <andrewjmoreton@gmail.com>
Subject: Re: time: Improve documentation of timekeeeping_adjust()
Date: Sun, 30 Oct 2011 17:14:12 +0000
Message-ID: <82mxcijtaz.fsf@gmail.com>
References: <1319764362-32367-1-git-send-email-john.stultz@linaro.org>
	<20111028060534.GB1957@netboy.at.omicron.at>
	<1319785345.23224.75.camel@work-vm>
Mime-Version: 1.0
Content-Type: text/plain
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 82-69-64-228.dsl.in-addr.zen.co.uk
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.90 (windows-nt)
Cancel-Lock: sha1:by0MDsI9a+P7dCu6Aklv1bvz24s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 28 Oct 2011, John Stultz wrote:

> On Fri, 2011-10-28 at 08:05 +0200, Richard Cochran wrote:
>> On Thu, Oct 27, 2011 at 06:12:42PM -0700, John Stultz wrote:
>> > diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
>> > index a5846a8..de8737e 100644
>> > --- a/kernel/time/timekeeping.c
>> > +++ b/kernel/time/timekeeping.c
>> > @@ -802,14 +802,44 @@ static void timekeeping_adjust(s64 offset)
>> >  	s64 error, interval = timekeeper.cycle_interval;
>> >  	int adj;
>> >  
>> > +	/*
>> > +	 * The point of this is to check if the error is greater then half
>> > +	 * an interval.
>> > +	 *
>> > +	 * First we shift it down from NTP_SHIFT to clocksource->shifted nsecs.
>> > +	 *
>> > +	 * Note we subtract one in the shift, so that error is really error*2.
>> > +	 * This "saves" dividing(shifting) intererval twice, but keeps the
>> > +	 * (error > interval) comparision as still measuring if error is
>> > +	 * larger then half an interval.
>> > +	 *
>> > +	 * Note: It does not "save" on aggrivation when reading the code.
>> 
>> ... or on "aggravation" either :)
>
> Sigh. I do need to start using an editor with built in spell checking.
> I'm so poor of a speller (and a typist) its really amazing its not
> worse.
>
> Thanks for catching that.
> -john

s/intererval/interval/

    AndyM

