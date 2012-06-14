Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab2FNMVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 08:21:20 -0400
Received: from mx2.parallels.com ([64.131.90.16]:42528 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362Ab2FNMVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 08:21:19 -0400
Message-ID: <4FD9D6A5.7070308@parallels.com>
Date: Thu, 14 Jun 2012 16:18:45 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <cgroups@vger.kernel.org>, <devel@openvz.org>,
        Paul Turner <pjt@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tejun Heo <tj@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
        <handai.szj@gmail.com>, <Andrew.Phillips@lmax.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v4 0/4] per cgroup cpu statistics
References: <1338907781-20904-1-git-send-email-glommer@parallels.com>
In-Reply-To: <1338907781-20904-1-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2012 06:49 PM, Glauber Costa wrote:
> Hello,
>
> This is the 4th version of this per-cgroup statistics. My aim with that is
> to provide userspace with the necessary tools to export a view of /proc/stat
> inside a container, so tools like top would work.
>
> I believe this version merges all the comments from Peter and Paul. Let me know
> if I forgot any of them.
>
> I now reuse put_prev_task to account for nr_switches, so no extra walks are added.
> For that, I had to add another parameter to the function, but I hope this is
> acceptable. Please note that this parameter would still be needed even if
> Peter's patch that merges put_prev_task behavior inside pick_next_task.
>
> This is because the previous class may live in a different class and we may
> have to call it anyway. In which case a hint like this would be needed.
> I believe this to be orthogonal to the work you are doing.
>
> Peter: the patch that adds exec_clock to rt was removed. That was my bad, it
> was intended to be part of the series that unifies cpu and cpuacct for the
> comounted case. I have them together in my tree, and I made the cut in the wrong
> place. It is not needed here.
>
> Let me know what you think of this.
>
> v4:
> * read_seq_string used instead of read_map. This is because the
>    buffer can get very big, and that's easier to fix by using seq_string
> * idle time no longer exported. It can be derived from userspace easily
> * "steal" changed to "wait", since steal is more our interpretation of it
> * nr_switches now being accounted as we walk the tree in put_prev_task, so no
>    new hierarchy walks are being inserted.
> v3:
> * completely reworked nr_switches gathering
> * separated per-se sleep_start to be more clear about it
>
>
Any comments in this incarnation of the series?

