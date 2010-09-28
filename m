Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab0I1Nw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 09:52:59 -0400
Received: from vs244178.vserver.de ([62.75.244.178]:49984 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab0I1Nw6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 09:52:58 -0400
X-Greylist: delayed 1973 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Sep 2010 09:52:58 EDT
Date: Tue, 28 Sep 2010 15:19:28 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <02122083.20100928151928@eikelenboom.it>
To: mingo@redhat.com, Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: linux-kernel@vger.kernel.org,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        <x86@kernel.org>
Subject: Re: [PATCH 12/12] xen/mtrr: Add mtrr_if support for Xen mtrr
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>* stefano.stabellini@xxxxxxxxxxxxx <stefano.stabellini@xxxxxxxxxxxxx> wrote:
>
>> From: Stephen Tweedie <sct@xxxxxxxxxx>
>> 
>> Add a Xen mtrr type, and reorganise mtrr initialisation slightly to
>> allow the mtrr driver to set up num_var_ranges (Xen needs to do this by
>> querying the hypervisor itself.)
>> 
>> [ Impact: add basic MTRR support ]
>> 
>> Signed-off-by: Stephen Tweedie <sct@xxxxxxxxxx>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@xxxxxxxxxx>
>> Signed-off-by: Stefano Stabellini <stefano.stabellini@xxxxxxxxxxxxx>
>> ---
>> arch/x86/kernel/cpu/mtrr/Makefile | 2 +-
>> arch/x86/kernel/cpu/mtrr/main.c | 3 +
>> arch/x86/kernel/cpu/mtrr/mtrr.h | 7 ++
>> arch/x86/kernel/cpu/mtrr/xen.c | 110 +++++++++++++++++++++++++++++++++++++
> 4 files changed, 121 insertions(+), 1 deletions(-)
> create mode 100644 arch/x86/kernel/cpu/mtrr/xen.c
>
>Still NAK, for the very same reasons as we NAK-ed it the previous time: 
>/proc/mtrr is a problematic and complicated legacy interface that should 
>die. Any modern X server will do the right thing via PAT.
>
>Also, please get the Ack of at least one x86 maintainer for x86 patches.
>
>Thanks,
>
>Ingo
>--
>

I can't find the MTRR API to be officially deprecated with any schedule for removal (at least i couldn't find it in feature-removal-schedule.txt).
KVM has had patches for MTRR as well, if it's so deprecated .. why has it ? .. legacy support for a not officially deprecated API perhaps ? To support CPU's that support MTRR but not PAT ?

If you think the MTRR interface should die, and should die fast, why hasn't it been added to feature-removal-schedule.txt for a complete removal in a not so distant future, since this is the only way to force all users to switch to PAT.

Perhaps it would be fair to ask for a working PAT implementation besides MTRR, but since it is not officially deprecated completely objecting a MTRR one just for Xen seems a bit unfair to me.

--
Sander

