Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab1KYKKD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 05:10:03 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58710 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550Ab1KYKKA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 05:10:00 -0500
Message-ID: <1322215789.2921.78.camel@twins>
Subject: Re: [PATCH v2 14/14] Change CPUACCT to default n
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Turner <pjt@google.com>, Glauber Costa <glommer@parallels.com>,
        linux-kernel@vger.kernel.org, paul@paulmenage.org,
        daniel.lezcano@free.fr, jbottomley@parallels.com, fweisbec@gmail.com,
        Balbir Singh <bsingharora@gmail.com>
Date: Fri, 25 Nov 2011 11:09:49 +0100
In-Reply-To: <4ECEF7DD.6010403@cn.fujitsu.com>
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>
	 <1320182360-20043-15-git-send-email-glommer@parallels.com>
	 <4EBD94A0.9070703@google.com> <4EBE4A80.6090607@parallels.com>
	 <CAPM31RLUDpaxDAw00erwgmNogbuD+=LgkJ-5i9ncJw00nvryfQ@mail.gmail.com>
	 <4ECEF7DD.6010403@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-25 at 10:05 +0800, Li Zefan wrote:
> > despite it being a not entirely natural fit.  Something I proposed at
> > Prague and that we could explore here is the idea of a co-mounted
> > controller.  In this example it would only be mountable with cpu so
> > you could always depend on the cpu hierarchy being there; likewise we
> > can put (jump-labeled) touchpoints within the cpu-subsystem to call
> > out for updates as appropriate when the co-mount exists.
> > 
> 
> IIUC, this co-mounting idea is something I implemented years ago:
> 
> https://lkml.org/lkml/2008/6/18/389
> 
> The use case and the reason it was rejected:
> 
> https://lkml.org/lkml/2008/7/1/97

"This allows one subsystem to require that it only be mounted when some
other subsystems are also present in the proposed hierarchy."

That's not exactly what I meant, what I meant was that say you co-mount
cpu,cpuset the combined mount provides more features/better performance
than if you don't. Which then provides a natural incentive to actually
co-mount the stuff.

You patch looks like it forces the co-mount.
