Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab1LPGVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 01:21:16 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49624 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab1LPGVO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 01:21:14 -0500
MIME-Version: 1.0
In-Reply-To: <1323676029-5890-2-git-send-email-glommer@parallels.com>
References: <1323676029-5890-1-git-send-email-glommer@parallels.com> <1323676029-5890-2-git-send-email-glommer@parallels.com>
From: Greg Thelen <gthelen@google.com>
Date: Thu, 15 Dec 2011 22:20:52 -0800
Message-ID: <CAHH2K0YUK9CVk4Ds3cPA=6SNjX0y79nSo+Vy8r1H5PiVXA1RWQ@mail.gmail.com>
Subject: Re: [PATCH v9 1/9] Basic kernel memory functionality for the Memory Controller
To: Glauber Costa <glommer@parallels.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, paul@paulmenage.org,
        lizf@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
        ebiederm@xmission.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        kirill@shutemov.name, avagin@parallels.com, devel@openvz.org,
        eric.dumazet@gmail.com, cgroups@vger.kernel.org,
        Johannes Weiner <jweiner@redhat.com>, Michal Hocko <mhocko@suse.cz>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 11, 2011 at 11:47 PM, Glauber Costa <glommer@parallels.com> wrote:
> +Memory limits as specified by the standard Memory Controller may or may not
> +take kernel memory into consideration. This is achieved through the file
> +memory.independent_kmem_limit. A Value different than 0 will allow for kernel

s/Value/value/

It is probably worth documenting the default value for
memory.independent_kmem_limit?  I figure it would be zero at root and
and inherited from parents.  But I think the implementation differs.

> @@ -277,6 +281,11 @@ struct mem_cgroup {
>         */
>        unsigned long   move_charge_at_immigrate;
>        /*
> +        * Should kernel memory limits be stabilished independently
> +        * from user memory ?
> +        */
> +       int             kmem_independent_accounting;

I have no serious objection, but a full int seems like overkill for a
boolean value.

> +static int register_kmem_files(struct cgroup *cont, struct cgroup_subsys *ss)
> +{
> +       int ret = 0;
> +
> +       ret = cgroup_add_files(cont, ss, kmem_cgroup_files,
> +                              ARRAY_SIZE(kmem_cgroup_files));
> +       return ret;

If you want to this function could be condensed down to:
  return cgroup_add_files(...);
