Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815Ab0G1RUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 13:20:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:51963 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595Ab0G1RUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 13:20:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,275,1278313200"; 
   d="scan'208";a="590572530"
Message-ID: <4C5066CB.7010009@linux.intel.com>
Date: Wed, 28 Jul 2010 19:20:11 +0200
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
References: <1280335185-23265-1-git-send-email-segooon@gmail.com> <4C5063D4.4070108@linux.intel.com> <20100728171327.GA24149@albatros>
In-Reply-To: <20100728171327.GA24149@albatros>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I'm agree with you that if allocation fails at boot time, we are dead :)
> But this coding style breaking rules that result from some functions
> _must_ be checked for errors. Maybe we should add BUG_ON() here or
> indicate someway that we have no ideas how to handle error?

What rules exactly? I don't think any of those functions are declared 
with __must_check

Coding style should never get in the way of what is right.

The classic way to explicitely discard a return value is a cast to void, 
but that is generally considered
ugly in the Linux kernel.

One could possibly add a comment about this at least.

-Andi

