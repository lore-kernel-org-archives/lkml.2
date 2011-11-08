Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918Ab1KHP3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 10:29:20 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:48989 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab1KHP3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 10:29:18 -0500
Message-ID: <4EB94ACD.4020708@kernel.org>
Date: Tue, 08 Nov 2011 15:29:17 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111001 Thunderbird/7.0.1
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: jic23@cam.ac.uk, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        guenter.roeck@ericsson.com, khali@linux-fr.org,
        dmitry.torokhov@gmail.com, broonie@opensource.wolfsonmicro.com,
        gregkh@suse.de, alan@lxorguk.ukuu.org.uk, arnd@arndb.de,
        linus.walleij@linaro.org, maxime.ripard@free-electrons.com
Subject: Re: [PATCH 0/6 V2] IIO: Out of staging step 1: The core
References: <1320677563-18378-1-git-send-email-jic23@cam.ac.uk> <4EB92F78.8090200@metafoo.de> <4EB93B61.3030805@kernel.org> <4EB9426A.2040503@metafoo.de>
In-Reply-To: <4EB9426A.2040503@metafoo.de>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2011 02:53 PM, Lars-Peter Clausen wrote:
> On 11/08/2011 03:23 PM, Jonathan Cameron wrote:
>> On 11/08/2011 01:32 PM, Lars-Peter Clausen wrote:
>>> On 11/07/2011 03:52 PM, jic23@cam.ac.uk wrote:
>>>> From: Jonathan Cameron <jic23@kernel.org>
>>>>
>>>> [...]
>>>> Dear All,
>>>>
>>>> Firstly note that I have pushed ahead of this alongside the ongoing
>>>> discussions on how to handle in kernel interfaces for the devices
>>>> covered by IIO.  I propose to build those on top of this patch
>>>> set and will be working on that support whilst this set is
>>>> under review.
>>>>
>>>> Secondly, this code has some namespace clashes with the staging
>>>> IIO code, so you will need a couple of patches that can be found
>>>> in https://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git
>>>>
>>>> This is our first attempt to propose moving 'some' of the
>>>> Industrial I/O subsystem out of staging.  This cover letter
>>>> attempts to explain what IIO is and why it is needed.
>>>> All comments welcome on this as well as the code!
>>>
>>>
>>> I don't think moving just part of the IIO core out of staging will work.
>> It's the only option that looks plausible.  We just aren't going to get
>> anyone to review all the code in one go.  The original move into staging
>> was entirely about exposure, rather than code quality (not to say we
>> haven't improved that as well!)  The other thing is that the
>> simple stuff is mature and useful.  The buffering and event side of
>> things is still evolving and hence it may be a while yet before it is
>> stable enough.  (It was mature until the whole in kernel interface stuff
>> came up and lead to a substantial rewrite!)
>>  We
>>> now end up with two competing frameworks for the same purpose which mostly
>>> have the same API. If I for example enable both ST_IIO and IIO at the same
>>> time everything will explode, since both want to register the same device class.
>> True. That would be fixed by a simple namespace move though.  Annoying,
>> but plausible.
> 
> Still two almost identical frameworks for the same purpose. The code for the
> out-of-staging and still-in-staging branches have already started to divert.
> Having both in the mainline kernel is going to be maintenance hell. People
> will start sending patches for one, but not the other. I just don't think
> this will workout well.
Yes, I agree entirely. It already isn't working that well as I keep
porting patches between the two.  Intent is to get over this as quickly
as possible by getting stuff out of staging!  If people add new stuff to
the staging tree, that is applicable to the non staging one I will be
shouting at them to do both.  The intent is to keep the two trees close
enough that driver moves are trivial (when the support is there in the
non staging tree).
> 
>>>
>>> In my opinion we should move all of the core interface including events and
>>> buffer support at once. Drivers of course can stay in staging. I guess the
>>> main reason why this code is still in staging is that we don't fell
>>> confident enough about the user-space ABI yet. The overall code quality is
>>> ok and there are no major problems with the internal API.
>> Partly that, and partly that and partly there are controversial elements
>> to be discussed in each of the major parts.  There's a lot of pressure
>> to get 'something' out for the simple drivers now even if we take a
>> while to 'discuss' the other elements.  Hence it needs to happen in
>> chunks from the point of view of review, even if the final pull request
>> will bring over the whole core.
>>
> 
> If the core split-up is just for review and is not intended to be merged
> part-by-part over several kernel releases I don't see a problem.
The intent is that it should be 'possible' to merge it part by part.
I'm not against that happening if the more complex stuff doesn't happen
this cycle.  I'd love it to go quickly, but time as ever is a precious
resource.

Jonathan
