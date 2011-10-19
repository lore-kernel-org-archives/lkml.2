Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab1JSJiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 05:38:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103Ab1JSJiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 05:38:12 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1318974898-21431-7-git-send-email-serge@hallyn.com>
References: <1318974898-21431-7-git-send-email-serge@hallyn.com> <1318974898-21431-1-git-send-email-serge@hallyn.com>
To: Serge Hallyn <serge@hallyn.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        akpm@linux-foundation.org, oleg@redhat.com, richard@nod.at,
        mikevs@xs4all.net, segoon@openwall.com, gregkh@suse.de,
        eparis@redhat.com, "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 6/9] Add Documentation/namespaces/user_namespace.txt (v3)
Date: Wed, 19 Oct 2011 10:36:31 +0100
Message-ID: <15182.1319016991@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Hallyn <serge@hallyn.com> wrote:

> To this new task, any resource belonging to the initial user namespace will
> appear to belong to user and group 'nobody', which are UID and GID -1.
> Permission to open such files will be granted according to world access
> permissions.  UID comparisons and group membership checks will return false,
> and privilege will be denied.

The last comma there is unnecessary, I think.  You might also want to say
'will fail' rather than 'will return false', but I'm not sure that sums it up
correctly.

> When a task belonging to (for example) userid 500 in the initial user namespace

Why switch to talking about 'userid'?  This should probably be 'UID'.

> Userid mapping for the VFS is not yet implemented, though prototypes exist.

Ditto.

> ... Therefore, attempts to exercise privilege to resources in, for instance,
> a particular network namespace, can be properly validated by checking whether
> the caller has the needed privilege (i.e.  CAP_NET_ADMIN) targeted to the
> user namespace which owns the network namespace.

That sentence looks rather clumsy.  I think you need to split the statement
from the example.

  Other namespaces, such as UTS and network, are owned by a user namespace.
  When such a namespace is created, it is assigned to [owned by? associated
  with?] the user namespace of the task by which it was created.  Attempts to
  exercise privilege in the new namespace are properly validated by checking
  whether the caller has the needed privilege targeted to [granted by?] the
  user namespace that owns the new namespace.  For instance, to use the
  resources in a network namespace, a check must be made that the caller has
  [has been granted?] the CAP_NET_ADMIN privilege.  This is done using the
  ns_capable() function.

You may want to list here what CAPs correspond to what namespaces.

> As an example, if a new task is cloned with a private user namespace but
> no

'not a' instead of 'no'?

> private network namespace, then the task's network namespace is owned
> by the parent user namespace.  The new task has no

Insert 'special' here?

> privilege to

s/to/over/ perhaps?

> the
> parent user namespace, so it will not be able to create or configure

'the'

> network devices

Insert 'therein'?

> .  If,

I don't think you need the comma here.  The 'instead' is the if condition.

> instead, the task were cloned with both private
> user and network namespaces, then the private network namespace is owned
> by the private user namespace, and so root in the new user namespace
> will have privilege targeted to

Interestingly, in these two paragraphs, you've used 'targeted to' in both
directions.

	whether the caller has the needed privilege (...) targeted to the user
	namespace

vs

	the new user namespace will have privilege targeted to the network
	namespace

You might want to consider changing one of them.  I would suggest 'granted by'
for the first and 'targeted at [users of]' for the second.

> the network namespace.  It will be able
> to create and configure network devices.

David
