Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab0G2JvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 05:51:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:36269 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab0G2JvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 05:51:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,279,1278313200"; 
   d="scan'208";a="642820275"
Message-ID: <4C514F04.80603@linux.intel.com>
Date: Thu, 29 Jul 2010 11:51:00 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Vasiliy Kulikov <segooon@gmail.com>
CC: kernel-janitors@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] x86: mce: fix error handling
References: <1280335185-23265-1-git-send-email-segooon@gmail.com> <4C5063D4.4070108@linux.intel.com> <20100728171327.GA24149@albatros> <4C5066CB.7010009@linux.intel.com> <20100729093511.GB7143@albatros>
In-Reply-To: <20100729093511.GB7143@albatros>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> IMO memmory allocation fails are dangerous in kernel mode. As it is
> probably not exploitable because of boot time, it can destroy some
> sensitive data like dirty disk caches those are going to be written on
> disk.

It's true for runtime, but not for normal boot time.

Anyways if it happens on boot time the only thing you can do is panic, 
but someone else
will likely panic anyways for you. Just ignoring it like your patch 
effectively does
(because nothing will ever look at the ENOMEMs for an initcall) is wrong 
though
In this case it's actually better to oops like the original code does.

BTW even with your patch likely later code will crash anyways because it 
doesn't
expect init code to fail.

-Andi

