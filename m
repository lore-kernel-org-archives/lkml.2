Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab0KPS0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 13:26:19 -0500
Received: from smtp-out.google.com ([74.125.121.35]:28299 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738Ab0KPS0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 13:26:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=jVCZsgTJ+F2SmF1inZGtuTDDFRVUr5tZb3EyETXY5BpPmuzvKmZu0GGY2pqdDGZHOn
         /pQXtywgab9+paeuXVjw==
MIME-Version: 1.0
In-Reply-To: <1289912299.5169.53.camel@maggy.simson.net>
References: <1287479765.9920.9.camel@marge.simson.net> <1287487757.24189.40.camel@marge.simson.net>
 <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com>
 <1287511983.7417.45.camel@marge.simson.net> <1287514410.7368.10.camel@marge.simson.net>
 <20101020025652.GB26822@elte.hu> <1287648715.9021.20.camel@marge.simson.net>
 <20101021105114.GA10216@Krystal> <1287660312.3488.103.camel@twins>
 <20101021162924.GA3225@redhat.com> <1288076838.11930.1.camel@marge.simson.net>
 <1288078144.7478.9.camel@marge.simson.net> <AANLkTimOJAv2uRfq4bW_QPngkGCmJDjNX5n_izpX=eB8@mail.gmail.com>
 <1289489200.11397.21.camel@maggy.simson.net> <30291.1289860866@localhost>
 <1289864780.14719.172.camel@maggy.simson.net> <AANLkTikztvdgFucCUjZ+A5Je-LUKLknV5+aznVvL98oQ@mail.gmail.com>
 <1289865870.14719.185.camel@maggy.simson.net> <AANLkTik53N7HMyXMOEzh2Qr_4gg9eXSmXiT6TQ9gFC+h@mail.gmail.com>
 <AANLkTikvcug2V70Uy7oGnO5vFZbS+DLvzP4wpysdU5uV@mail.gmail.com> <1289912299.5169.53.camel@maggy.simson.net>
From: Paul Menage <menage@google.com>
Date: Tue, 16 Nov 2010 10:25:52 -0800
Message-ID: <AANLkTikzPaM3wReKZJiUUL5ooRJ5zXy3+wVU92rykcFw@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
To: Mike Galbraith <efault@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Daniel Lezcano <daniel.lezcano@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 4:58 AM, Mike Galbraith <efault@gmx.de> wrote:
>
> A tasty alternative would be to have autogroup be it's own subsystem,
> with full cgroup userspace visibility/tweakability.

What exactly do you envisage by that? Having autogroup (in its current
incarnation) be a subsystem wouldn't really make sense - there's
already a cgroup subsystem for partitioning CPU scheduler groups. If
autogroups were integrated with cgroups I think that it would be as a
way of automatically creating (and destroying?) groups based on tty
connectedness.

We tried something like this with the ns subsystem, which would
create/enter a new cgroup whenever a new namespace was created; in the
end it turned out to be more of a nuisance than anything else.

People have proposed all sorts of in-kernel approaches for
auto-creation of cgroups based on things like userid, process name,
now tty, etc.

The previous effort for kernel process grouping (CKRM) started off
with a complex in-kernel rules engine that was ultimately dropped and
moved to userspace. My feeling is that userspace is a better place for
this - as Lennart pointed out, you can get a similar effect with a few
lines tweaking in a bash login script or a pam module that's much more
configurable from userspace and keeps all the existing cgroup stats
available.

Paul
