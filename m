Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab2FRSPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 14:15:34 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:62966 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab2FRSPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 14:15:31 -0400
MIME-Version: 1.0
In-Reply-To: <4FDEE98D.7010802@linaro.org>
References: <4FDEE98D.7010802@linaro.org>
Date: Mon, 18 Jun 2012 11:15:30 -0700
X-Google-Sender-Auth: wI_0kCCBZtURMMMrkxuhUsOGIGs
Message-ID: <CAMbhsRQRFXcayyWjM1RirgFppVAK23z2+3EbYOCw-qmzuY9_2g@mail.gmail.com>
Subject: Re: cpuidle future and improvements
From: Colin Cross <ccross@android.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Rob Lee <rob.lee@linaro.org>, rjw@sisk.pl,
        Kevin Hilman <khilman@ti.com>, linux-next@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 1:40 AM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
> I propose to host a cpuidle-next tree where all these modifications will
> be and where people can send patches against, preventing last minutes
> conflicts and perhaps Lenb will agree to pull from this tree. In the
> meantime, the tree will be part of the linux-next, the patches will be
> more widely tested and could be fixed earlier.

My coupled cpuidle patches were acked and temporarily in Len's
next/Linus pull branch, but were later dropped when the first pull
request to Linus was rejected.  I asked Len to either put the coupled
cpuidle patches into his next branch, or let me host them so people
could base SoC branches off of them and let Len pull them later, but
got no response.  If you do start a cpuidle for-next branch, can you
pull my coupled-cpuidle branch:

The following changes since commit 76e10d158efb6d4516018846f60c2ab5501900bc:

  Linux 3.4 (2012-05-20 15:29:13 -0700)

are available in the git repository at:
  https://android.googlesource.com/kernel/common.git coupled-cpuidle

Colin Cross (4):
      cpuidle: refactor out cpuidle_enter_state
      cpuidle: fix error handling in __cpuidle_register_device
      cpuidle: add support for states that affect multiple cpus
      cpuidle: coupled: add parallel barrier function

 drivers/cpuidle/Kconfig   |    3 +
 drivers/cpuidle/Makefile  |    1 +
 drivers/cpuidle/coupled.c |  715 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/cpuidle/cpuidle.c |   68 ++++-
 drivers/cpuidle/cpuidle.h |   32 ++
 include/linux/cpuidle.h   |   11 +
 6 files changed, 813 insertions(+), 17 deletions(-)
 create mode 100644 drivers/cpuidle/coupled.c
