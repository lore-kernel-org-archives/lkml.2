Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933060Ab2DKTte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 15:49:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60331 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761063Ab2DKTtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 15:49:33 -0400
Message-ID: <4F85E045.9070706@zytor.com>
Date: Wed, 11 Apr 2012 12:49:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, drepper@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] nextfd(2)
References: <20120401125741.GA7484@p183.telecom.by> <4F78D0BA.9040709@zytor.com> <CACVxJT_WJYjecpZMGkyUrbE5gNROX1tOfFAcD84-hoPsypxcFQ@mail.gmail.com> <4F7F1864.8090606@zytor.com> <CAHGf_=rsJ8o8Fnd2z5Z8jHGc=cz370ay0_t3bhkiYRCBh3puVw@mail.gmail.com> <4F85C640.3060608@zytor.com> <CA+55aFzT1OomhJkDx+crnqRmH-kowAM4w8SRqsmPVMyh8gEwZQ@mail.gmail.com> <4F85C96B.2070803@zytor.com> <CAHGf_=qBY1uVqWiDoOQY5UrxqK8G47+J_o=HQAbutGZNdhX5Ug@mail.gmail.com>
In-Reply-To: <CAHGf_=qBY1uVqWiDoOQY5UrxqK8G47+J_o=HQAbutGZNdhX5Ug@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 12:46 PM, KOSAKI Motohiro wrote:
>>
>> a) inherently racy in a multithreaded environment;
> 
> I would say two things. 1) I know and I agree we _can_ misuse the interface.
> but many already existed interface also can be misused. 2) As I
> already explained
> this can be used correctly.
> 
> So, I have a question. Why do you bother a possibility of misuse? Of
> if you didn't point out misuse, can you please point out a real world
> use case of multi threads + fd interation?
> 

This were brought up in the POSIX discussion as part of why these
interfaces were considered undesirable.

> 
>> b) unsafe because there might be file descriptors used by libc itself.
> 
> I agree this. Even though almost developer don't use libc message catalogue and
> we can avoid such issue by using nextfd() + fcntl(O_CLOEXEC).
> 

No, that's exactly the point that we cannot.

> 
> Yeah, I don't think fdwalk() is problematic. It's an option if I
> understand Alexey's mail
> correctly. but I disagree almost all developers should fix a design
> and rewrite their
> applications. In theory, they can avoid glibc or they can rewrite all
> of their code or
> avoid linux. but there is one problem. unrealistic.
> 

The problem -- as was brought up in the POSIX discussion -- is that you
actually end up breaking *properly functioning programs*.

	-hpa
