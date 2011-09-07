Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab1IGFYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 01:24:34 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54281 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab1IGFY1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 01:24:27 -0400
MIME-Version: 1.0
In-Reply-To: <1315369399-3073-3-git-send-email-glommer@parallels.com>
References: <1315369399-3073-1-git-send-email-glommer@parallels.com> <1315369399-3073-3-git-send-email-glommer@parallels.com>
From: Paul Menage <paul@paulmenage.org>
Date: Tue, 6 Sep 2011 22:24:07 -0700
X-Google-Sender-Auth: 31ZSCUo509RAqJ1hWPkjpgKfE1c
Message-ID: <CALdu-PCosvJ-SfVROLLM29RoMfxxRyW9E-_Za9A7LTAZwmkPeg@mail.gmail.com>
Subject: Re: [PATCH v2 2/9] Kernel Memory cgroup
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, netdev@vger.kernel.org, xemul@parallels.com,
        "David S. Miller" <davem@davemloft.net>,
        Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 6, 2011 at 9:23 PM, Glauber Costa <glommer@parallels.com> wrote:
> +
> +struct kmem_cgroup {
> +       struct cgroup_subsys_state css;
> +       struct kmem_cgroup *parent;
> +};

There's a parent pointer in css.cgroup, so you shouldn't need a
separate one here.

Most cgroup subsystems define this structure (and the below accessor
functions) in their .c file rather than exposing it to the world? Does
this subsystem particularly need it exposed?

> +
> +static struct cgroup_subsys_state *kmem_create(
> +       struct cgroup_subsys *ss, struct cgroup *cgrp)
> +{
> +       struct kmem_cgroup *sk = kzalloc(sizeof(*sk), GFP_KERNEL);

kcg or just cg would be a better name?

Paul
