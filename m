Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969Ab1IMWZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 18:25:00 -0400
Received: from smtp-out.google.com ([74.125.121.67]:32478 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932956Ab1IMWY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 18:24:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=cUA/Uf7RCW1fNj28FeYtylOvohsLrQBS3t3ZtfQAmRk91sxrFLlAB6ZuEJrDewm7V
	9nsrYKVR4B4wyfaM5b3+g==
Date: Tue, 13 Sep 2011 15:23:02 -0700
From: Andrew Morton <akpm@google.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>, Containers <containers@lists.osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/11 v5] cgroups: Task counter subsystem
Message-Id: <20110913152302.6c33ea6d.akpm@google.com>
In-Reply-To: <1315869091-18933-1-git-send-email-fweisbec@gmail.com>
References: <1315869091-18933-1-git-send-email-fweisbec@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Sep 2011 01:11:20 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> No functional changes. Only documentation and comments added.
> Checkpatch.pl fixes, etc...
> 

What is the actual rationale for merging all of this?  For this amount
of complexity I do think we need to see significant end-user benefits. 
But all I'm seeing in this patchset is

       This is a step to be able to isolate a bit more a cgroup
       against the rest of the system and limit the global impact of a
       fork bomb inside a given cgroup.

which is really very thin.



Also, the changelogs don't appear to mention any testing results for
the fork-bomb-killer feature.

Is the fork-bomb-killer feature realistically useful?  As I understand
it, the problem with a fork-bomb is that it causes a huge swapstorm
while creating tasks very quickly.  The latency impact of the swapping
makes it very hard to regain control of the system so you can stop the
forking.  So to be effective, this feature would need to limit the
swapping?  Or something.  More substantiation, please.



Also, what is the relationship between this and RLIMIT_NPROC?  Given
that we have user namespaces, does that give us per-user,
per-namespace, per-container rlimits?  If it doesn't, should it?  Will
it?  If it does/will, how duplicative will that be?
