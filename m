Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab0HCI0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 04:26:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49769 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753852Ab0HCI0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 04:26:12 -0400
Message-ID: <4C57D3C7.2010509@cn.fujitsu.com>
Date: Tue, 03 Aug 2010 16:31:03 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Daniel Lezcano <dlezcano@free.fr>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Paul Menage <menage@google.com>, Jamal Hadi Salim <hadi@cyberus.ca>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] cgroup : remove the ns_cgroup
References: <20100729195629.GA13378@hallyn.com> <20100729195812.GB19015@hallyn.com>
In-Reply-To: <20100729195812.GB19015@hallyn.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andrew

Serge E. Hallyn wrote:
> The ns_cgroup is an annoying cgroup at the namespace / cgroup frontier.
> 
> For example, a single process can not handle a big amount of namespaces
> without interacting with this cgroup and falling in an exponential creation
> time due to the nested cgroup directory depth (eg. /cgroup/<pid>/.../<pid>/...).
> 
> That was spotted when creating a single process using multiple network namespaces,
> the objective was 4096 network namespaces, but at 820 netns, the creation time
> was dramatically slow and the creation time for a namespace increased from 10msec
> to 10sec. After five hours, the expected numbers of netns was not reached.
> Without the ns_cgroup interaction, 4K netns are created after 2 minutes.
> 
> In order to solve that, we have to mount the cgroup with all the subsystems
> except the ns_cgroup, it's a little weird and hard to manage from an administration
> pov because we have to know what are the cgroup available on the system and we
> can't do a simple 'mount -t cgroup cgroup /cgroup'.
> 
> With the previous patch which adds a 'clone_children' parameter to a cgroup,
> we should be able to remove the ns_cgroup and manage manually the creation +
> adding a task to the cgroup consistenly with the rest of the subsystems.
> 
> This patch removes the ns_cgroup as suggested in the following thread:
> 
> https://lists.linux-foundation.org/pipermail/containers/2009-June/018616.html
> 
> The 'cgroup_clone' function is removed because it is no longer used.
> 
> Changelog: Jul 29 (seh): remove references to ns_cgroup_clone(), fix up
> 	   some documentation, and remove CONFIG_CGROUP_NS references.
> 
> Signed-off-by: Daniel Lezcano <dlezcano@free.fr>
> Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Paul Menage <menage@google.com>
> Cc: Jamal Hadi Salim <hadi@cyberus.ca>

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
