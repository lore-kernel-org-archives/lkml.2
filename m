Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751064Ab1K3FBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 00:01:42 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55341 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab1K3FBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 00:01:41 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 30 Nov 2011 14:00:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [rfc 2/3] fs, proc: Introduce the Children: line in
 /proc/<pid>/status
Message-Id: <20111130140009.1ccd5af0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111129191638.835932727@openvz.org>
References: <20111129191252.769160532@openvz.org>
	<20111129191638.835932727@openvz.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Nov 2011 23:12:54 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> From: Pavel Emelyanov <xemul@parallels.com>
> 
> There is no easy way to make a reverse parent->children chain
> from the task status, in turn children->parent provided with "PPid"
> field.
> 
> So instead of walking over all pids in system to figure out what
> children the task have -- we add explicit "Children" member to
> /proc/<pid>/status since kernel already knows this kind of information
> but it was not yet exported.
> 
> Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>

I may be too pessimistic but what amount of overhead will this add to
ps -elf/ top ? Assuming an environment 'ps -elf' is called once per a sec,
if there are 2000 processes, task_list lock is taken 2000 times by this patch.

Isn't it better to add /proc/<pid>/children file or dir (as task)?

Thanks,
-Kame

