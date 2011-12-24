Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab1LXMyf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 07:54:35 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46549 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752916Ab1LXMyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 07:54:33 -0500
Date: Sat, 24 Dec 2011 12:54:16 +0000
From: Will Deacon <will.deacon@arm.com>
To: a.p.zijlstra@chello.nl
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: perf event group siblings not counting in mainline
Message-ID: <20111224125415.GA14559@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

If I try using perf with event groups on a mainline kernel, only the group
leader counts:


linaro@mashed-potato:~$ perf stat --no-scale -g -e task-clock -e cpu-clock -e cs -- ls
hwb  linux

 Performance counter stats for 'ls':

         17.545541 task-clock                #    0.634 CPUs utilized
          0.000000 cpu-clock
                 0 cs                        #    0.000 M/sec

       0.027684984 seconds time elapsed


This is fixed by b79387ef ("perf: Fix enable_on_exec for sibling events")
in -next (20111222) but I can't see this queued anywhere for 3.2 (I thought
I might see it in -rc7).

Is this going in for the final cut, or will groups just be borked until 3.3?

Cheers,

Will
