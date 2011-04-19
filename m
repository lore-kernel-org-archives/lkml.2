Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab1DSMRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 08:17:38 -0400
Received: from relay.parallels.com ([195.214.232.42]:49102 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab1DSMRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 08:17:37 -0400
Message-ID: <4DAD7D5F.7040407@parallels.com>
Date: Tue, 19 Apr 2011 16:17:35 +0400
From: Konstantin Khlebnikov <khlebnikov@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.18) Gecko/20110416 SeaMonkey/2.0.13
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuset: allow empty cpu/node masks
References: <20110419100739.8464.80475.stgit@localhost6> <BANLkTimRV7STKcdWFXmmsQ+DLxN0bAnv3A@mail.gmail.com> <4DAD6D22.7000002@parallels.com> <BANLkTi=4vb5bm0xD=XVJGGD06_BHz+Ciyw@mail.gmail.com>
In-Reply-To: <BANLkTi=4vb5bm0xD=XVJGGD06_BHz+Ciyw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Tue, Apr 19, 2011 at 1:08 PM, Konstantin Khlebnikov
> <khlebnikov@parallels.com>  wrote:
>> Is cgroup.clone_children=1 planned to be default?
>
> I don't think so. It would be a user-visible API change, for no
> significant benefit.
>
>>
>> So, I just want to make cgroup worked out of the box:
>>
>> mount -t cgroup cgroup /cgroup
>> mkdir /cgroup/foo
>> echo $$>  /cgroup/foo/tasks
>
> Just because cgroups has a very simple filesystem-based ASCII API,
> that doesn't stop it from being a complex and
> barely-human-comprehendable system. :-)
>
> I'm not sure what we gain by making that approach work - to do useful
> stuff with cgroups (rather than simply playing around with moving
> tasks into cgroups) you do need to have a better understanding of
> what's going on. It's not too hard to make the initial instructions
> explain how to only mount the subsystems that you want, or pass the
> clone_children option.
>

Ok, then the problem is that the cgroupfs can be mounted without the
specifying set of subsystems. Thus this operation is unsafe for future compatibily.

I think it is best to oblige all subsystems to initialize their css
by default with reasonable unlimited values or to inherit they from parent.

Currently cpuset is only one cgroup that "does not work by default",
and I see no reason why it should be special.
