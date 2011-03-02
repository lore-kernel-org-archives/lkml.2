Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab1CBTpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 14:45:41 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39500 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919Ab1CBTpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 14:45:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XjbeYXkV7XYT7CpUw8TPAI9pQ87SUDCwduV0mntEg2hyzkiG8ktnQK9FrDe4wmhopt
         06QcKeOjoFmsHcfQui2M3Nc1+xvl5XlLHvegD9/MdM4bOgiUZvX5AHR+mNwWAr3FL2ns
         /bcpfkyV13CljSZxxPoma9Ex0uocY3kGOe4UQ=
MIME-Version: 1.0
In-Reply-To: <1299068635.4463.1.camel@subratamodak.linux.ibm.com>
References: <4D6E2C9C.1060404@linux.vnet.ibm.com>
	<AANLkTikTM7wv0ogVPueLjK391sqaUyekquMXBea0ayFc@mail.gmail.com>
	<1299068635.4463.1.camel@subratamodak.linux.ibm.com>
Date: Wed, 2 Mar 2011 11:45:38 -0800
Message-ID: <AANLkTim+pyy=Dr7-kMrSiG=5RHqY2L6P01m9hH171D8G@mail.gmail.com>
Subject: Re: [ANNOUNCE] The Linux Test Project has been released for FEBRUARY 2011.
From: Garrett Cooper <yanegomi@gmail.com>
To: subrata@linux.vnet.ibm.com
Cc: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
        Shubham Goyal <shubham@linux.vnet.ibm.com>, ltp-list@lists.sf.net,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, vapier@gentoo.org, chrubis@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 2, 2011 at 4:23 AM, Subrata Modak
<subrata@linux.vnet.ibm.com> wrote:
> On Wed, 2011-03-02 at 13:06 +0100, Paolo Ciarrocchi wrote:
>> On Wed, Mar 2, 2011 at 12:40 PM, Shubham Goyal
>> <shubham@linux.vnet.ibm.com> wrote:
>> > Hi,
>> >
>> > The Linux Test Project test suite has been released for the month of
>> > FEBRUARY 2011. Please see ltp/INSTALL file carefully, as there has
>> > been multiple changes for building/installing the test suite after the
>> > recent changes in Makefile infrastructure.
>>
>> Wouldn't make sense to integrate this test suite in the kernel source tree?
>
> There was discussion like this some few years back. The idea was to get
> some core tests from LTP to the kernel source tree. But then the idea
> was dropped probably to avoid maintenance overhead ;-)

Putting LTP in the kernel.org sources really doesn't make sense for
the following reasons:

1. LTP isn't really tied to a single kernel release.
2. LTP isn't the only test project out there for Linux.
3. LTP has more stuff than it needs to have for testing out the kernel
(well, it did more in the past before I started cleaning it up in the
past couple of months).
4. Maintaining it will become a political bloodbath for both parties
as Linux is loosely managed by Linus et all, and LTP has been largely
developed by SGI and maintained by IBM and a few other parties like
Fujitsu, Nokia, Redhat, etc.
5. Integrating LTP into Kbuild, etc would probably be non-trivial due
to the size of LTP (but it might be easier after the Makefile
restructuring I did a year and a half ago).

That being said, if Linux devs took the initiative and submitted
testcases that either illustrated past regressions in the kernel,
feature tested enhancements, and submitted documentation that actually
described their changes to the Linux kernel and the manpages project,
I would take this over having LTP in the linux sources because right
now things largely work because the Linux sources haven't really been
rototilled since 2.4 -> 2.6, but they are somewhat bitrotted and when
Linux rototills its sources again, we'll have to go through
rototilling our stuff as well.

Right now multiple QA engineers are sort of playing whack-a-mole
trying to figure out requirements and submit tests to LTP, and since
they don't have 100% context into the actual problem, some information
is lost in translation when the tests are submitted. This isn't
desirable.

Thanks,
-Garrett
