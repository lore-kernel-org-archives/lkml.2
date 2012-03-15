Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032204Ab2COTgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 15:36:39 -0400
Received: from tango.0pointer.de ([85.214.72.216]:39321 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031784Ab2COTgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 15:36:36 -0400
Date: Thu, 15 Mar 2012 20:36:35 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] cgroup: deprecate remount option changes mount option
Message-ID: <20120315193635.GD32661@tango.0pointer.de>
References: <20120314215228.GI7349@google.com>
 <20120315165655.GD32137@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315165655.GD32137@google.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15.03.12 09:56, Tejun Heo (tj@kernel.org) wrote:

> This patch marks the following features for deprecation.
> 
> * Rebinding subsys by remount: Never reached useful state - only works
>   on empty hierarchies.
> 
> * release_agent update by remount: release_agent itself will be
>   replaced with conventional fsnotify notification.

Just wondering, what kind of event do you plan to emit if a cgroup runs
empty? To userspace, with fanotify, will this be FAN_MODIFY? I'd very
much prefer if we only get events really when a group runs empty, and
not each time a PID is added/removed from a cgroup, which FAN_NOTIFY
might suggest?

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
