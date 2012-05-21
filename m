Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab2EUMdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 08:33:01 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41244 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab2EUMdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 08:33:00 -0400
Date: Mon, 21 May 2012 14:32:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Shai Fultheim (Shai@ScaleMP.com)" <Shai@ScaleMP.com>
Cc: Vlad Zolotarov <vlad@ScaleMP.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ido Yariv <ido@wizery.com>
Subject: Re: [PATCH v3 0/2] Move x86_cpu_to_apicid to the __read_mostly
 section
Message-ID: <20120521123246.GB17065@gmail.com>
References: <1337527148.6093.14.camel@vlad>
 <20120521090638.GE31407@gmail.com>
 <9B14D1490DDECA4E974F6B9FC9EBAB317D295F4D11@VMBX108.ihostexchange.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9B14D1490DDECA4E974F6B9FC9EBAB317D295F4D11@VMBX108.ihostexchange.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Shai Fultheim (Shai@ScaleMP.com) <Shai@ScaleMP.com> wrote:

> Ingo,
> 
> The reason for this, as you pointed out, is the 'cache line' 
> size (4096 bytes).  We see significant false sharing is we do 
> not move this next to each other.

Which write-often variable caused the many cache flushes/fills? 
cpu_to_apicid is read mostly.

I.e. it might make more sense to identify the frequenty 
*modified* percpu variables, and move them to a separate 
section. I *think* most percpu variables are read mostly, so it 
would be more maintainable in the long run to figure out the 
frequently modified ones, not the frequently not modified ones.

Thanks,

	Ingo
