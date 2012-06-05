Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761533Ab2FEJgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 05:36:42 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:57162 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202Ab2FEJgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 05:36:40 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jun 2012 05:36:38 EDT
Message-ID: <4FCDD315.502@free.fr>
Date: Tue, 05 Jun 2012 11:36:21 +0200
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, devel@openvz.org,
        kir@parallels.com, Serge Hallyn <serge.hallyn@canonical.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] allow a task to join a pid namespace
References: <1338816828-25312-1-git-send-email-glommer@parallels.com>
In-Reply-To: <1338816828-25312-1-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 03:33 PM, Glauber Costa wrote:
> Currently, it is possible for a process  to join existing
> net, uts and ipc namespaces. This patch allows a process to join an
> existing pid namespace as well.
> 
> For that to remain sane, some restrictions are made in the calling process:
> 
> * It needs to be in the parent namespace of the namespace it wants to jump to
> * It needs to sit in its own session and group as a leader.
> 
> The rationale for that, is that people want to trigger actions in a Container
> from the outside. For instance, mainstream linux recently gained the ability
> to safely reboot a container. It would be desirable, however, that this
> action is triggered from an admin in the outside world, very much like a
> power switch in a physical box.
> 
> This would also allow us to connect a console to the container, provide a
> repair mode for setups without networking (or with a broken one), etc.

Hi Glauber,

I am in favor of this patch but I think the pidns support won't be
complete and some corner-cases are not handled.

May be you can look at Eric's patchset [1] where, IMO, everything is
taken into account. Some of the patches may be already upstream.

Thanks
  -- Daniel

[1]
http://git.kernel.org/?p=linux/kernel/git/ebiederm/linux-namespace-control-devel.git;a=summary
