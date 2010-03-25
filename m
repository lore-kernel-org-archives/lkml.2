Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab0CYAZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 20:25:47 -0400
Received: from stag.seas.upenn.edu ([158.130.70.79]:51390 "EHLO
	stag.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab0CYAZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 20:25:45 -0400
Message-ID: <4BAAAD74.8090907@seas.upenn.edu>
Date: Wed, 24 Mar 2010 20:25:24 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: Micki Balanga <micki@n-trig.com>
CC: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>, jkosina@suse.cz,
       chatty@enac.fr, peterhuewe@gmx.de, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>,
       DmitryTorokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 1/2] HID: N-trig Add set feature commands to driver
References: <1269260173-2543-1-git-send-email-micki@n-trig.com> <20100322172920.GA18658@seas.upenn.edu> <48A28051AC6D7A48B64F28272458190326DEE8@Exchange-IL.n-trig.com> <20100322181722.GA24483@seas.upenn.edu> <48A28051AC6D7A48B64F28272458190326DEEB@Exchange-IL.n-trig.com> <4BA7D666.5030608@seas.upenn.edu> <48A28051AC6D7A48B64F28272458190326DEEE@Exchange-IL.n-trig.com> <4BA7E747.4040008@seas.upenn.edu> <48A28051AC6D7A48B64F28272458190324FE9F@Exchange-IL.n-trig.com> <45cc95261003240627i1c1c9a8y6f5dc78eddf67e32@mail.gmail.com> <48A28051AC6D7A48B64F28272458190326DEF4@Exchange-IL.n-trig.com>
In-Reply-To: <48A28051AC6D7A48B64F28272458190326DEF4@Exchange-IL.n-trig.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I think there's a large rift in perspective here.

Micki: what is your motivation for pushing your code to the mainline
kernel.  Nobody is stopping you from publishing your own driver stack
on your website, as you do with some of your windows drivers and
other vendors (nvidia for example) do with their linux drivers.

There is much to be said for engaging the community and I think you,
your company, and your customers would profit from healthy cooperation.

Your requests for blind faith do not really interest me.  You talk about
algorithms running in closed source modules (which we haven't even seen)
that do "stuff".  That really doesn't mean much.  Why should I or anyone
else be interested in algorithms if we don't know what they are supposed
to improve?  Why should we accept breakage, temporary or permanent, based
on your word that its worth it.

There's no argument that your status as a developer may give you access
to inside information that may improve the overall user experience.  But
that doesn't justify blind faith from the community.  There are many
reasons to suspect that your interests do not necessary mesh with the
community as a whole.


If you have some actual points to make, make them.  Just don't expect
to convince anyone with vacuous arguments and claims of corporate
backing.

Micki Balanga wrote:
> I as mentioned in the last email
> The algorithm to analyze the information use complex math calculation,
> so it can't be transfer to the driver.
> (the driver should stay simple as possible, main purpose analyze USB
> message and transfer it to Linux events)
> As i mentioned before you talked about glitch a noise, which N-trig
> solution solve.
> The driver implement the necessary events needed by the user, in order
> to analyze touch events.
> In the coming weeks we'll provide an additional package
> that will improve and enhance the system performance.
> This package will support Linux events as well as Message Queue based
> API for the benefit of the developers.

You haven't really demonstrated that you can do a better job of
de-glitching than we could do with some very _simple_ code in the kernel.

As for kernel vs. user space computational burden.  Looking for the 6
end of stream events in the kernel costs fewer cycles than emitting
the events to let the user space catch that particular signal.

Also there is a second set of conditions indicating the pen is
active, those can also be caught just as easily, and don't add any
additional justification of passing those events through.


I don't see why you make a big deal out of message queues, its
not even clear that's really such an appropriate medium to feed
events downstream.  Don't get me wrong, I like message queues
they are fun and have their place, and its fun to add them to
class projects and watch students misuse them.

> -----Original Message-----
> From: Mohamed Ikbel Boulabiar [mailto:boulabiar@gmail.com]
> Sent: Wed 3/24/2010 3:27 PM
> To: Micki Balanga
> Cc: Rafi Rubin; jkosina@suse.cz; chatty@enac.fr; peterhuewe@gmx.de;
> linux-input@vger.kernel.org; linux-kernel@vger.kernel.org; Henrik
> Rydberg; DmitryTorokhov
> Subject: Re: [PATCH 1/2] HID: N-trig Add set feature commands to driver
> 
> Hi,
> 
> Do you have any intention to add some more low level tracking in the
> driver ?
> 
> I haven't followed all mails, I remember that a small algorithm for
> tracking was suggested by Rafi Rubin, but don't know if N-Trig
> developers can push more things inside the driver and provide a
> contact-id information inside events submission.
> 
> Thanks,

I pulled the tracking code while I responding to other issues concerning
the problems with my patches.  Specifically I removed that code because
I read Henrik's protocol documentation more carefully.  I think there is
still an opportunity to perform partial tracking, but that's another
discussion.

While it was pretty lightweight I also felt I could do better, both in
terms of the computations it already did and to make it take better
advantage of the specific scan patterns of the n-trig hardware that I've
observed.


Its also not entirely clear to me what the intention of the
manufacturer is with regards to tracking.  If they do intend to clean up
the poor tracking in the firmware, then it doesn't really make sense to add
it now.  One more reason it would be good to have firmware version and
possibly some other method to sanity check.

- - Rafi

> On Tue, Mar 23, 2010 at 3:43 PM, Micki Balanga <micki@n-trig.com> wrote:
>> N-trig driver can be used directly for Multi-Touch and Pen support.
>> Furthermore, in the coming weeks we'll provide an additional package
>> that will improve and enhance the system performance.
>> This package will support Linux events as well as Message Queue based
>> API for the benefit of the developers.
>>
>> -----Original Message-----
>> From: Rafi Rubin [mailto:rafi@seas.upenn.edu]
>> Sent: Monday, March 22, 2010 11:55 PM
>> To: Micki Balanga
>> Cc: jkosina@suse.cz; chatty@enac.fr; peterhuewe@gmx.de;
>> linux-input@vger.kernel.org; linux-kernel@vger.kernel.org; Henrik
>> Rydberg; Dmitry Torokhov
>> Subject: Re: [PATCH 1/2] HID: N-trig Add set feature commands to driver
>>
>> On 03/22/2010 05:14 PM, Micki Balanga wrote:
>>> Hi
>>> first of all i am happy my explanation helps you to understand the
>>> necessity of fake finger report.
>>> The algorithm to analyze the information use complex math calculation,
>>> so it can't be transfer to the driver.
>>> (the driver should stay simple as possible, main purpose analyze USB
>>> message and transfer it to Linux events)
>>> As i mentioned before you talked about glitch a noise, which N-trig
>>> solution solve.
>>> The driver implement the necessary events needed by the user, in order
>>> to analyze touch events.
>>
>> I'm not really much of a judge of how to balance kernel vs user land
>> load.  Though I can certainly see why you would want to keep all
>> proprietary analysis to the user land and thus want to pass through
>> necessary events.  I was "encouraged" earlier to take a deeper look at
>> what I was writing, and determine if all that I was trying to send was
>> actually necessary or just me missing something.
>>
>> I will look more closely, and perhaps see if I can suggest modifications
>>
>> which include the events you need without breaking the existing
>> protocol.  Dmitry seems to be an authority on how input events should be
>>
>> used.  I'm still just learning myself.
>>
>> But this still leaves the point of lets try to keep the split input
>> devices.  It is still a cleaner abstraction than splitting in the user
>> space code.
>>
>>> About a question you raised before about set_feature location, it
>> should
>>> be done after the hw_start because
>>> if the HW start fail there is no reason to send the command. this
>>> command doesn't change the report descriptor size.
>>
>> I'm still not entirely sure of the ordering of things.  Users have sent
>> me the rdesc outputs from a device with 2.59 with and without your code
>> to enable MT, and it looked to me like the report descriptor was
>> different.  I can try to experiment with that.
>>
>> Can you specify conditions or versions which cause this failure?  It
>> would be nice to be able to see for myself, especially since removing
>> the naming and the quirk will disrupt quite a number of users.
>>
>> I do agree that the code should be more robust to bad conditions, so
>> please try it with:
>>
>>    list_for_each_entry(hidinput, &hdev->inputs, list) {
>> +      if (hidinput->report == NULL) {
>> +         dev_err(&hdev->dev, "NULL report\n");
>> +         continue;
>> +      }
>>
>> That way we'll have a graceful fallback for your needs without breaking
>> users.  And also, hopefully this will lead to finding any lingering
>> bugs.
>>
>>
>>> -----Original Message-----
>>> From: Rafi Rubin [mailto:rafi@seas.upenn.edu]
>>> Sent: Mon 3/22/2010 10:43 PM
>>> To: Micki Balanga
>>> Cc: jkosina@suse.cz; chatty@enac.fr; peterhuewe@gmx.de;
>>> linux-input@vger.kernel.org; linux-kernel@vger.kernel.org; Henrik
>> Rydberg
>>> Subject: Re: [PATCH 1/2] HID: N-trig Add set feature commands to
>> driver
>>>
>>> On 03/22/2010 03:58 PM, Micki Balanga wrote:
>>>  >
>>>  > Hi
>>>  > I would like to add more information about the Fake button.
>>>  > I will explain using this scenario:
>>>  > You touch the sensor with one finger and then remove the finger,
>>>  > Firmware will report six frames with fake fingers,(Indicate end of
>>> session)
>>>  > The driver will report this as fake fingers (Will send 3 events)
>> and
>>>  > input_sync
>>>  > to inform user space application that the user removed finger from
>>> sensor.
>>>  > this information is needed in order to analyze the data received
>> from
>>>  > N-trig firmware.
>>>  > Micki
>>>
>>> Thank you for taking this to a discussion format.
>>>
>>> It seems you have raised an issue that is an active discussion for
>> multi
>>> touch handling in general and an issue that I have considered for
>> n-trig
>>> support in specific.
>>>
>>>
>>> The current published version of the driver does send one more
>> sequence
>>> of events after it decides all fingers are off the screen. That final
>>> sequence is necessary to tell single touch drivers that the tools are
>>> released (BTN_TOUCH is set to zero, etc). This also resets the active
>>> contact count to zero for multi touch handlers, which look to see how
>>> many MT events come from each frame.
>>>
>>> I had observed that sometimes the tablet looses contacts semi
>>> arbitrarily, and we get a zero contact group as a mistake. In the
>>> patches I sent in early in February you will notice a solution that I
>>> was considering at the time. I was also playing with correcting for
>>> events that looked like real contacts but were also just noise. After
>>> rethinking my patches and reading the multi touch doc in the Documents
>>> tree, I chose to leave out these corrections.
>>>
>>> That being said, I do have a specific patch to handle the set of end
>> of
>>> stream events. All that's needed is to count the empty groups and send
>>> the terminal events only when a counter hits the specified value
>>> (attached is a tiny patch I wrote when I needed that feature back
>> really
>>> quickly when my screen started misbehaving during a meeting).
>>>
>>> Note I have submitted that as a patch for 2 reasons. First I couldn't
>>> be completely sure that there was a specific number of empty groups to
>>> signal end of stream which would be expected to be maintained over
>> time.
>>> And secondly the erroneous termination of stream has not been much of
>>> a problem in general.
>>>
>>> You will note, that this is something that is simple enough that it
>>> makes perfect sense to put into the kernel. There's little point in
>>> wasting the cycles to push that decision to user space.
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-input" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkuqrXQACgkQwuRiAT9o60/HcACgi5ze2V11OMoDklz/WgxGIR8T
J64AnRSoTv96r+LJYnIPBD0QGVjUf9li
=7qYp
-----END PGP SIGNATURE-----
