Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab2EYBwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 21:52:43 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44871 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab2EYBwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 21:52:42 -0400
Date: Thu, 24 May 2012 21:50:19 -0400 (EDT)
Message-Id: <20120524.215019.1013474044821595274.davem@davemloft.net>
To: fenghua.yu@intel.com
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, andi@firstfloor.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86/copy_user_generic: Optimize copy_user_generic with
 CPU erms feature
From: David Miller <davem@davemloft.net>
In-Reply-To: <1337908785-14015-1-git-send-email-fenghua.yu@intel.com>
References: <1337908785-14015-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 24 May 2012 18:50:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Fenghua Yu" <fenghua.yu@intel.com>
Date: Thu, 24 May 2012 18:19:45 -0700

> According to Intel 64 and IA-32 SDM and Optimization Reference
> Manual, beginning with Ivybridge, REG string operation using MOVSB
> and STOSB can provide both flexible and high-performance REG string
> operations in cases like memory copy.  Enhancement availability is
> indicated by CPUID.7.0.EBX[9] (Enhanced REP MOVSB/ STOSB).

How does the cpu do overlap detection?

If the cpu does overlap detection on sub-pagesize bits, performance
will unnecessarily suffer under such circumstances.
