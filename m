Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab0CXN2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 09:28:22 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:35211 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100Ab0CXN2U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 09:28:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=HenEcEduTkVcKocvkXAnAwRhLHfnEJeVqTz7ZpGvGcGpI7yysli925GgWsYp1nQjGS
         cLazc0h3QcmB0jQZCcG/BTkEgm29pUqiL/Qk5XzDOaS0YDClIpctGRTLMZrpTF+AJIGu
         brJKZH3pmwN6nynCk7pQb04kQQEoc8oH5foOQ=
MIME-Version: 1.0
In-Reply-To: <48A28051AC6D7A48B64F28272458190324FE9F@Exchange-IL.n-trig.com>
References: <1269260173-2543-1-git-send-email-micki@n-trig.com> 
	<20100322172920.GA18658@seas.upenn.edu> <48A28051AC6D7A48B64F28272458190326DEE8@Exchange-IL.n-trig.com> 
	<20100322181722.GA24483@seas.upenn.edu> <48A28051AC6D7A48B64F28272458190326DEEB@Exchange-IL.n-trig.com> 
	<4BA7D666.5030608@seas.upenn.edu> <48A28051AC6D7A48B64F28272458190326DEEE@Exchange-IL.n-trig.com> 
	<4BA7E747.4040008@seas.upenn.edu> <48A28051AC6D7A48B64F28272458190324FE9F@Exchange-IL.n-trig.com>
From: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
Date: Wed, 24 Mar 2010 14:27:58 +0100
Message-ID: <45cc95261003240627i1c1c9a8y6f5dc78eddf67e32@mail.gmail.com>
Subject: Re: [PATCH 1/2] HID: N-trig Add set feature commands to driver
To: Micki Balanga <micki@n-trig.com>
Cc: Rafi Rubin <rafi@seas.upenn.edu>, jkosina@suse.cz, chatty@enac.fr,
       peterhuewe@gmx.de, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Do you have any intention to add some more low level tracking in the driver ?

I haven't followed all mails, I remember that a small algorithm for
tracking was suggested by Rafi Rubin, but don't know if N-Trig
developers can push more things inside the driver and provide a
contact-id information inside events submission.

Thanks,


On Tue, Mar 23, 2010 at 3:43 PM, Micki Balanga <micki@n-trig.com> wrote:
> N-trig driver can be used directly for Multi-Touch and Pen support.
> Furthermore, in the coming weeks we'll provide an additional package
> that will improve and enhance the system performance.
> This package will support Linux events as well as Message Queue based
> API for the benefit of the developers.
>
> -----Original Message-----
> From: Rafi Rubin [mailto:rafi@seas.upenn.edu]
> Sent: Monday, March 22, 2010 11:55 PM
> To: Micki Balanga
> Cc: jkosina@suse.cz; chatty@enac.fr; peterhuewe@gmx.de;
> linux-input@vger.kernel.org; linux-kernel@vger.kernel.org; Henrik
> Rydberg; Dmitry Torokhov
> Subject: Re: [PATCH 1/2] HID: N-trig Add set feature commands to driver
>
> On 03/22/2010 05:14 PM, Micki Balanga wrote:
>> Hi
>> first of all i am happy my explanation helps you to understand the
>> necessity of fake finger report.
>> The algorithm to analyze the information use complex math calculation,
>> so it can't be transfer to the driver.
>> (the driver should stay simple as possible, main purpose analyze USB
>> message and transfer it to Linux events)
>> As i mentioned before you talked about glitch a noise, which N-trig
>> solution solve.
>> The driver implement the necessary events needed by the user, in order
>> to analyze touch events.
>
> I'm not really much of a judge of how to balance kernel vs user land
> load.  Though I can certainly see why you would want to keep all
> proprietary analysis to the user land and thus want to pass through
> necessary events.  I was "encouraged" earlier to take a deeper look at
> what I was writing, and determine if all that I was trying to send was
> actually necessary or just me missing something.
>
> I will look more closely, and perhaps see if I can suggest modifications
>
> which include the events you need without breaking the existing
> protocol.  Dmitry seems to be an authority on how input events should be
>
> used.  I'm still just learning myself.
>
> But this still leaves the point of lets try to keep the split input
> devices.  It is still a cleaner abstraction than splitting in the user
> space code.
>
>> About a question you raised before about set_feature location, it
> should
>> be done after the hw_start because
>> if the HW start fail there is no reason to send the command. this
>> command doesn't change the report descriptor size.
>
> I'm still not entirely sure of the ordering of things.  Users have sent
> me the rdesc outputs from a device with 2.59 with and without your code
> to enable MT, and it looked to me like the report descriptor was
> different.  I can try to experiment with that.
>
> Can you specify conditions or versions which cause this failure?  It
> would be nice to be able to see for myself, especially since removing
> the naming and the quirk will disrupt quite a number of users.
>
> I do agree that the code should be more robust to bad conditions, so
> please try it with:
>
>    list_for_each_entry(hidinput, &hdev->inputs, list) {
> +      if (hidinput->report == NULL) {
> +         dev_err(&hdev->dev, "NULL report\n");
> +         continue;
> +      }
>
> That way we'll have a graceful fallback for your needs without breaking
> users.  And also, hopefully this will lead to finding any lingering
> bugs.
>
>
>> -----Original Message-----
>> From: Rafi Rubin [mailto:rafi@seas.upenn.edu]
>> Sent: Mon 3/22/2010 10:43 PM
>> To: Micki Balanga
>> Cc: jkosina@suse.cz; chatty@enac.fr; peterhuewe@gmx.de;
>> linux-input@vger.kernel.org; linux-kernel@vger.kernel.org; Henrik
> Rydberg
>> Subject: Re: [PATCH 1/2] HID: N-trig Add set feature commands to
> driver
>>
>> On 03/22/2010 03:58 PM, Micki Balanga wrote:
>>  >
>>  > Hi
>>  > I would like to add more information about the Fake button.
>>  > I will explain using this scenario:
>>  > You touch the sensor with one finger and then remove the finger,
>>  > Firmware will report six frames with fake fingers,(Indicate end of
>> session)
>>  > The driver will report this as fake fingers (Will send 3 events)
> and
>>  > input_sync
>>  > to inform user space application that the user removed finger from
>> sensor.
>>  > this information is needed in order to analyze the data received
> from
>>  > N-trig firmware.
>>  > Micki
>>
>> Thank you for taking this to a discussion format.
>>
>> It seems you have raised an issue that is an active discussion for
> multi
>> touch handling in general and an issue that I have considered for
> n-trig
>> support in specific.
>>
>>
>> The current published version of the driver does send one more
> sequence
>> of events after it decides all fingers are off the screen. That final
>> sequence is necessary to tell single touch drivers that the tools are
>> released (BTN_TOUCH is set to zero, etc). This also resets the active
>> contact count to zero for multi touch handlers, which look to see how
>> many MT events come from each frame.
>>
>> I had observed that sometimes the tablet looses contacts semi
>> arbitrarily, and we get a zero contact group as a mistake. In the
>> patches I sent in early in February you will notice a solution that I
>> was considering at the time. I was also playing with correcting for
>> events that looked like real contacts but were also just noise. After
>> rethinking my patches and reading the multi touch doc in the Documents
>> tree, I chose to leave out these corrections.
>>
>> That being said, I do have a specific patch to handle the set of end
> of
>> stream events. All that's needed is to count the empty groups and send
>> the terminal events only when a counter hits the specified value
>> (attached is a tiny patch I wrote when I needed that feature back
> really
>> quickly when my screen started misbehaving during a meeting).
>>
>> Note I have submitted that as a patch for 2 reasons. First I couldn't
>> be completely sure that there was a specific number of empty groups to
>> signal end of stream which would be expected to be maintained over
> time.
>> And secondly the erroneous termination of stream has not been much of
>> a problem in general.
>>
>> You will note, that this is something that is simple enough that it
>> makes perfect sense to put into the kernel. There's little point in
>> wasting the cycles to push that decision to user space.
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
