Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243Ab2DKUck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:32:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60634 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933225Ab2DKUci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:32:38 -0400
Message-ID: <4F85EA5E.6070106@zytor.com>
Date: Wed, 11 Apr 2012 13:32:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, drepper@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] nextfd(2)
References: <20120401125741.GA7484@p183.telecom.by> <4F78D0BA.9040709@zytor.com> <CACVxJT_WJYjecpZMGkyUrbE5gNROX1tOfFAcD84-hoPsypxcFQ@mail.gmail.com> <4F7F1864.8090606@zytor.com> <CAHGf_=rsJ8o8Fnd2z5Z8jHGc=cz370ay0_t3bhkiYRCBh3puVw@mail.gmail.com> <4F85C640.3060608@zytor.com> <CA+55aFzT1OomhJkDx+crnqRmH-kowAM4w8SRqsmPVMyh8gEwZQ@mail.gmail.com> <4F85C96B.2070803@zytor.com> <CAHGf_=qBY1uVqWiDoOQY5UrxqK8G47+J_o=HQAbutGZNdhX5Ug@mail.gmail.com> <4F85E045.9070706@zytor.com> <CAHGf_=pjksePXKsnfmxBC1BNgd_jDuy=-q9WMvM4UHjKi_fPaQ@mail.gmail.com>
In-Reply-To: <CAHGf_=pjksePXKsnfmxBC1BNgd_jDuy=-q9WMvM4UHjKi_fPaQ@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 01:23 PM, KOSAKI Motohiro wrote:
> 
> Hmmm.... I'm sorry I don't find "considered undesirable". Maybe because
> my English is not very good. can you please help me clarify?
> 

I also went and read the mailing list discussion on the topic.

Ulrich, for example (in his usual mild-mannered style), commented:

> And all these programs and systems are wrong.
> 
> There is no guarantee that one of the fds isn't used behind the
> scenes for something important which is still running as part of the
> fork/exec code.  It's completely unacceptable to build into the
> interfaces the assumption that the programmer knows all the file
> descriptors.
> 
> This is why using CLOEXEC is the only correct way to deal with this
> and now there is no exceuse anymore whatsoever. Every fd-creating
> interface can use CLOEXEC.

> This text says,
> 
>> so a future revision of the standard may indeed add fdwalk( ), although no
>> one in the meeting was willing to draft a proposal for fdwalk( ) at this time
> 
> and, later says after noting F_NEXT and O_CLOEXEC,
> 
>> Therefore, the rest of this proposal seeks to document the problem
>> with closing arbitrary file descriptors, and a new bugid will be
>> opened to propose standardizing some recent interfaces and interface
>> extensions first appearing in Linux
> 
> Do you think latter override former?

Yes.

>>>> b) unsafe because there might be file descriptors used by libc itself.
>>>
>>> I agree this. Even though almost developer don't use libc message catalogue and
>>> we can avoid such issue by using nextfd() + fcntl(O_CLOEXEC).
>>
>> No, that's exactly the point that we cannot.
> 
> I thknk we are talking different aspect. I'm talking practical issue.
> say, ruby hit the exact same issue
> because valgrind uses internal fds and they don't think their exec()
> case don't need fd
> inheritance. Even though it close libc internal fds, invoked new
> executable may open them
> again at process strtup code. Therefore, they are using O_CLOEXEC. In
> the other hands,
> you seems talking about it is corner case. If so, I agree. I was not
> argue it. I only say, I
> haven't seen real world application require it.
> 
> Personally, I'm only interesting real world issue.

These are real-world issues.

>> The problem -- as was brought up in the POSIX discussion -- is that you
>> actually end up breaking *properly functioning programs*.
> 
> But the url only talk about a possibility of misuse.

There are concrete examples on the mailing list.

Anyway, fdwalk() at least exists as an interface.  There is absolutely
no momentum for FD_NEXT that I can see.

	-hpa

