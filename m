Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934152Ab1JEJOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 05:14:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:50183 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933575Ab1JEJOS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 05:14:18 -0400
Subject: Re: [PATCH 09/10] provide a version of cpuusage statistics inside
 cpu cgroup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, jbottomley@parallels.com,
        Balbir Singh <bsingharora@gmail.com>
Date: Wed, 05 Oct 2011 11:14:08 +0200
In-Reply-To: <1317583287-18300-10-git-send-email-glommer@parallels.com>
References: <1317583287-18300-1-git-send-email-glommer@parallels.com>
	 <1317583287-18300-10-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317806048.6766.8.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-02 at 23:21 +0400, Glauber Costa wrote:
> +       if (tg->cpustat)
> +               free_percpu(tg->cpustat);
> +       if (tg->cpuusage)
> +               free_percpu(tg->cpuusage); 

void free_percpu(void __percpu *ptr)
{
        void *addr;
        struct pcpu_chunk *chunk;
        unsigned long flags;
        int off;

        if (!ptr)
                return;
	...
}
