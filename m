Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab0LQPW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 10:22:27 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:47014
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752413Ab0LQPW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:22:26 -0500
Date: Fri, 17 Dec 2010 15:22:46 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: LSM <linux-security-module@vger.kernel.org>
Cc: James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <michael.kerrisk@gmail.com>
Subject: [RFC 0/5] user namespaces: start clamping down
Message-ID: <20101217152246.GA8221@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following is the next version of the user namespace patchset.

The core of the set is patch 2, originally conceived of and
implemented by Eric Biederman.  The concept is to target
capabilities at user namespaces.  A task's capabilities are
now contextualized as follows (previously, capabilities had
no context):

1. For a task in the initial user namespace, the calculated
capabilities (pi, pe, pp) are available to act upon any
user namespace.

2. For a task in a child user namespace, the calculated
capabilities are available to act only on its own or any
descendent user namespace.  It has no capabilities to any
parent or unrelated user namespaces.

3. If a user A creates a new user namespace, that user has
all capabilities to that new user namespace and any of its
descendents.  (Contrast this with a user namespace created
by another user B in the same user namespace, to which this
user A has only his calculated capabilities)

All existing 'capable' checks are automatically converted to
checks against the initial user namespace.  This means that
by default, root in a child user namespace is powerless.
Patches 3-5 begin to enable capabilities in child user
namespaces to set hostnames, kill tasks, and do ptrace.

My near-term next goals will be to enable setuid and setgid,
and to provide a way for the filesystem to be usable in child
user namespaces.  At the very least I'd like a fresh loopback
or LVM mount and proc mounts to be supported.

thanks,
-serge
