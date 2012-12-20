Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab2LTNCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 08:02:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab2LTNCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 08:02:13 -0500
Date: Thu, 20 Dec 2012 14:02:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Daniel Berrange <berrange@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: +
	core_pattern-set-core-helpers-root-and-namespace-to-crashing-process
	.patch added to -mm tree
Message-ID: <20121220130208.GA10813@redhat.com>
References: <20121217123428.GA1957@redhat.com> <20121217150559.GD25322@hmsreliant.think-freely.org> <20121217160408.GA20166@redhat.com> <20121217183925.GE25322@hmsreliant.think-freely.org> <20121218200604.GA28834@redhat.com> <20121218201900.GA10059@hmsreliant.think-freely.org> <20121219162230.GA17514@redhat.com> <20121219204238.GA4390@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121219204238.GA4390@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19, Neil Horman wrote:
>
> On Wed, Dec 19, 2012 at 05:22:30PM +0100, Oleg Nesterov wrote:
> >
> I wouldn't worry about it.  After looking over the changes Eric just had merged
> for 3.8 I'm becomming more convinced that this isn't really needed anymore. With
> his changes, we can migrate a process between all available namespaces
> dynamically in user space.

Except pid_namespace. You still can't change it even with setns().

However setns(CLONE_NEWPID) + fork() creates the child in the target namespace,
probably this is enough for you.

> With that functionality we can just write a setns
> administrative utility to make this all work.

Agreed.

Oleg.

