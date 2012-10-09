Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab2JIVCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 17:02:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508Ab2JIVCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 17:02:17 -0400
Date: Tue, 9 Oct 2012 14:02:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: shuah.khan@hp.com
Cc: konrad.wilk@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rob@landley.net, stern@rowland.harvard.edu,
        joerg.roedel@amd.com, bhelgaas@google.com,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        devel@linuxdriverproject.org, x86@kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH v4] dma-debug: New interfaces to debug dma mapping
 errors
Message-Id: <20121009140215.5c0a65c9.akpm@linux-foundation.org>
In-Reply-To: <1349716040.2674.19.camel@lorien2>
References: <1347843171.4370.13.camel@lorien2>
	<1348621517.3091.6.camel@lorien2>
	<1349276159.3192.4.camel@lorien2>
	<1349400193.2547.29.camel@lorien2>
	<20121005155108.d8d88fd2.akpm@linux-foundation.org>
	<1349716040.2674.19.camel@lorien2>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Oct 2012 11:07:20 -0600
Shuah Khan <shuah.khan@hp.com> wrote:

> > 
> > Still seems overly complicated to me, but whatev.
> > 
> > I think the way to handle this is pretty simple: set a flag in the dma
> > entry when someone runs dma_mapping_error() and, if that flag wasn't
> > set at unmap time, emit a loud warning.
> > 
> > From my reading of the code, this patch indeed does that, along with a
> > bunch of other (unnecessary?) stuff.  But boy, the changelog conceals
> > this information well!
> 
> Are you referring to the system wide error counters when you say
> unnecessary stuff. The reason I added those was to catch errors when
> drivers don't do unmap. Several drivers fail to do unmap. Checking flag
> from unmap debug interfaces, doesn't cover these cases. However, I think
> the value of system wide counters is limited in the sense that they
> don't really identify the driver that needs fixing. In that sense it can
> be deemed unnecessary. I dropped them in v5 patch, which I am sending
> out.

hm.  Could we keep a counter of the number of map/unmap calls within
the dma object and then emit a warning if that is non-zero at teardown
time?  That should identify the offending driver.

