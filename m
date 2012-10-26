Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966630Ab2JZVyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 17:54:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:36311 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964839Ab2JZVyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 17:54:33 -0400
Date: Fri, 26 Oct 2012 23:54:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter LaDow <petela@gocougs.wsu.edu>
cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org, netfilter@vger.kernel.org
Subject: Re: Process Hang in __read_seqcount_begin
In-Reply-To: <CAN8Q1Ecx-pDR=NBQm4O=VaynQsxBU1wku9e_kcKkWB=xU0OtMA@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1210262351330.2756@ionos>
References: <CAN8Q1EdobyFuAvtajGRSqNsCG+XoPA+FkwN=2j_H126mmfEjTQ@mail.gmail.com> <1350925299.8609.978.camel@edumazet-glaptop> <CAN8Q1EeqmHMHD-VUgr7Wzv0Z_DAD1SrEniftg==L14d+hGwu+Q@mail.gmail.com> <CAN8Q1EcTRsHjCJD90q0bKRJFMvi7Vn8YRsyQTAHNtTFVuuNdWQ@mail.gmail.com>
 <CAN8Q1EeB2kC6A_YP9zdtp_qYHMG5FF7-Usjx7Rz5pv--bjhqkQ@mail.gmail.com> <1351053164.6537.95.camel@edumazet-glaptop> <CAN8Q1Ef9sCAG8-KNWXEeuRUcmFNcg93mMG=HRQw6i3UuGtJCVg@mail.gmail.com> <1351270087.30380.9.camel@edumazet-glaptop>
 <CAN8Q1Ed1J-jmO9LppcA=rFXPvxFkk-J9mMb2-NhDYyAQKO2jvQ@mail.gmail.com> <1351285552.30380.20.camel@edumazet-glaptop> <CAN8Q1Ecx-pDR=NBQm4O=VaynQsxBU1wku9e_kcKkWB=xU0OtMA@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2012, Peter LaDow wrote:
> On Fri, Oct 26, 2012 at 2:05 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> If this were safe, we wouldn't be seeing this lockup and your patch
> wouldn't be needed.  So it seems that your patch doesn't really
> address the issue that we are not "sure a thread cannot be interrupted
> by a softirq, and cannot migrate to another cpu".  Well, we know it
> cannot migrate to another CPU, because there isn't another CPU.  So
> apparently, it can be interrupted by a softirq.  So local_bh_disable
> isn't doing anything useful in the RT patches with regard to this.

RT changes the semantics slightly. And yes it's not prepared for stuff
which is relying on some of the magic mainline implicit semantics.

Let me have a look at the whole scenario, once I'm more awake.

Thanks,

	tglx
