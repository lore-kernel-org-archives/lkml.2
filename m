Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab1KXQ31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 11:29:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:44397 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab1KXQ30 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 11:29:26 -0500
Message-ID: <1322152152.2921.64.camel@twins>
Subject: Re: [PATCH v2 14/14] Change CPUACCT to default n
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, jbottomley@parallels.com, fweisbec@gmail.com
Date: Thu, 24 Nov 2011 17:29:12 +0100
In-Reply-To: <4ECE6BC4.7090600@parallels.com>
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
	 <1322141073.2921.51.camel@twins> <4ECE6BC4.7090600@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-24 at 14:07 -0200, Glauber Costa wrote:
> OTOH, if the use case for it includes separating processes for the cpu 
> and cpuacct cgroups in an independent manner - which apparently it does, 
> I've just learned, there isn't much we can do except try to make it cheaper.

Yeah it allows that, but is that really useful? If we buy that argument
shouldn't we split up controllers to be as minimal as possible to that
you get as great a number of independent cgroups as possible?

That way lies madness if you ask me. The two biggest controllers we
currently have are cpu and memcg, and they aren't as orthogonal as you
might think, see how cpusets has both a task affinity as well as node
affinity side.

The more comprehensive these controllers become, the greater also the
overlap in functionality and thus a reduction in separation.

Really, what is the killer case for separating all this nonsense? And
no: 'Because $ustomer wants it', doesn't count.
