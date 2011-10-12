Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab1JLE0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 00:26:24 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39257 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab1JLE0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 00:26:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: david@lang.hm
Cc: Theodore Tso <tytso@MIT.EDU>, Matt Helsley <matthltc@us.ibm.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        harald@redhat.com, david@fubar.dk, greg@kroah.com,
        Linux Containers <containers@lists.osdl.org>,
        Linux Containers <lxc-devel@lists.sourceforge.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Paul Menage <paul@paulmenage.org>
References: <1317943022.1095.25.camel@mop>
	<20111007074904.GC16723@count0.beaverton.ibm.com>
	<20111007160113.GB14201@tango.0pointer.de>
	<m17h4g2jqy.fsf@fess.ebiederm.org>
	<20111010163140.GA22191@tango.0pointer.de>
	<m1mxd8lg0x.fsf_-_@fess.ebiederm.org>
	<20111011013201.GA7948@thunk.org>
	<20111011020530.GG16723@count0.beaverton.ibm.com>
	<20111011032523.GB7948@thunk.org> <m1ty7ghvvn.fsf@fess.ebiederm.org>
	<203BBB0D-293D-4BFB-A57B-41C56F58F9B3@mit.edu>
	<m17h4bfcuv.fsf@fess.ebiederm.org>
	<alpine.DEB.2.02.1110111525450.28233@asgard.lang.hm>
Date: Tue, 11 Oct 2011 21:26:32 -0700
In-Reply-To: <alpine.DEB.2.02.1110111525450.28233@asgard.lang.hm>
	(david@lang.hm's message of "Tue, 11 Oct 2011 15:30:25 -0700 (PDT)")
Message-ID: <m139eyg7if.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/NsWnM+xmPttH/QUL+2W4XYf3HYEm2Rho=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.8 RDNS_NONE Delivered to internal network by a host with no rDNS
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;david@lang.hm
X-Spam-Relay-Country: **
Subject: Re: Detecting if you are running in a container
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm writes:

> On Tue, 11 Oct 2011, Eric W. Biederman wrote:
>
>> Theodore Tso <tytso@MIT.EDU> writes:
>>
>>> On Oct 11, 2011, at 2:42 AM, Eric W. Biederman wrote:
>>>
>>>> I am totally in favor of not starting the entire world.  But just
>>>> like I find it convienient to loopback mount an iso image to see
>>>> what is on a disk image.  It would be handy to be able to just
>>>> download a distro image and play with it, without doing anything
>>>> special.
>>>
>>> Agreed, but what's wrong with firing up KVM to play with a distro
>>> image?  Personally, I don't consider that "doing something special".
>>
>> Then let me flip this around and give a much more practical use case.
>> Testing.  A very interesting number of cases involve how multiple
>> machines interact.  You can test a lot more logical machines interacting
>> with containers than you can with vms.  And you can test on all the
>> aritectures and platforms linux supports not just the handful that are
>> well supported by hardware virtualization.
>
> but in containers, you are not really testing lots of machines, you are testing
> lots of processes on the same machine (they share the same kernel)

True.  But usually that is the interesting part.

>> I admit for a lot of test cases that it makes sense not to use a full
>> set of userspace daemons.  At the same time there is not particularly
>> good reason to have a design that doesn't allow you to run a full
>> userspace.
>
> how do you share the display between all the different containers if they are
> trying to run the X server?

Either X does not start because the hardware it needs is not present or
Xnest or similar gets started.

> how do you avoid all the containers binding to the same port on the default IP
> address?

Network namespaces.

> how do you arbitrate dbus across the containers.

Why should you?

> when a new USB device gets plugged in, which container gets control of
> it?

None of them.  Although today they may all get the uevent.  None of the
containers should have permission to call mknod to mess with it.

> there are a LOT of hard questions when you start talking about running a full
> system inside a container that do not apply for other use of
> containers.

Not really mostly the answer is that you say no.

Eric
