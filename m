Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759934Ab1LPQgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 11:36:11 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50829 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759894Ab1LPQf4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 11:35:56 -0500
MIME-Version: 1.0
In-Reply-To: <1324038549-21605-1-git-send-email-glommer@parallels.com>
References: <1324038549-21605-1-git-send-email-glommer@parallels.com>
From: Paul Menage <paul@paulmenage.org>
Date: Fri, 16 Dec 2011 08:35:34 -0800
X-Google-Sender-Auth: EDj0oo6tfJkwkqk5mtOSDjdzk0Q
Message-ID: <CALdu-PCXb4W=LNHe14V3-EnqoPVVWkPRRGyeD+VAPrQuhXkFjw@mail.gmail.com>
Subject: Re: [RFC] cgroup basic comounting
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com, pjt@google.com,
        cgroups@vger.kernel.org, bsingharora@gmail.com, devel@openvz.org,
        kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 4:29 AM, Glauber Costa <glommer@parallels.com> wrote
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 1fd7867..e894a4f 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1211,9 +1211,9 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
>                        set_bit(i, &opts->subsys_bits);
>                        one_ss = true;
>
> -                       break;
> +                       continue;
>                }
> -               if (i == CGROUP_SUBSYS_COUNT)
> +               if (opts->subsys_bits == 0)
>                        return -ENOENT;

This is broken - it will silently ignore unknown/misspelled subsystems
that are specified after a valid subsystem. Replacing the break with a
continue is harmless but doesn't make sense - if the token already
matched a subsystem name then it won't match any other subsystem.

What change are you actually trying to effect with this patch?

Paul
