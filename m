Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab1CHXzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 18:55:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35286 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756388Ab1CHXzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 18:55:44 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=FKmPEgYRmMMA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=iHhLuQ_TldCstX5Lt1IA:9 a=2oLZ_y0QaKKSKRrHzCwA:7 a=CwDe89U_CfD2f_tINUGsx-gVtjsA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 07/15] ftrace: fix event alignment: kvm:kvm_hv_hypercall
From: Steven Rostedt <rostedt@goodmis.org>
To: Avi Kivity <avi@redhat.com>
Cc: David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        mrubin@google.com, kvm-devel <kvm@vger.kernel.org>
In-Reply-To: <4CFF4D4C.2070002@redhat.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
	 <1291421609-14665-8-git-send-email-dhsharp@google.com>
	 <4CF9F7AB.8050802@redhat.com>
	 <AANLkTi=H9eSAOKmN8KdKDKiFZdD7DjQC=wa+fqrDpe2q@mail.gmail.com>
	 <4CFDFCEF.3080708@redhat.com>
	 <AANLkTinK7Zqh=GfFLeyJLxA4u2ozyVj-Ja435iBJPV13@mail.gmail.com>
	 <4CFF4D4C.2070002@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 08 Mar 2011 18:55:41 -0500
Message-ID: <1299628541.20306.99.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi,

This patch set got lost in the shuffle, and I'm not looking to include
it.

On Wed, 2010-12-08 at 11:18 +0200, Avi Kivity wrote:
> On 12/07/2010 11:16 PM, David Sharp wrote:
> > >
> > >  I don't understand this.  Can you elaborate?  What does "32-bit addressable"
> > >  mean?
> >
> > The ring buffer gives you space that is a multiple of 4 bytes in
> > length, and 32-bit aligned. Therefore it is useless to attempt to
> > align the structure beyond 32-bit boundaries, eg, a 64-bit boundary,
> > because it is unpredictable if the memory the structure will be
> > written to is at a 64-bit boundary (addr % 8 could be 0 or 4).
> >
> > >  And "predicated on packing the event structures"?  Is the structure
> > >  __attribute__((packed)), or is it not?
> >
> > It is not packed in Linus' tree, but one of the patches before this
> > patch in this patch series adds __attribute__((packed)). This patch
> > assumes that the event packing patch has been applied. This patch
> > should not be applied if the packing patch is not (hence,
> > "predicated").
> 
> Thanks for the explanations, it makes sense now.
> 

Does this mean I can add your "Acked-by"?

-- Steve


