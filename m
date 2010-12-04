Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab0LDTvg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 14:51:36 -0500
Received: from fanny.its.uu.se ([130.238.4.241]:59776 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755543Ab0LDTvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 14:51:35 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19706.39875.954626.75344@pilspetsen.it.uu.se>
Date: Sat, 4 Dec 2010 20:51:31 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: [Bug #23902] [BUG] 2.6.37-rc3 massive interactivity regression on ARM
In-Reply-To: <19706.13300.115878.641839@pilspetsen.it.uu.se>
References: <1OMp3vU_qjP.A.JXG.uxC-MB@chimera>
	<gUkHV_Vc3aE.A.RjG.9xC-MB@chimera>
	<19706.13300.115878.641839@pilspetsen.it.uu.se>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson writes:
 > Rafael J. Wysocki wrote:
 > > This message has been generated automatically as a part of a summary report
 > > of recent regressions.
 > > 
 > > The following bug entry is on the current list of known regressions
 > > from 2.6.36.  Please verify if it still should be listed and let the tracking team
 > > know (either way).
 > > 
 > > 
 > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=23902
 > > Subject		: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
 > > Submitter	: Mikael Pettersson <mikpe@it.uu.se>
 > > Date		: 2010-11-27 15:16 (6 days old)
 > > Message-ID	: <19697.8378.717761.236202@pilspetsen.it.uu.se>
 > > References	: http://marc.info/?l=linux-kernel&m=129087098911837&w=2
 > 
 > The bug is still present in 2.6.37-rc4.  I'm currently trying to bisect it.

git bisect identified

[305e6835e05513406fa12820e40e4a8ecb63743c] sched: Do not account irq time to current task

as the cause of this regression.  Reverting it from 2.6.37-rc4 (requires some
hackery due to subsequent changes in the same area) restores sane behaviour.

(Author of original patch cc:d.)

The original patch submission talks about irq-heavy scenarios.  My case is the
exact opposite: UP, !PREEMPT, NO_HZ, very low irq rate, essentially 100% CPU
bound in userspace but expected to schedule quickly when needed (e.g. running
top or ps or just hitting CR in one shell while another runs a compile job).

/Mikael
