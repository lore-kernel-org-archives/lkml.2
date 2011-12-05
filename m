Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab1LEUzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 15:55:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202Ab1LEUzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 15:55:47 -0500
Date: Mon, 5 Dec 2011 21:50:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, akpm@linux-foundation.org,
        serge.hallyn@canonical.com, containers@lists.linux-foundation.org,
        gkurz@fr.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1][V3] Handle reboot in a child pid namespace
Message-ID: <20111205205035.GB7422@redhat.com>
References: <1323030290-22216-1-git-send-email-daniel.lezcano@free.fr> <20111204212756.GB16362@khazad-dum.debian.net> <4EDBFD67.1040009@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDBFD67.1040009@free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05, Daniel Lezcano wrote:
>
> On 12/04/2011 10:27 PM, Henrique de Moraes Holschuh wrote:
> > On Sun, 04 Dec 2011, Daniel Lezcano wrote:
> > Daniel, can you address Miquel's concern?  Is it a valid concern, or
> > not?  I assume CAP_REBOOT functionality is still in place inside the
> > container, so it really does look like userspace would need to know
> > whether it should drop CAP_REBOOT or not, in order to automatically use
> > the new feature.
>
> Hmm, I missed its email.

Me too... so I am not sure I really understand the problem.

> I would like to address this in a separate patch in order to discuss the
> best way to do that.

Agreed.

> Adding a fake 'reboot' parameter returning EINVAL
> or 0 seems a good solution to detect at runtime if the shutdown is
> correctly supported inside a container.

Or, perhaps, we can implement sys_reboot(REBOOT_SHOULD_NOT_WORK),
sub-init can call it to disable the shutdown ?

This needs the trivial modifications in zap_pid_ns_processes()
and reboot_pid_ns().

Oleg.

