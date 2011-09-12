Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750972Ab1ILEFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 00:05:20 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37018 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab1ILEFS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 00:05:18 -0400
MIME-Version: 1.0
In-Reply-To: <1315159280-25032-4-git-send-email-htejun@gmail.com>
References: <1315159280-25032-1-git-send-email-htejun@gmail.com> <1315159280-25032-4-git-send-email-htejun@gmail.com>
From: Paul Menage <paul@paulmenage.org>
Date: Sun, 11 Sep 2011 21:04:55 -0700
X-Google-Sender-Auth: eSH3jfa0sksqEBfvADpGRfh-hKk
Message-ID: <CALdu-PBhhH0p5QfET4ZHbKVwfVFEME9v7kzUyQiPyykFscB2Ng@mail.gmail.com>
Subject: Re: [PATCH 3/4] threadgroup: extend threadgroup_lock() to cover exit
 and exec
To: Tejun Heo <htejun@gmail.com>
Cc: rjw@sisk.pl, lizf@cn.fujitsu.com, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        fweisbec@gmail.com, matthltc@us.ibm.com, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Paul Menage <menage@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 4, 2011 at 11:01 AM, Tejun Heo <htejun@gmail.com> wrote:
> From: Tejun Heo <tj@kernel.org>
>
> threadgroup_lock() protected only protected against new addition to
> the threadgroup, which was inherently somewhat incomplete and
> problematic for its only user cgroup.  On-going migration could race
> against exec and exit leading to interesting problems - the symmetry
> between various attach methods, task exiting during method execution,
> ->exit() racing against attach methods, migrating task switching basic
> properties during exec and so on.
>
> This patch extends threadgroup_lock() such that it protects against
> all three threadgroup altering operations - fork, exit and exec.  For
> exit, threadgroup_change_begin/end() calls are added to exit path.
> For exec, threadgroup_[un]lock() are updated to also grab and release
> cred_guard_mutex.

Can you add a comment (either in the commit or in the code) about why
the cred_guard_mutex change is necessary? Is it simply that exec takes
cred_guard_mutex and hence this excludes exec, or is there something
more subtle?

Paul
