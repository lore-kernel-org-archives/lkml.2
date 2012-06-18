Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab2FRIkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 04:40:53 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47668 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab2FRIku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 04:40:50 -0400
Message-ID: <4FDEE98D.7010802@linaro.org>
Date: Mon, 18 Jun 2012 10:40:45 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Amit Kucheria <amit.kucheria@linaro.org>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Colin Cross <ccross@android.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Rob Lee <rob.lee@linaro.org>, rjw@sisk.pl,
        Kevin Hilman <khilman@ti.com>, linux-next@vger.kernel.org
Subject: cpuidle future and improvements
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear all,

A few weeks ago, Peter De Schrijver proposed a patch [1] to allow per
cpu latencies. We had a discussion about this patchset because it
reverse the modifications Deepthi did some months ago [2] and we may
want to provide a different implementation.

The Linaro Connect [3] event bring us the opportunity to meet people
involved in the power management and the cpuidle area for different SoC.

With the Tegra3 and big.LITTLE architecture, making per cpu latencies
for cpuidle is vital.

Also, the SoC vendors would like to have the ability to tune their cpu
latencies through the device tree.

We agreed in the following steps:

1. factor out / cleanup the cpuidle code as much as possible
2. better sharing of code amongst SoC idle drivers by moving common bits
to core code
3. make the cpuidle_state structure contain only data
4. add a API to register latencies per cpu

These four steps impacts all the architecture. I began the factor out
code / cleanup [4] and that has been accepted upstream and I proposed
some modifications [5] but I had a very few answers.

The patch review are very slow and done at the last minute at the merge
window and that makes code upstreaming very difficult. It is not a
reproach, it is just how it is and I would like to propose a solution
for that.

I propose to host a cpuidle-next tree where all these modifications will
be and where people can send patches against, preventing last minutes
conflicts and perhaps Lenb will agree to pull from this tree. In the
meantime, the tree will be part of the linux-next, the patches will be
more widely tested and could be fixed earlier.

Thanks
-- Daniel

[1] http://lwn.net/Articles/491257/
[2] http://lwn.net/Articles/464808/
[3] http://summit.linaro.org/
[4]
http://www.mail-archive.com/linux-omap@vger.kernel.org/msg67033.html,
http://www.spinics.net/lists/linux-pm/msg27330.html,
http://comments.gmane.org/gmane.linux.ports.arm.omap/76311,
http://www.digipedia.pl/usenet/thread/18885/11795/

[5] https://lkml.org/lkml/2012/6/8/375

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


