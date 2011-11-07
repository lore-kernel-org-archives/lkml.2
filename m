Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab1KGLKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 06:10:44 -0500
Received: from exprod5og111.obsmtp.com ([64.18.0.22]:60518 "EHLO
	exprod5og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab1KGLKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 06:10:43 -0500
Message-ID: <4EB7BCAE.90004@ge.com>
Date: Mon, 07 Nov 2011 11:10:38 +0000
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: gregkh@suse.de, Grant Likely <grant.likely@secretlab.ca>,
        devel@driverdev.osuosl.org, manohar.vanga@cern.ch, cota@braap.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Driver for GE PIO2 VME Card
References: <20111104173126.30940.28135.stgit@ES-BJ21R4J>	 <1320436514.14409.309.camel@x61.thuisdomein>  <4EB7A60D.801@ge.com> <1320659729.14409.349.camel@x61.thuisdomein>
In-Reply-To: <1320659729.14409.349.camel@x61.thuisdomein>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Nov 2011 11:10:40.0748 (UTC) FILETIME=[E29E1AC0:01CC9D3D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/11 09:55, Paul Bolle wrote:
> On Mon, 2011-11-07 at 09:34 +0000, Martyn Welch wrote:
>> On 04/11/11 19:55, Paul Bolle wrote:
>>>> +	  implementing 32 solid-state relay switched IO lines, in 4 groups of 8.
>>>> +	  The IO lines are provided as input, output or both as a build time
>>>> +	  option.
>>>
>>> What option would that be? 
>>
>> I think "Each bank of IO lines is pre-configured as input, output or both
>> depending on the variant of the card" may be a bit clearer?
> 
> So this concerns a physical build option! Anything that makes that clear
> (like your alternative does) is fine with me. (Perhaps "is
> pre-configured" could be "functions", as that's less ambiguous in a
> Kconfig file, but that's debatable.)
> 

Yes, with this card it is a physical build option.

>>> All module parameters have a sysfs visibility (or permission) of zero.
>>> Why is that? (This might very well be a naive question. But I often
>>> wonder why a certain parameter's permission isn't at least 400, just to
>>> allow a quick check of that parameter.) Are arrays tricky in sysfs? 
>>
>> Hadn't really thought about it to be honest. There seems to be plenty of
>> examples where it's set to non-zero.
> 
> (Perhaps you meant to write "set to zero" here.)
> 

I had a look to see what other drivers did before I saw Greg's email. I was
planning to at least change these to S_IRUGO for the next revision of the
patch as it would probably make sense for now I think.

> Greg already explained that it's OK to leave the code as is for now
> (since all these control knobs need to be provided via "real" sysfs
> files in the long run anyhow).
> 
>
> Paul Bolle
>

Not quite sure how that would work, would the driver be loaded then the values
written into sysfs to bind to each instance? A set of parameters are required
for each card (bus, base, vector, level and variant), I can't think of an
example of this, any ideas?

Martyn

-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)1327322748                         | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
