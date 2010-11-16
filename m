Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758977Ab0KPT5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 14:57:00 -0500
Received: from smtp-out.google.com ([74.125.121.35]:20106 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758867Ab0KPT46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 14:56:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=PQ4qRGEpSuZ8ht1XT7G9gRlqLE3vTrKAdHa+gE7yO4KE6OmV+8wz+Ec6yjTYqbR9+F
         579DB5crYOHl/pazQv/Q==
MIME-Version: 1.0
In-Reply-To: <AANLkTikKdjH-ZM0eXTQMvzJjYkpyfKZR2OK06tNtCGFs@mail.gmail.com>
References: <1289820766.16406.45.camel@maggy.simson.net> <1289821590.16406.47.camel@maggy.simson.net>
 <20101115125716.GA22422@redhat.com> <1289856350.14719.135.camel@maggy.simson.net>
 <20101116015648.GA11534@redhat.com> <1289916171.5169.117.camel@maggy.simson.net>
 <1289916683.2109.625.camel@laptop> <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
 <20101116170312.GA19327@tango.0pointer.de> <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
 <20101116181603.GC19327@tango.0pointer.de> <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
 <AANLkTikjQKmo0j5xbvPiS=eriAUUZPMGKkcxt8w_z8XB@mail.gmail.com> <AANLkTikKdjH-ZM0eXTQMvzJjYkpyfKZR2OK06tNtCGFs@mail.gmail.com>
From: Paul Menage <menage@google.com>
Date: Tue, 16 Nov 2010 11:56:33 -0800
Message-ID: <AANLkTikSrN_Ur24xd7XYJyV3H8Cv9kXyDeBUpahNJHBU@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dhaval Giani <dhaval.giani@gmail.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 11:45 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> In a system daemon? Good luck with that. It's a nightmare. Maybe you
> could just poll all the cgroups, and try to remove them once a minute,
> and if they are empty it works. Or something like that. But what a
> hacky thing it would be.

There's an existing cgroups API - release_agent and notify_on_release
- whereby the kernel will spawn a userspace command once a given
cgroup is completely empty. It's intended for pretty much exactly this
purpose.

Paul
