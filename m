Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab2FSR07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 13:26:59 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48792 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab2FSR05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 13:26:57 -0400
Message-ID: <4FE0B659.9090604@us.ibm.com>
Date: Tue, 19 Jun 2012 10:26:49 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Richard Cochran <richardcochran@gmail.com>,
        Jonathan Nieder <jrnieder@gmail.com>, stable@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -stable]  ntp: Correct TAI offset during leap second
References: <4FDB8563.3030805@us.ibm.com> <1339944223.4942.240.camel@deadeye.wl.decadent.org.uk> <20120617164751.GJ12429@burratino> <20120617173456.GA3684@netboy.at.omicron.at> <1340027711.9372.29.camel@deadeye.wl.decadent.org.uk> <20120618162854.GA3111@netboy.at.omicron.at> <1340106888.6871.20.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1340106888.6871.20.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061917-7182-0000-0000-000001C75745
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 04:54 AM, Ben Hutchings wrote:
> On Mon, 2012-06-18 at 18:28 +0200, Richard Cochran wrote:
>> On Mon, Jun 18, 2012 at 02:55:11PM +0100, Ben Hutchings wrote:
>>> On Sun, 2012-06-17 at 19:34 +0200, Richard Cochran wrote:
>>>> The offset should change upon entering state OOP, so something like
>>>> the following (untested) patch should fix it for 3.2.9.
>>> [...]
>>>
>>> It looks like this patch just changes the offset reported by adjtimex()
>>> during an inserted second; is that right?
>> Right, nothing really terrible will happen. The worst that I can
>> imagine is that ntpd will set the new TAI offset during OOP, and then
>> the kernel will add one to it, resulting in the TAI offset being off
>> by one.
>>
>> But I really doubt any software makes use of this information.
>>
>>> Other than that, is 3.2.y likely to be OK?  Is there a good way to test
>>> that in advance; does
>>> <http://codemonkey.org.uk/2012/06/15/testing-leap-code/>  look
>>> reasonable?
>> Well, if you want to wait all night then that is one way to do it.
> I was intending to change the clock too...
>
>> Here is a little test program I have been using:
>>
>>     https://github.com/richardcochran/leap
> Thanks, that runs without incident but does show the incorrect offset
> during OOP.
Yep. That's a long-standing issue, due to the leap-second processing 
happening at tick time (further complicated since to handle NOHZ, we 
accumulate in fixed-tick intervals that don't exactly line up with the 
interrupt edge), so we'll usually get one to two ticks into the second 
before we apply the leap second.

Richard has recently taken a stab at correcting this.

Richard, are you planning on taking another go at those changes? Or were 
my last suggestions just too daft? ;)

thanks
-john


