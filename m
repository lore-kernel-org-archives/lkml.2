Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab2KTIgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 03:36:04 -0500
Received: from hotel311.server4you.de ([85.25.146.15]:51244 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab2KTIgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 03:36:02 -0500
Message-ID: <50AB40EF.8050304@monom.org>
Date: Tue, 20 Nov 2012 09:35:59 +0100
From: Daniel Wagner <wagi@monom.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: serge.hallyn@canonical.com, ebiederm@xmission.com, nhorman@tuxdriver.com,
        tgraf@suug.ch, davem@davemloft.net, lizefan@huawei.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/7] netcls_cgroup: move config inheritance to ->css_online()
 and remove .broken_hierarchy marking
References: <1353400211-5182-1-git-send-email-tj@kernel.org> <1353400211-5182-2-git-send-email-tj@kernel.org>
In-Reply-To: <1353400211-5182-2-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.11.2012 09:30, Tejun Heo wrote:
> It turns out that we'll have to live with attributes which are
> inherited at cgroup creation time but not affected by further updates
> to the parent afterwards - such attributes are already in wide use
> e.g. for cpuset.
>
> So, there's nothing to do for netcls_cgroup for hierarchy support.
> Its current behavior - inherit only during creation - is good enough.
>
> Move config inheriting from ->css_alloc() to ->css_online() for
> consistency, which doesn't change behavior at all, and remove
> .broken_hierarchy marking.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>

Not introducing the 'is_local' is a good thing.

Tested and Acked-by: Daniel Wagner <daniel.wagner@bmw-carit.de>

