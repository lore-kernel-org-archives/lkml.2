Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964946Ab1KJRPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 12:15:10 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:37336 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932888Ab1KJRPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 12:15:08 -0500
Message-ID: <4EBC0696.9030103@parallels.com>
Date: Thu, 10 Nov 2011 21:15:02 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>, Nathan Lynch <ntl@pobox.com>,
        Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
        Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: [PATCH 0/3] Introduce the cloning with pids functionality
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When restoring a task (or a set of tasks) we need to recreate them 
with exactly the same pid(s) as they had before. Thus we need the 
ability to create a task with specified pid. The proposal is to reuse 
the already free CLONE_STOPPED clone flag, introduce the new one
called CLONE_CHILD_USEPIDS and point to the desired pids with the
child_tidptr.

There are two cnages from the previous set doing the same.

1. The child_tidptr points to an array of pids for current namespace 
   and its ancestors. When 0 is met in this array the pid number for
   the corresponding namespace is generated, rather than set.

2. For security reasons after a regular clone/fork is done in a namespace
   further cloning with predefined pid is not allowed.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
