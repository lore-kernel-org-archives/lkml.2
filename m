Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab1LVNLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 08:11:46 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61355 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab1LVNLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 08:11:43 -0500
Message-Id: <20111222125639.360640574@openvz.org>
User-Agent: quilt/0.48-1
Date: Thu, 22 Dec 2011 16:56:39 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 0/4] kernel generic object IDs series
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when we do the checkpoint-restore we need to find out if various kernel objects
(like mm_struct-s of file_struct-s) are shared between tasks (and restore them
after).

While at restore time we can use CLONE_XXX flags and unshare syscall there is
no way to find out sharing structures at checkpoint time. Thus, to chop the
knit, we introduce generic-object-ids helpers which do basically encode
kernel pointers into some form (at moment is's simple XOR operation over
a random cookie value) and provide them back to userspace. So one can test
if two resource are shared between different task.

Since such information is pretty valuable -- it's allowed for CAP_SYS_ADMIN
only since xor encoded values has nothing to do with security but used only
to break an impression that ID means something other than random "number"
which should be used for "sameness" test only and nothing else.

The following objects are shown at the moment

 - all namespaces living in /proc/pid/ns/
 - open files (shown in /proc/pid/fdinfo/)
 - objects, that can be shared with CLONE_XXX flags (except for namespaces)

Any kind of comments and especially complains (!) are very appreciated!

Cyrill
