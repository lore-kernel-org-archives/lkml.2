Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab0CVMop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:44:45 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52759 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab0CVMon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:44:43 -0400
Message-ID: <4BA76639.2010007@cs.helsinki.fi>
Date: Mon, 22 Mar 2010 14:44:41 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: "Daniel P. Berrange" <berrange@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       Antoine Martin <antoine@nagafix.co.uk>,
       Olivier Galibert <galibert@pobox.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Fr?d?ric Weisbecker" <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100321200849.GA51323@dspnet.fr.eu.org> <4BA67D75.8060809@redhat.com> <4BA67F12.6030501@nagafix.co.uk> <4BA68063.2050800@redhat.com> <4BA68234.1060804@nagafix.co.uk> <4BA68997.60406@redhat.com> <20100321212009.GE30194@elte.hu> <4BA70F9A.8030304@redhat.com> <20100322114824.GF3483@elte.hu> <84144f021003220531p391975f2p5a2e0cfd3a2af6d@mail.gmail.com> <20100322123726.GH21874@redhat.com>
In-Reply-To: <20100322123726.GH21874@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

(I'm getting slightly off-topic, sorry about that.)

Daniel P. Berrange kirjoitti:
>>> Here it is, repeated for the Nth time:
>>>
>>> Allow a guest to (optionally) integrate its VFS namespace with the host side
>>> as well. An example scheme would be:
>>>
>>>   /guests/Fedora-G1/
>>>   /guests/Fedora-G1/proc/
>>>   /guests/Fedora-G1/usr/
>>>   /guests/Fedora-G1/.../
>>>   /guests/OpenSuse-G2/
>>>   /guests/OpenSuse-G2/proc/
>>>   /guests/OpenSuse-G2/usr/
>>>   /guests/OpenSuse-G2/.../
>>>
>>>  ( This feature would be configurable and would be default-off, to maintain
>>>    the current status quo. )
>> Heh, funny. That would also solve my number one gripe with
>> virtualization these days: how to get files in and out of guests
>> without having to install extra packages on the guest side and
>> fiddling with mount points on every single guest image I want to play
>> with.
> 
> FYI, for offline guests, you can use libguestfs[1] to access & change files
> inside the guest, and read-only access to running guests files. It provides
> access via a interactive shell, APIs in all major languages, and also has a
> FUSE mdule to expose it directly in the host VFS.  It could probably be made
> to work read-write for running guests too if its agent were installed inside
> the guest & leverage the new Virtio-Serial channel for comms (avoiding any
> network setup requirements).

Right. Thanks for the pointer.

The use case I am thinking of is working on an userspace project and 
wanting to test a piece of code on multiple distributions before pushing 
it out. That pretty much means being able to pull from the host git 
repository (or push to the guest repo) while the guest is running, maybe 
changing the code a bit and then getting the changes back to the host 
for the final push.

What I do now is I push the changes on the host side to a (private) 
remote branch and do the work through that. But that's pretty lame 
workaround in my opinion.

			Pekka
