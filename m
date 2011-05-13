Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412Ab1EMPTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 11:19:37 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:32073
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757522Ab1EMPTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 11:19:35 -0400
X-SpamScore: -23
X-BigFish: VPS-23(zzbb2dK1433M9371O1432N98dKzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LL53WH-02-HMP-02
X-M-MSG: 
Date: Fri, 13 May 2011 17:19:23 +0200
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: Chuck Ebbert <cebbert@redhat.com>
CC: "Ostrovsky, Boris" <Boris.Ostrovsky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
Subject: Re: [PATCH] cpu, AMD: Fix another bug in the new errata checking code
Message-ID: <20110513151921.GA878@escobedo.osrc.amd.com>
References: <20110512195938.1728ab52@katamari>
 <20110513102154.GB9270@escobedo.osrc.amd.com>
 <4DCD2C3F.9070905@amd.com>
 <20110513105928.6216ddc8@katamari>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110513105928.6216ddc8@katamari>
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach b.
 Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach,
 Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr.
 43632
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 10:59:28AM -0400, Chuck Ebbert wrote:
> On Fri, 13 May 2011 09:03:59 -0400
> Boris Ostrovsky <boris.ostrovsky@amd.com> wrote:
> 
> > On 05/13/2011 06:21 AM, Hans Rosenfeld wrote:
> > > On Thu, May 12, 2011 at 07:59:38PM -0400, Chuck Ebbert wrote:
> > > The revision guide states that family 0x10 model 6 stepping 2 has E400.
> > > So I would expect that OSVW length is>= 2 and that OSVW status has bit
> > > 1 set, or that OSVW length is<  2. This indicates that the workaround is
> > > necessary, without any need to check the family-model-stepping ranges.
> > >
> > > It would also be correct if the BIOS disabled C1E and cleared the
> > > corresponding OSVW status bit. Anything else would probably be a very
> > > nasty BIOS bug.
> > >
> 
> > > Could you send me the contents of MSRs 0xc0010140, 0xc0010141 and
> > > 0xc0010055?
> > 
> > Knowing whether any C state above C1 is declared could be useful too.
> > 
> rdmsr 0xc0010140 gives 2

This means that E400 is known ...

> rdmsr 0xc0010141 gives 0

... and no workaround is necessary ...

> rdmsr 0xc0010055 gives 0

... because C1E is not enabled.

> And ARAT is definitely set where it wasn't before these updates.

I don't see how that could possibly make a difference if C1E is not even
enabled. This is all very strange.


Hans


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

