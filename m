Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab1HYJOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 05:14:35 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51852 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab1HYJOd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 05:14:33 -0400
MIME-Version: 1.0
In-Reply-To: <1314138000-2049-4-git-send-email-tj@kernel.org>
References: <1314138000-2049-1-git-send-email-tj@kernel.org> <1314138000-2049-4-git-send-email-tj@kernel.org>
From: Paul Menage <paul@paulmenage.org>
Date: Thu, 25 Aug 2011 02:14:12 -0700
X-Google-Sender-Auth: JYjZiaxN-zm01amiRxmvwZsvAsk
Message-ID: <CALdu-PDAgqeRJt5vqTB9wddwz70Yn+Jf-Pb0dDKDBD_q37tHQg@mail.gmail.com>
Subject: Re: [PATCH 3/6] cgroup: introduce cgroup_taskset and use it in
 subsys->can_attach(), cancel_attach() and attach()
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, lizf@cn.fujitsu.com, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 3:19 PM, Tejun Heo <tj@kernel.org> wrote:
> Currently, there's no way to pass multiple tasks to cgroup_subsys
> methods necessitating the need for separate per-process and per-task
> methods.  This patch introduces cgroup_taskset which can be used to
> pass multiple tasks and their associated cgroups to cgroup_subsys
> methods.
>
> Three methods - can_attach(), cancel_attach() and attach() - are
> converted to use cgroup_taskset.  This unifies passed parameters so
> that all methods have access to all information.  Conversions in this
> patchset are identical and don't introduce any behavior change.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>

The general idea of passing consistent information to all *attach
methods seems good, but isn't it simpler to just fix up the various
method signatures?

The whole point of having *attach() and *attach_task() was to minimize
the amount of boilerplate (in this case, iterating across a new
cgroup_taskset abstraction) in the subsystems, leaving that to the
cgroups framework.

Paul
