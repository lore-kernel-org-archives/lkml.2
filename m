Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab1KZNHs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 08:07:48 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41332 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab1KZNHr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 08:07:47 -0500
MIME-Version: 1.0
In-Reply-To: <4ECEF7DD.6010403@cn.fujitsu.com>
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>
 <1320182360-20043-15-git-send-email-glommer@parallels.com>
 <4EBD94A0.9070703@google.com> <4EBE4A80.6090607@parallels.com>
 <CAPM31RLUDpaxDAw00erwgmNogbuD+=LgkJ-5i9ncJw00nvryfQ@mail.gmail.com> <4ECEF7DD.6010403@cn.fujitsu.com>
From: Paul Turner <pjt@google.com>
Date: Sat, 26 Nov 2011 05:07:12 -0800
Message-ID: <CAPM31RLnSYKLjUx4ntkxD5TJ2qbQAXX0p9TVBC77OsPHVoP5XQ@mail.gmail.com>
Subject: Re: [PATCH v2 14/14] Change CPUACCT to default n
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        paul@paulmenage.org, daniel.lezcano@free.fr, a.p.zijlstra@chello.nl,
        jbottomley@parallels.com, fweisbec@gmail.com,
        Balbir Singh <bsingharora@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 6:05 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> despite it being a not entirely natural fit.  Something I proposed at
>> Prague and that we could explore here is the idea of a co-mounted
>> controller.  In this example it would only be mountable with cpu so
>> you could always depend on the cpu hierarchy being there; likewise we
>> can put (jump-labeled) touchpoints within the cpu-subsystem to call
>> out for updates as appropriate when the co-mount exists.
>>
>
> IIUC, this co-mounting idea is something I implemented years ago:
>
> https://lkml.org/lkml/2008/6/18/389
>
> The use case and the reason it was rejected:
>
> https://lkml.org/lkml/2008/7/1/97
>

Rejection is a bit of a strong statement -- the idea seemed amenable
but lacking a strong use-case.  That said, taking a deep look at some
of what Glauber is trying to do in this series I don't think it's
something that would help here.

For this discussion the motivation for a co-mount would be to
piggy-back on the cpu sub-systems own hierarchy walks to reduce
overhead.  However, this is not structured in a way that can take
advantage of this, and, looking at what Glauber is attempting to
collect it's not clear that it can be.

I think this moves the discussion towards whether we should consider
deprecating some of the exported fields (namely usage and
usage_per_cpu) from cpuacct instead of the entire controller as we had
initially desired.  This would allow cpuacct to exist with a much
lower overhead, especially within the context-switch path.

- Paul

> --
> Li Zefan
>
