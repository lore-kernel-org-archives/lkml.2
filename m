Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab1FTX7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 19:59:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756438Ab1FTX7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 19:59:50 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>, Frank Arnold <farnold@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, linux-kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@gmail.com>
Subject: KVM: Remaining body of TSC emulation work
Date: Mon, 20 Jun 2011 16:59:28 -0700
Message-Id: <1308614377-18627-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In-Reply-To: 

This is the remaining bulk of work I have related to TSC emulation.
In summary, I believe this fixes all known issues with TSC.  A few
rather subtle issues are cleaned up, S4 suspend is fixed, and the
API for adjust_tsc_offset is expanded to take arguments in either
guest cycles or optionally host cycles.  The final patch adds
software TSC emulation, with a configurable default setting.

Note that TSC trapping will only be used when other methods fail
due to unstable TSC or lack of scaling hardware.  With the improved
offset matching, I was even able to get SMP guests to boot with a
TSC clock; cycle testing showed a maximum backwards leap of around
0.25 ms, which is actually fairly good.  With the last patch applied,
software TSC emulation kicks in and the backwards TSC count even on
my broken hardware dropped to zero.

Some of this code (the S4 suspend compensation) has already been
ported into RHEL to fix various bugs - however upstream had diverged
a bit from the original course I planned; I had to add a few things
that had been optimized out of upstream back in (last_host_tsc).

In the course of doing this, I think the new code looks much
cleaner, with well documented and easy to understand variables.
Yes, there are a lot of tracking variables to maintain this whole
infrastructure - and yes, some of them appear to be redundant of
easily computable from others - but in actuality, the information
they provide is easy to understand, and the resulting code is much
easier to verify than a complex system where some quantities may
be undefined or computed on the fly and thus causing subtle races.

Zach

