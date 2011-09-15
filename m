Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934946Ab1IOVKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 17:10:43 -0400
Received: from smtp-out.google.com ([74.125.121.67]:56902 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934775Ab1IOVKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 17:10:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=A3d3PknF0v+9u4R3MQTzP+cuy2NzFc1oZntoiNrNHo/gRdhzJeSwCxvrjtBFSf8tl
	sDsOaL/I5YoDuxFwqmaww==
Date: Thu, 15 Sep 2011 14:09:41 -0700
From: Andrew Morton <akpm@google.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 11/12] cgroups: Allow subsystems to cancel a fork
Message-Id: <20110915140941.6b278dfb.akpm@google.com>
In-Reply-To: <1315267986-28937-12-git-send-email-fweisbec@gmail.com>
References: <1315267986-28937-1-git-send-email-fweisbec@gmail.com>
	<1315267986-28937-12-git-send-email-fweisbec@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  6 Sep 2011 02:13:05 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Let the subsystem's fork callback return an error value so
> that they can cancel a fork. This is going to be used by
> the task counter subsystem to implement the limit.

This breaks the build quite gruesomely with CONFIG_CGROUPS=n.  I looked
at doing a quick fix but that would just have piled ugly on ugly.

