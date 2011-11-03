Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345Ab1KCMmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 08:42:50 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59222 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933120Ab1KCMmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 08:42:49 -0400
X-Sasl-enc: r8ZsnZNpwj0s1vEJqo+TJwmCtX1/kK/4RZAFsrmb6+EO 1320324168
Date: Thu, 3 Nov 2011 10:42:43 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: HT (Hyper Threading) aware process scheduling doesn't work as
 it should
Message-ID: <20111103124243.GA17252@khazad-dum.debian.net>
References: <269467866.49093.1320004632156.JavaMail.mail@webmail17>
 <20111103081835.GA9330@elte.hu>
 <1758553229.334475.1320313445172.JavaMail.mail@webmail11>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1758553229.334475.1320313445172.JavaMail.mail@webmail11>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Nov 2011, Artem S. Tashkinov wrote:
> So, now the question is whether VCPUs quite an illogical enumeration is good for
> power users as I highly doubt that 0-4, 1-5, 2-6 and 3-7 order can be easily
> remembered and grasped. Besides neither top, not htop are HT aware so just by

Power users are directed to hwloc.  There's a reason I pointed you to it.
hwloc would have told you upfront your real memory/cache/core/thread
topology, either in text mode, through graphics, or as XML:

Here's hwloc's "lstopo" text output for my single-processor X5550:

Machine (6029MB) + Socket #0 + L3 #0 (8192KB)
  L2 #0 (256KB) + L1 #0 (32KB) + Core #0
    PU #0 (phys=0)
    PU #1 (phys=4)
  L2 #1 (256KB) + L1 #1 (32KB) + Core #1
    PU #2 (phys=1)
    PU #3 (phys=5)
  L2 #2 (256KB) + L1 #2 (32KB) + Core #2
    PU #4 (phys=2)
    PU #5 (phys=6)
  L2 #3 (256KB) + L1 #3 (32KB) + Core #3
    PU #6 (phys=3)
    PU #7 (phys=7)

http://www.open-mpi.org/projects/hwloc/

and examples/documentation:
http://www.open-mpi.org/projects/hwloc/doc/v1.3/

Most likely, your distro will have it packaged.

You should also try the turbostat tool I pointed you at, it lives in the
"tools/power/x86" folder inside the kernel source, and will help you track
processor core performance a lot better than top/htop (but not what is using
the cores):

(turbostat output):
core CPU   %c0   GHz  TSC   %c1    %c3    %c6   %pc3   %pc6 
           0.29 1.60 2.67   0.94  12.63  86.14   0.00   0.00
   0   0   0.31 1.60 2.67   1.62   3.21  94.87   0.00   0.00
   0   4   0.48 1.61 2.67   1.45   3.21  94.87   0.00   0.00
   1   1   0.18 1.60 2.67   0.91   2.17  96.75   0.00   0.00
   1   5   0.24 1.60 2.67   0.84   2.17  96.75   0.00   0.00
   2   2   0.03 1.60 2.67   0.07   0.16  99.74   0.00   0.00
   2   6   0.02 1.60 2.67   0.08   0.16  99.74   0.00   0.00
   3   3   1.00 1.60 2.67   0.83  44.97  53.20   0.00   0.00
   3   7   0.09 1.60 2.67   1.75  44.97  53.20   0.00   0.00

Which tells me my system spends most of its time sleeping. You will notice
it does tell you upfront that core 0 is CPUs 0 and 4.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
