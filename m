Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759119Ab0KPBzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 20:55:40 -0500
Received: from smtp-out.google.com ([216.239.44.51]:33602 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962Ab0KPBzi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 20:55:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=pht408iJasN0taGS6Zd8OvPV4t9iDxESL+IVwkwGW5k8Yi8p7+qXGHxJQYJqysIzYz
         HdnTa3J9TuJ+o4lDlfAA==
MIME-Version: 1.0
In-Reply-To: <AANLkTik53N7HMyXMOEzh2Qr_4gg9eXSmXiT6TQ9gFC+h@mail.gmail.com>
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
From: Paul Menage <menage@google.com>
Date: Mon, 15 Nov 2010 17:55:13 -0800
Message-ID: <AANLkTikvcug2V70Uy7oGnO5vFZbS+DLvzP4wpysdU5uV@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>, Valdis.Kletnieks@vt.edu,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Daniel Lezcano <daniel.lezcano@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 5:18 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> so sched_debug_show() is apparently calling cgroup_path() with a NULL
> cgroup. I think it's "print_task()" that is to blame, it does
>
>     cgroup_path(task_group(p)->css.cgroup, ..
>
> without checking whether there _is_ any css.cgroup.

Right - previously the returned task_group would be always associated
with a cgroup. Now, it may not be.

The original task_group() should be made accessible for anything that
wants a real cgroup in the scheduler hierarchy, and called from the
new task_group() function. Not sure what the best naming convention
would be, maybe task_group() and effective_task_group() ?

Paul
