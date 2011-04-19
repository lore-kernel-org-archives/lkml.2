Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab1DSLIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 07:08:21 -0400
Received: from relay.parallels.com ([195.214.232.42]:40140 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616Ab1DSLIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 07:08:19 -0400
Message-ID: <4DAD6D22.7000002@parallels.com>
Date: Tue, 19 Apr 2011 15:08:18 +0400
From: Konstantin Khlebnikov <khlebnikov@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.18) Gecko/20110416 SeaMonkey/2.0.13
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuset: allow empty cpu/node masks
References: <20110419100739.8464.80475.stgit@localhost6> <BANLkTimRV7STKcdWFXmmsQ+DLxN0bAnv3A@mail.gmail.com>
In-Reply-To: <BANLkTimRV7STKcdWFXmmsQ+DLxN0bAnv3A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Tue, Apr 19, 2011 at 12:07 PM, Konstantin Khlebnikov
> <khlebnikov@openvz.org>  wrote:
>>
>> This aimed to fix attaching tasks to the newly created cgroups in hierarchies with
>> cpuset subsystem. Cpuset always require initializing cpuset.cpus and cpuset.mems,
>> because they are empty by default, this fact block task attaching with -ENOSPC.
>
> You can set the cgroup.clone_children to 1 to get the parent masks
> automatically copied into the child. So I don't think this patch is
> needed.

cgroup.clone_children does not work if ns_cgroup is mounted,
but it is ok if ns_cgroup is alredy scheduled to remove soon.

However, I still think that all cgroups must have reasonable default state.
Is cgroup.clone_children=1 planned to be default?

So, I just want to make cgroup worked out of the box:

mount -t cgroup cgroup /cgroup
mkdir /cgroup/foo
echo $$ > /cgroup/foo/tasks

Initialization before tasks attaching should be optional.

>
> Paul

