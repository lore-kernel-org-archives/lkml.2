Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab2JPS03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 14:26:29 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:54737 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755628Ab2JPS02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 14:26:28 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VPS-6(zz98dI936eI103dK1432Izz1202h1d1ah1d2ahzz8275dhz2dh668h839h944hd25hd2bhf0ah107ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1155h)
X-WSS-ID: 0MC00JY-02-16K-02
X-M-MSG: 
Date: Tue, 16 Oct 2012 13:26:21 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Shuah Khan <shuah.khan@hp.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        <shuahkhan@gmail.com>, <andreas.herrmann3@amd.com>,
        <borislav.petkov@amd.com>
Subject: Re: [PATCH 1/1] x86, e820: Remove direct mapping of reserved space
 for HT hole around 1TB
Message-ID: <20121016182621.GA10857@jshin-Toonie>
References: <6ec48b96-afab-4c8b-ab74-2c640c2a161b@blur>
 <8630fe28-0c1c-4f3a-90e1-df2d1b6615a6@blur>
 <1350409738.2785.30.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1350409738.2785.30.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 11:48:58AM -0600, Shuah Khan wrote:
> On Tue, 2012-10-16 at 16:55 +0000, Shin, Jacob wrote:
> > (Sorry for the top post, on mobile phone..) 
> > 
> > You can follow the latest thread here:
> > https://lkml.org/lkml/2012/9/30/23
> > 
> > Yinghai's for-x86-mm branch should boot 1TB AMD with hoisting
> > enabled. 
> > 
> > Thanks! 
> 
> Jacob,
> 
> Thanks. This includes several patches and large change. Good for
> upstream, however won't go into stable trees. Any thoughts on a smaller
> subset of changes that are suitable for stable kernels to enable HT?

Right, we are (AMD) thinking about the same thing .. how to backport to
stable kernels of major enterprise OSes

The simplest and the least disruptive solution would be to not map memory
holes that occur above 4GB, it won't affect 32 bit kernels, and it won't
touch legacy (under 4GB) area (ISA, the PCI MMIO region ..):

https://lkml.org/lkml/2011/10/20/323

HPA, it would be great if we can first get this patch upstream, and also
into the stable trees .. and after that, we can work on getting Yinghai's
mm refactoring in ..

Thoughts?

Thanks!

-Jacob

