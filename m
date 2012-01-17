Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab2AQViR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 16:38:17 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39692 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab2AQViQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 16:38:16 -0500
Message-ID: <4F15EA53.8030405@gmail.com>
Date: Tue, 17 Jan 2012 16:38:27 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [RFC] fs, proc: Introduce /proc/<pid>/task/<tid>/children entry
 v6
References: <20120116153231.GF2998@moon>
In-Reply-To: <20120116153231.GF2998@moon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(1/16/12 10:32 AM), Cyrill Gorcunov wrote:
> When we do checkpoint of a task we need to know the list of children
> the task, has but there is no easy and fast way to generate reverse
> parent->children chain from arbitrary<pid>  (while a parent pid is
> provided in "PPid" field of /proc/<pid>/status).
>
> So instead of walking over all pids in the system (creating one big process
> tree in memory, just to figure out which children a task has) -- we add
> explicit /proc/<pid>/task/<tid>/children entry, because the kernel already has
> this kind of information but it is not yet exported.

I doubt this is good idea. It move some complexity to userland, but not reduce.
Again, if we add this interface, it should help pstree like process traversal
tools. Bare task hierarchy shouldn't be exposed userland. I believe users need
sub process, not sub threads.



