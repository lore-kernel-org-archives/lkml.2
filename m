Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841Ab2JCANT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 20:13:19 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47658 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932810Ab2JCANR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 20:13:17 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1210030159440.31999@twin.jikos.cz>
References: <1340285798-8322-1-git-send-email-mchehab@redhat.com>
 <4FE37194.30407@redhat.com> <4FE8B8BC.3020702@iki.fi> <4FE8C4C4.1050901@redhat.com>
 <4FE8CED5.104@redhat.com> <20120625223306.GA2764@kroah.com>
 <4FE9169D.5020300@redhat.com> <20121002100319.59146693@redhat.com>
 <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
 <20121002221239.GA30990@kroah.com> <20121002222333.GA32207@kroah.com>
 <CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com> <alpine.LRH.2.00.1210030159440.31999@twin.jikos.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 2 Oct 2012 17:12:55 -0700
X-Google-Sender-Auth: F9IR-3JcpzqyBo7ssB5J4DcGskE
Message-ID: <CA+55aFwz_7sksJRnFHZQFHD001ihF7ejkk5+-6Punc2dFtoqVQ@mail.gmail.com>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use request_firmware_nowait()
To: Jiri Kosina <jkosina@suse.cz>
Cc: Greg KH <gregkh@linuxfoundation.org>, Kay Sievers <kay@vrfy.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 5:01 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Tue, 2 Oct 2012, Linus Torvalds wrote:
>
>> And see this email from Kay Sievers that shows that it was all known
>> about and intentional in the udev camp:
>>
>>   http://www.spinics.net/lists/netdev/msg185742.html
>
> This seems confusing indeed.
>
> That e-mail referenced above is talking about loading firmware at ifup
> time. While that might work for network device drivers (I am not sure even
> about that), what are the udev maintainers advice for other drivers, where
> there is no analogy to ifup?

Yeah, it's an udev bug. It really is that simple.

This is why I'm complaining. There's no way in hell we're fixing this
in kernel space, unless we call the "bypass udev entirely because the
maintainership quality of it has taken a nose dive". Yes, I've seen
some work-around patches, but quite frankly, I think it would be
absolutely insane for the kernel to work around the fact that udev is
buggy.

The fact is, doing request_firmware() from within module_init() is
simply the easiest approach for some devices.

Now, at the same time, I do agree that network devices should
generally try to delay it until ifup time, so I'm not arguing against
that part per se. I do think that when possible, people should aim to
delay firmware loading until as late as reasonable.

But as you point out, it's simply not always reasonable, and the media
people are clearly hitting the cases where it's just painful. Now,
those cases seem to be happily fairly *rare*, so this isn't getting a
ton of attention, but we should fix it.

Because the udev behavior is all pain, no gain. There's no *reason*
for udev to be pissy about this. And it didn't use to be.

                    Linus
