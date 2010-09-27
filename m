Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933Ab0I0Ih1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 04:37:27 -0400
Received: from isomail2.amdocs.com ([193.43.244.89]:42511 "EHLO
	isomail2.amdocs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab0I0Ih0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 04:37:26 -0400
From: James Dingwall <james.dingwall@amdocs.com>
To: Kyle McMartin <kmcmartin@redhat.com>, Greg KH <greg@kroah.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "james@dingwall.me.uk" <james@dingwall.me.uk>
Date: Mon, 27 Sep 2010 09:37:17 +0100
Subject: RE: [stable] PROBLEM: [BISECTED] 2.6.35.5 xen domU panics just
 after the boot [PATCH]
Thread-Topic: [stable] PROBLEM: [BISECTED] 2.6.35.5 xen domU panics just
 after the boot [PATCH]
Thread-Index: ActeDgLM4ZE1mLPvQ/+JJ5E39Z8hMwADeyPg
Message-ID: <3B7AEC3C7FCC864282DFAC9A56A7BA363D81475979@UKLNDMAIL1.corp.amdocs.com>
References: <3B7AEC3C7FCC864282DFAC9A56A7BA363D81475787@UKLNDMAIL1.corp.amdocs.com>
 <20100927024044.GQ13116@bombadil.infradead.org>
 <20100927061336.GA22721@kroah.com>
 <20100927063405.GM19458@ihatethathostname.lab.bos.redhat.com>
In-Reply-To: <20100927063405.GM19458@ihatethathostname.lab.bos.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
x-tm-as-product-ver: SMEX-8.0.0.4125-6.500.1024-17668.005
x-tm-as-result: No--72.612500-8.000000-31
x-tm-as-user-approved-sender: No
x-tm-as-user-blocked-sender: No
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Sep 26, 2010 at 11:13:36PM -0700, Greg KH wrote:
> > > Greg, a spelling mistake cropped into this patch during 2.6.35.5
> that
> > > James here points out. Adding you to CC since it seems to have
> missed
> > > stable 2.6.35.6...
> > >
> > > Was in xen-use-percpu-interrupts-for-ipis-and-virqs.patch.
> >
> > I don't understand, where did the error come from?  Was it in a patch
> I
> > applied, or did I mess up some patch?  Is the same problem upstream,
> and
> > if not, why not?
> 
> It's correct upstream, and wrong in the patches you added to
> stable-queue.git for .32 and .35, no idea how it got introduced. :/
> 
> >
> > And finally, can you send this in a format that I can apply it?
> >
> 
> I'm just the messenger... James, can you send a patch to Greg with your
> signed-off-by and such?
> 
> --Kyle
> 
> > thanks,
> >
> > greg k-h

Hi,

My first contribution so I hope I didn't miss any important steps in formatting the patch and that Outlook keeps it intact...  If it needs any fixing up let me know.

James

Correctly name the irq_chip structure to fix an immediate failure when booting as a xen pv_ops guest with a NULL pointer exception. The missing 'x' was introduced in commit [fb412a178502dc498430723b082a932f797e4763] applied to 2.6.3[25]-stable trees.  The commit to mainline was [aaca49642b92c8a57d3ca5029a5a94019c7af69f] which did not have the problem.

Signed-off-by: James Dingwall <james@dingwall.me.uk>
Reported-by: Pawe³ Zuzelski <pawelz@pld-linux.org>
Tested-by: Pawe³ Zuzelski <pawelz@pld-linux.org>

--- drivers/xen/events.c.orig	2010-09-27 09:10:09.245652829 +0100
+++ drivers/xen/events.c	2010-09-27 09:10:27.522304658 +0100
@@ -935,7 +935,7 @@ static struct irq_chip xen_dynamic_chip 
 	.retrigger	= retrigger_dynirq,
 };
 
-static struct irq_chip en_percpu_chip __read_mostly = {
+static struct irq_chip xen_percpu_chip __read_mostly = {
 	.name		= "xen-percpu",
 
 	.disable	= disable_dynirq,

This message and the information contained herein is proprietary and confidential and subject to the Amdocs policy statement,
you may review at http://www.amdocs.com/email_disclaimer.asp

