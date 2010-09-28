Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab0I1Qcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 12:32:41 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:13354
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755007Ab0I1Qcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 12:32:39 -0400
X-Greylist: delayed 906 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Sep 2010 12:32:39 EDT
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bhz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9GT8V-01-AEK-02
X-M-MSG: 
Date: Tue, 28 Sep 2010 18:19:12 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Jan Beulich <JBeulich@novell.com>
CC: "Seidel, Conny" <Conny.Seidel@amd.com>,
        "borislav.petkov" <borislav.petkov@amd.com>,
        "mingo@elte.hu" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: current TIP/master doesn't build on SLES10
Message-ID: <20100928161912.GF5003@loge.amd.com>
References: <20100928163136.7a2355d0@marah.osrc.amd.com>
 <4CA22F1D020000780001961F@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4CA22F1D020000780001961F@vpn.id2.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 12:08:29PM -0400, Jan Beulich wrote:
> >>> On 28.09.10 at 16:31, Conny Seidel <conny.seidel@amd.com> wrote:
> > Hi
> > 
> > compiling TIP/master (44bc8c4f500fce7263803b4acd016fa03cf8a91a) on
> > SLES10 fails with the following build error:
> > 
> > arch/x86/kernel/entry_64.S: Assembler messages:
> > arch/x86/kernel/entry_64.S:1181: Error: too many positional arguments
> > arch/x86/kernel/entry_64.S:1181: Error: too many positional arguments
> > make[2]: *** [arch/x86/kernel/entry_64.o] Error 1
> > make[1]: *** [arch/x86/kernel] Error 2
> > make: *** [arch/x86] Error 2
> > 
> > I've bisected it to commit df5d1874ce1a1f0e0eceff4fa3a9d45620243a68.
> > 
> > Reverting it fixes the issue. 
> > 
> > I know that this is caused by binutils 2.16.91.0.5 which is distributed
> > with SLES10.
> 
> I'm generally doing almost all of my work on SLE10, and have not run
> into this issue. Are you sure you've got it fully updated?

BTW, the build error looks similar to the build problem fixed by

  commit e8a0e27662186f8856a0a6242e7a8386c9a64a53
  Author: Ingo Molnar <mingo@elte.hu>
  Date:   Fri Nov 21 15:11:32 2008 +0100

    x86: clean up after: move entry_64.S register saving out of the macros, fix



Andreas


