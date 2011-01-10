Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab1AJVKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 16:10:19 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:60796
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753751Ab1AJVKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 16:10:17 -0500
Date: Mon, 10 Jan 2011 21:11:35 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: LSM <linux-security-module@vger.kernel.org>
Cc: James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: userns: targeted capabilities v3
Message-ID: <20110110211135.GA22446@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following is the next version of my user namespace patchset.

The core of the set is patch 2, originally conceived and
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
checks against the initial user namespace.  The rest of the
patches begin to enable capabilities in child user namespaces
to setuid, setgid, set hostnames, kill tasks, and do ptrace.

My next step would be to re-introduce a part of a several year
old patchset which assigns a userns to a superblock (and hence
to inodes), and grants 'user other' permissions to any task
whose uid does not map to the target userns.  (By default, this
will be all but the initial userns)

thanks,
-serge
