Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab1BWRIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:08:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932124Ab1BWRIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:08:54 -0500
Message-ID: <4D653F1D.2090106@redhat.com>
Date: Wed, 23 Feb 2011 19:08:45 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mtosatti@redhat.com,
        xiaoguangrong@cn.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 1/3] Weight-balanced tree
References: <20110222183822.22026.62832.stgit@s20.home>	 <20110222185456.22026.28200.stgit@s20.home>  <4D6506FB.2090809@redhat.com> <1298480563.18387.6.camel@x201>
In-Reply-To: <1298480563.18387.6.camel@x201>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2011 07:02 PM, Alex Williamson wrote:
> >
> >  obj-$(CONFIG_WEIGHT_BALANCED_TREE) += wbtree.o
> >
> >  then kvm can select it, and the impact on non-kvm kernels is removed.
>
> Then we'd have issues trying to build an external kvm module for a
> pre-existing non-kvm kernel.  Do we care?

Officially, no.

What we typically do in these cases is copy the code into the kvm-kmod 
compatibility layer and compile it if the kernel doesn't supply it (like 
all older kernels regardless of config).

> If we were to take such a
> path, I think the default should be on, kvm would depend on it, but we
> could add an option to disable it for EMBEDDED/EXPERT.  Thanks,

That would work as well.

-- 
error compiling committee.c: too many arguments to function

