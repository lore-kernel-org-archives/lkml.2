Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519Ab2EIOY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:24:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:38105 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874Ab2EIOYZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:24:25 -0400
Message-ID: <1336573457.2527.50.camel@twins>
Subject: Re: [RFC][PATCH] printk: Add %pb to print bitmaps
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Igor Mammedov <imammedo@redhat.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, pjt@google.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 09 May 2012 16:24:17 +0200
In-Reply-To: <20120509141528.GA3623@gmail.com>
References: <4FAA452A.1070909@gmail.com> <4FAA588B.5010404@redhat.com>
	 <1336564330.2527.23.camel@twins> <4FAA5BFB.40309@redhat.com>
	 <1336566096.2527.30.camel@twins> <1336566644.2527.33.camel@twins>
	 <1336570043.2527.38.camel@twins> <20120509133607.GA26124@gmail.com>
	 <1336571049.2527.43.camel@twins> <1336571947.2527.47.camel@twins>
	 <20120509141528.GA3623@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 16:15 +0200, Ingo Molnar wrote:
> So, if someone specifies an incomplete "%pb" format - fmt[1] 
> will be 0 and we take precision as the length - presumably also 
> 0. 

yes, printf_spec is initialized to 0s.

> We stick that 0 into:
> 
> > +                     len = bitmap_scnlistprintf(buf, end - buf, ptr, bits);
> 
> Will that work? 

Yes, bitmap_scnlistprintf() will only set buf[0] = 0 (which will be
overwritten by a possible next printf token) and return 0 length not
advancing the ptr.


