Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968Ab0LBUp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 15:45:59 -0500
Received: from mga03.intel.com ([143.182.124.21]:51090 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757789Ab0LBUp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 15:45:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,289,1288594800"; 
   d="scan'208";a="356280742"
Date: Thu, 2 Dec 2010 12:45:59 -0800
From: jacob pan <jacob.jun.pan@linux.intel.com>
To: Paul Menage <menage@google.com>
Cc: container cgroup <containers@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC PATCH 1/2] cgroup: add per cgroup timer_slack_ns
Message-ID: <20101202124559.0a7128de@jacob-laptop>
In-Reply-To: <AANLkTi=1uv-+Y5t85tyHKk91nJyAKNg5V4Fk2HTJ+ASS@mail.gmail.com>
References: <1291230012-9536-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1291230012-9536-2-git-send-email-jacob.jun.pan@linux.intel.com>
	<AANLkTi=1uv-+Y5t85tyHKk91nJyAKNg5V4Fk2HTJ+ASS@mail.gmail.com>
Organization: OTC
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Dec 2010 12:17:20 -0800
Paul Menage <menage@google.com> wrote:

> When multiple hierarchies are mounted a task will be in one cgroup on
> each hierarchy - which cgroup's timer_slack_ns value should be used
> for it?
> 
> This doesn't belong in the generic cgroups framework. It sounds like
> it's something that should be its own subsystem, or else part of
> something like the cpu subsystem.
good point. the current behavior is that the timer_slack_ns value will
be assigned by the last hierarchy it attaches to, which might not be
desirable.

I guess timer_slack_ns alone cannot qualify for a new subsystem, I will
try to fit it into cpuset.

Thanks for the review,

Jacob
