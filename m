Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab0JRIZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 04:25:19 -0400
Received: from canuck.infradead.org ([134.117.69.58]:45298 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab0JRIZR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 04:25:17 -0400
Subject: Re: [tip:perf/core] x86, NMI: Rewrite NMI handler
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Don Zickus <dzickus@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
In-Reply-To: <1287371214.31526.23.camel@yhuang-dev>
References: <1287195738-3136-4-git-send-email-dzickus@redhat.com>
	 <tip-e21f3e4957f4a55f546873605a5caa59556bb144@git.kernel.org>
	 <1287250157.1998.124.camel@laptop>  <20101017004641.GB4140@redhat.com>
	 <1287312163.1998.158.camel@laptop>  <1287371214.31526.23.camel@yhuang-dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 18 Oct 2010 10:24:47 +0200
Message-ID: <1287390287.29097.1539.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 11:06 +0800, Huang Ying wrote:
> You can kill DIE_NMI_IPI. But you will add at least NMI_PRIORITY_LOCAL
> (like DIE_NMI_IPI), NMI_PRIORITY_GLOBAL (like original DIE_NMI). So
> thing is similar, just moved from one place to another place.

The nice thing is that notifier chains aren't limited to 2 priorities,
in fact there's a good argument to use a wider range.

Also, like previously mentioned, it gets rid of the double iteration.

