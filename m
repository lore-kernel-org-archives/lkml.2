Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab2E3Mou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 08:44:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:44965 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab2E3Mos convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 08:44:48 -0400
Message-ID: <1338381877.26856.272.camel@twins>
Subject: Re: [PATCH v3 5/6] Also record sleep start for a task group
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, devel@openvz.org, Tejun Heo <tj@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, handai.szj@gmail.com,
        Andrew.Phillips@lmax.com, Serge Hallyn <serge.hallyn@canonical.com>
Date: Wed, 30 May 2012 14:44:37 +0200
In-Reply-To: <4FC61188.8000908@parallels.com>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>
	 <1338371317-5980-6-git-send-email-glommer@parallels.com>
	 <CAPM31R+VXsffUOSOtMPG=g+G9OdzWMKQvx9usTFa3KBbrqPe6A@mail.gmail.com>
	 <4FC61188.8000908@parallels.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 16:24 +0400, Glauber Costa wrote:
> sleep_start is not for iowait. This is for idle. And I know no other way 
> to collect idle time per cgroup, other than the time during which it was 
> out of the runqueue.
> 
> Now what you say about the sleepers don't make that much sense for idle 
> because this information is per-cpu as well.
> 
> When the se is being dequeued, it means none of its children is running 
> on that runqueue. That's idle. 

But does that mean the cgroup is idle? Its impossible to re-construct
the machine state from this per-cpu data if your definition of
cgroup-idle is the time when _all_ cpus are idle.


