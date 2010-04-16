Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab0DPOxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 10:53:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45456 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702Ab0DPOxK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 10:53:10 -0400
Subject: Re: [PATCH v2] [watchdog] combine nmi_watchdog and softlockup
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Don Zickus <dzickus@redhat.com>,
       mingo@elte.hu, aris@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20100416144616.GC5162@nowhere>
References: <1271366710-17468-1-git-send-email-dzickus@redhat.com>
	 <20100416014712.GC15570@nowhere> <20100416143232.GA5540@lenovo>
	 <20100416144616.GC5162@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 16 Apr 2010 16:53:11 +0200
Message-ID: <1271429591.4807.2385.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-16 at 16:46 +0200, Frederic Weisbecker wrote:
> > > May be have an arch spin lock there to update your cpu mask safely.
> > > 
> > 
> > Hmm, this is NMI handler path so from what we protect this per-cpu data?
> > Do I miss something? /me confused
> 
> 
> The cpu mask is not per cpu here, this is a shared bitmap, so you
> can race against other cpus NMIs.
> 
> That said, as I suggested, having a per cpu var that we set when we
> warned would be much better than a spinlock here. 

Every time you think NMI and spinlock think FAIL.
