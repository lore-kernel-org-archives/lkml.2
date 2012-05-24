Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab2EXJy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 05:54:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:11604 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082Ab2EXJyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 05:54:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="144124878"
Message-ID: <4FBE054E.3040307@linux.intel.com>
Date: Thu, 24 May 2012 17:54:22 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "Luck, Tony" <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] x86: auto poll/interrupt mode switch for CMC to stop
 CMC storm
References: <1337740341-26711-1-git-send-email-gong.chen@linux.intel.com> <alpine.LFD.2.02.1205230859190.3231@ionos> <3908561D78D1C84285E8C5FCA982C28F192F2DD6@ORSMSX104.amr.corp.intel.com> <alpine.LFD.2.02.1205232044150.3231@ionos> <3908561D78D1C84285E8C5FCA982C28F192F30C0@ORSMSX104.amr.corp.intel.com> <4FBD9BAA.7070902@linux.intel.com> <20120524060016.GB25344@aftab.osrc.amd.com>
In-Reply-To: <20120524060016.GB25344@aftab.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012/5/24 14:00, Borislav Petkov 写道:
> On Thu, May 24, 2012 at 10:23:38AM +0800, Chen Gong wrote:
>> Hi, Boris, when I write these codes I don't care if it is specific for
>> Intel or AMD.
> Well, but I do care so that when you leave and start doing something
> else, people after you can still read and maintain that code.
>
>> I just noticed it should be general for x86 platform and all related
>> codes are general too, which in mce.c, so I think it should be fine to
>> place the codes in mce.c.
> Are you kidding me? Only Intel has CMCI.
>
> Now, if some other vendor needs correctable errors interrupt rate
> throttling, they can carve it out, make it generic, and move it to mce.c.
>
> Otherwise, it belongs in mce_intel.c. For the same reason AMD error
> thresholding code belongs to mce_amd.c.
>
> Jeez.
>
Sorry, I'm really not familiar with AMD's CPU. But I still consider
these codes should be in
current place. Because the original poll timer logic is there, and my
patch is just the
extension for poll timer. Even if moving these codes to Intel specific
file, it should be
another patch to move whole logic including poll timer/CMCI handler to
Intel specific
file, do you agree?
