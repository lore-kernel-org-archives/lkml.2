Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101Ab2CMWa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 18:30:28 -0400
Received: from mout6.freenet.de ([195.4.92.96]:34572 "EHLO mout6.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337Ab2CMWa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 18:30:27 -0400
Message-ID: <4F5FC9EA.60500@01019freenet.de>
Date: Tue, 13 Mar 2012 23:27:54 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120215 Firefox/10.0.2 SeaMonkey/2.7.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Dave Jones <davej@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-kernel@vger.kernel.org, keithp@keithp.com
Subject: Re: Corrupted files after suspend to disk
References: <jj5qhh$5j5$1@ID-44327.news.uni-berlin.de> <20120312214914.GA8628@redhat.com> <4F5F0C59.3000400@01019freenet.de> <201203132252.06417.rjw@sisk.pl>
In-Reply-To: <201203132252.06417.rjw@sisk.pl>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki schrieb:
> On Tuesday, March 13, 2012, Andreas Hartmann wrote:
>> Dave Jones wrote:
>>> On Mon, Mar 12, 2012 at 02:24:00PM +0100, Andreas Hartmann wrote:
>>>  
>>>  > >>>>> This is happening to me as well. Something like 1 resume out of 5 goes
>>>  > >>>>> wrong this very same way.
>>>  > >>>>>
>>>  > >>>>> This is thinkpad x200s.
>>>  > >>>>>
>>>  > >>>>> All the userspace is segfaulting all over the place (most frequently in
>>>  > >>>>> libselinux for some reason).
>>>  > >>>>>
>>>  > >>>>> I am not able to verify the 'drop_caches' theory, as I can't invoke a
>>>  > >>>>> single command that wouldn't crash.
>>>  > >>>>
>>>  > >>>> The question is how should we proceed?
>>>  > >>>> I've reported this issue one year (!!!) ago.
>>>  > >>>
>>>  > >>> Hmm, 3.3-rcX seems to be the first version when it started to happen to
>>>  > >>> me. I take it that you have seen this also with 3.2? 3.1?
>>>  > >>
>>>  > >> Quote from my very first email:
>>>  > >> "I'm facing a very strange problem on my netbook (Lenovo Ideapad S10)
>>>  > >> running Linux 2.6.37.4."
>>>  > > 
>>>  > > So we both seem to have Lenovos at least. I thus wanted to verify whether 
>>>  > > the problem will trigger with thinkpad_acpi removed, but it oopsed while 
>>>  > > rmmoding :) I will start looking into this right away.
>>>  > > 
>>>  > > Is your system using thinkpad_acpi as well?
>>>  > 
>>>  > I dont't think, that it is lenovo related as I'm having a MSI machine.
>>>  > 
>>>  > https://bugzilla.novell.com/show_bug.cgi?id=732908
>>>  > 
>>>  > Following the link, you are able to compare the used chips - maybe there
>>>  > are some equal components?
>>>
>>> This looks like the i915 corruption problem mentioned in a few other threads.
>>>
>>> if you compare the hexdump of the good/bad files, you find that the corruption
>>> happens in 8x 4 byte writes of either 0x00000000 or 0x00aaaaaa.
>>>
>>> KeithP clued me in last week that that looks like an ARGB pixel quad, so these
>>> writes are likely 8 pixel strips.
>>
>> Thanks Dave. I disabled i915 (with nomodeset) and voila, the problem
>> disappears. As I already know, that the problem isn't X-related (I saw
>> it even without any X involved, only with runlevel 3 and nothing more),
>> the problem seems to be now narrowed down to the relevant component.
> 
> I wonder what's the kernel command line you can reproduce the problem with?

It's the standard kernel command line of openSUSE:
root=/dev/system/root resume=/dev/system/swap splash=silent quiet vga=791 3

I added a complete dmesg output to
https://bugzilla.novell.com/show_bug.cgi?id=732908


Regards,
Andreas Hartmann
