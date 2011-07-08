Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab1GHKcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 06:32:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56414 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab1GHKct convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 06:32:49 -0400
Subject: Re: [patch 00/17] CFS Bandwidth Control v7.1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@openvz.org>, Hu Tao <hutao@cn.fujitsu.com>
In-Reply-To: <CAPM31RKH8m1CpVWmRVLi8bMNSgdQU+Qzc2sTaWbx4r1b2fHF7w@mail.gmail.com>
References: <20110707053036.173186930@google.com>
	 <20110707112302.GB8227@elte.hu> <1310049528.3282.583.camel@twins>
	 <CAPM31RKH8m1CpVWmRVLi8bMNSgdQU+Qzc2sTaWbx4r1b2fHF7w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 08 Jul 2011 12:32:27 +0200
Message-ID: <1310121147.3282.706.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-08 at 00:39 -0700, Paul Turner wrote:
> 
> >  Going beyond that
> > would be using static_branch() to track if there is any bandwidth
> > tracking required at all.
> >
> 
> I spent some time examining this option as well.  Our toolchain
> apparently is stuck on gcc-4.4 which left me scratching my head at the
> supposed jump label assembly being omitted until I realized
> CC_HAS_ASM_GOTO was missing.  I will roll this up also and benchmark
> tomorrow. 

Ah, does it actually make things worse if it uses the static_branch
fallbacks? If so we should probably use some HAVE_JUMP_LABEL foo.
