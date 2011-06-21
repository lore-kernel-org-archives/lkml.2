Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab1FURj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 13:39:28 -0400
Received: from smtp-out.google.com ([216.239.44.51]:31946 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756940Ab1FURj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 13:39:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=ROeK+GBnvBI5J8WC67FZZj3c+9qNrwZW20SSNdWZbP+uybC7KQW4pOHSviwyM3HZqm
         9thGdcdG2V3gRh0lRzAg==
MIME-Version: 1.0
In-Reply-To: <1308527474-20704-2-git-send-email-fweisbec@gmail.com>
References: <1308527474-20704-1-git-send-email-fweisbec@gmail.com> <1308527474-20704-2-git-send-email-fweisbec@gmail.com>
From: Paul Menage <menage@google.com>
Date: Tue, 21 Jun 2011 10:39:04 -0700
Message-ID: <BANLkTikVLnMqtaTqjw94qughBvWPcu4yog@mail.gmail.com>
Subject: Re: [RFC PATCH 1/4] cgroups: Allow a cgroup subsys to reject a fork
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 19, 2011 at 4:51 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> Make the cgroup subsystem fork callback return a value
> so that subsystems are able to accept or reject a fork
> completion with a custom error value.

This is unnecessary complexity in the cgroup subsystem (and seems to
miss cleanup for subsystems that have previously had their fork()
method return success).

If you want a subsystem to be able to reject a fork, I think it's
better to have that subsystem be called explicitly from do_fork(), and
keep that logic out of cgroups.

Paul
