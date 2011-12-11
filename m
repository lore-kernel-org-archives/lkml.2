Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab1LKSpg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 13:45:36 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62060 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab1LKSpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 13:45:34 -0500
Message-ID: <4EE4FA4A.6030909@naiadhome.com>
Date: Sun, 11 Dec 2011 18:45:30 +0000
From: Peter martin <peter@naiadhome.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because
 of worrying about possible misusage?
References: <20111202231909.1ca311e2@lxorguk.ukuu.org.uk> <CAJbz7-0Xnd30nJsb7SfT+j6uki+6PJpD77DY4zARgh_29Z=-+g@mail.gmail.com> <4EDC9B17.2080701@gmail.com> <CAJbz7-2maWS6mx9WHUWLiW8gC-2PxLD3nc-3y7o9hMtYxN6ZwQ@mail.gmail.com> <4EDD01BA.40208@redhat.com> <4EDD2C82.7040804@linuxtv.org> <20111206112153.GC17194@sirena.org.uk> <4EDE0427.2050307@linuxtv.org> <20111206141929.GE17731@opensource.wolfsonmicro.com> <4EDE2B3B.2080905@linuxtv.org> <20111207134848.GB18837@opensource.wolfsonmicro.com> <4EDF71AE.5070509@linuxtv.org>
In-Reply-To: <4EDF71AE.5070509@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:c3/b8VrUoP4WGQPcbs6+CQOgqJ/kxPOVb1ZwIuropIP
 FcN2MzeQxfBOWgzTaTyXV045fZ/PHE2Sh4Nu+vXwC39HQMo39P
 nSWyvraCbgrX9bUZYq0QGQoNgcSOM/tir0ksidLtDHlHhH+MlH
 +c/fu16sWwwI7a6m15mZSryr3xz37d99/I5oq1sVjNwvuN6jN9
 7jK9rcikNkgKgX3LhSde4E71SVAAaETml4SHO/q4/4obAvw3tU
 p9f9t2j6Q9mNvwU3qKzoU/dhXmd7fMyQ8B1MWLsId5fIM4pdJf
 JfsbpJ700cfNm/oqE5WOwcOruGJM09Ab+K5NztQkuSk/itsysF
 dtN1huPn2BnMAH4fHnWE=
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One thing I have not seen addressed here is security. I've had a brief 
scan of the code, but there does not appear to be any mechanism to 
authenticate/authorise remote access to the vtunerc devices. In a home 
entertainment environment, this is not too serious, but In a non-closed 
network, for example a commercial installation in a hotel, what is to 
stop a rogue client from accessing a tuner and potentially causing 
mischief by changing settings, More seriously pulling a full MPTS of 
decrypted content from a CI card, which would make content providers 
most unhappy!

I don't know enough about kernel modules doing networking, but do the 
packets go through the iptables route, and do things like DSCP still get 
taken note of?

vtunerc sounds like a neat idea, but I am worried by the back doors it 
opens up. Sorry if I've missed something obvious here!

Pete Martin


On 07/12/2011 14:01, Andreas Oberritter wrote:
> On 07.12.2011 14:49, Mark Brown wrote:
>> On Tue, Dec 06, 2011 at 03:48:27PM +0100, Andreas Oberritter wrote:
>>> On 06.12.2011 15:19, Mark Brown wrote:
>>>> Your assertatation that applications should ignore the underlying
>>>> transport (which seems to be a big part of what you're saying) isn't
>>>> entirely in line with reality.
>>> Did you notice that we're talking about a very particular application?
>> *sigh*
>>
>>> VoIP really is totally off-topic. The B in DVB stands for broadcast.
>>> There's only one direction in which MPEG payload is to be sent (using
>>> RTP for example). You can't just re-encode the data on the fly without
>>> loss of information.
>> This is pretty much exactly the case for VoIP some of the time (though
>> obviously bidirectional use cases are rather common there's things like
>> conferencing).  I would really expect similar considerations to apply
>> for video content as they certainly do in videoconferencing VoIP
>> applications - if the application knows about the network it can tailor
>> what it's doing to that network.
>>
>> For example, if it is using a network with a guaranteed bandwidth it can
>> assume that bandwidth.  If it knows something about the structure of the
>> network it may be able to arrange to work around choke points.
>> Depending on the situation even something lossy may be the answer - if
>> it's the difference between working at all and not working then the cost
>> may be worth it.
> Once and for all: We have *not* discussed a generic video streaming
> application. It's only, I repeat, only about accessing a remote DVB API
> tuner *as if it was local*. No data received from a satellite, cable or
> terrestrial DVB network shall be modified by this application!
>
> Virtually *every* user of it will use it in a LAN.
>
> It can't be so hard to understand.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message tomajordomo@vger.kernel.org
> More majordomo info athttp://vger.kernel.org/majordomo-info.html


