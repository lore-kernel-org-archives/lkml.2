Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab0HCWXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 18:23:05 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50709 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298Ab0HCWXD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 18:23:03 -0400
MIME-Version: 1.0
In-Reply-To: <20100803154112.GE2407@linux.vnet.ibm.com>
References: <20100731175841.GA9367@linux.vnet.ibm.com>
	<AANLkTi=hoGF7egpyB9sLKJoXv5aiGrxfa9_5iH-96SA=@mail.gmail.com>
	<20100803154112.GE2407@linux.vnet.ibm.com>
Date: Tue, 3 Aug 2010 15:23:00 -0700
Message-ID: <AANLkTim474Yp=MP3EX9pabc9XO8Q-McCns207SLPYuUb@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        mjg59@srcf.ucam.org, pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, swetland@google.com, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/3 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> On Mon, Aug 02, 2010 at 09:18:27PM -0700, Arve Hjønnevåg wrote:
>> On Sat, Jul 31, 2010 at 10:58 AM, Paul E. McKenney
>> <paulmck@linux.vnet.ibm.com> wrote:
...
>> > o       Statistics of the power-control actions taken by power-aware
>> >        applications must be provided, and must be keyed off of program
>> >        name.
>>
>> We don't key the stats off the program name, but having useful
>> statistics is critical too us. The current code in linux-next does not
>> appear to allow this (I'm referring to pm_stay_awake here, etc not
>> pm-qos.)
>
> OK, maybe I was confused earlier.  So you do not track statistics via
> the device being open throughout the application's lifetime?
>

The suspend blocker patchset does track statistics while the device is
open, but it it not keyed of the program name. The name is passed from
user-space and a single process can have the device open several
times. The wakelock interface that we currently use just creates a new
object every time it sees a new name and never frees it.

...
>> > o       If no power-aware or power-optimized application are indicating
>> >        a need for the system to remain operating, the system is permitted
>> >        (even encouraged!) to suspend all execution, even if power-naive
>> >        applications are runnable.  (This requirement did appear to be
>> >        somewhat controversial.)
>>
>> I would say it should suspend even if power aware applications are
>> runnable. Most applications do not exclusively perform critical work.
>
> The point being that a power-aware application does not block suspend
> -unless- it holds a suspend blocker, correct?

Yes.

>
> Or am I missing some other subtlety?

No.

...
>> > o       Any initialization of the API that controls the system power
>> >        state must be unconditional, so as to be free from failure.
>> >        (I don't currently understand how this relates, probably due to
>> >        my current insufficient understanding of the proposed patch set.)
>>
>> Unconditional initialization makes it easier to add suspend blockers
>> to existing kernel code since you don't have to add new failure exit
>> paths. It is not a strong requirement.
>
> Ah, that makes more sense!  I moved this to a new "NICE-TO-HAVES"
> section.  I also changed the last parenthesized sentence to read
> "Such unconditional initialization reduces the intrusiveness of the
> the Android patchset."  Does that work?
>

Sure.



-- 
Arve Hjønnevåg
