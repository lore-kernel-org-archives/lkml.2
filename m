Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab1KXNYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 08:24:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:42146 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab1KXNYu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 08:24:50 -0500
Message-ID: <1322141073.2921.51.camel@twins>
Subject: Re: [PATCH v2 14/14] Change CPUACCT to default n
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Glauber Costa <glommer@parallels.com>,
        Balbir Singh <bsingharora@gmail.com>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, jbottomley@parallels.com, fweisbec@gmail.com
Date: Thu, 24 Nov 2011 14:24:33 +0100
In-Reply-To: <20111121105957.9c85db16.kamezawa.hiroyu@jp.fujitsu.com>
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>
	 <1320182360-20043-15-git-send-email-glommer@parallels.com>
	 <4EBD94A0.9070703@google.com> <4EBE4A80.6090607@parallels.com>
	 <CAPM31RLUDpaxDAw00erwgmNogbuD+=LgkJ-5i9ncJw00nvryfQ@mail.gmail.com>
	 <CAKTCnzkFb2rRyOJ3Uxt13mXrB-9Ox=zgXAOZ5bZ_6Kwr64AbTA@mail.gmail.com>
	 <20111117085251.443fefa5.kamezawa.hiroyu@jp.fujitsu.com>
	 <4EC47632.2000904@parallels.com>
	 <CAKTCnznzpqUbMJEMwaewwjvMW1fG0J3=a8JxqKiHKNuffO7azg@mail.gmail.com>
	 <4EC52F32.2040708@parallels.com>
	 <20111121105957.9c85db16.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 10:59 +0900, KAMEZAWA Hiroyuki wrote:
> Could you share your analysis why cpuacct cgroup is slow ?

It adds accounting to all scheduler hot paths, accounting that is mostly
duplicate of accounting already done. It also does another cgroup
hierarchy walk, separate from existing controllers, hitting all cold
cachelines again.

IOW, it sucks chunks and I should never have allowed it to be merged.
