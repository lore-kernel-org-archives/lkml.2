Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030420Ab2HPUIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 16:08:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933205Ab2HPUIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 16:08:46 -0400
Date: Thu, 16 Aug 2012 13:08:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: aris@ruivo.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH RESEND 0/4] device_cgroup: replace internally whitelist
 with exception list
Message-Id: <20120816130844.6f26530d.akpm@linux-foundation.org>
In-Reply-To: <20120809190414.773462171@muttley.lan.cathedral>
References: <20120809190414.773462171@muttley.lan.cathedral>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Aug 2012 15:04:14 -0400
aris@ruivo.org wrote:

> The original model of device_cgroup is having a whitelist where all the
> allowed devices are listed. The problem with this approach is that is
> impossible to have the case of allowing everything but few devices.
> 
> The reason for that lies in the way the whitelist is handled internally:
> since there's only a whitelist, the "all devices" entry would have to be
> removed and replaced by the entire list of possible devices but the ones
> that are being denied.  Since dev_t is 32 bits long, representing the allowed
> devices as a bitfield is not memory efficient.
> 
> This patch replaces the "whitelist" by a "exceptions" list and the default
> policy is kept as "deny_all" variable in dev_cgroup structure.

The patches look reasonable to me.  I suggest you resend them after
kernel summit and cc a few additional people: Serge Hallyn, Pavel
Emelyanov and James Morris.
