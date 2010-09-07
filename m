Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926Ab0IGQhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 12:37:00 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:45584 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757599Ab0IGQg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 12:36:57 -0400
X-SpamScore: -32
X-BigFish: VS-32(zzbb2dK1432N98dN9371Pzz1202hzz8275dh15d4Rz32i2a8h87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8DY31-01-32H-02
X-M-MSG: 
Date: Tue, 7 Sep 2010 18:35:30 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/27] Nested Paging Virtualization for KVM v3 (now with
 fixed Cc-List)
Message-ID: <20100907163529.GG2177@amd.com>
References: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
 <4C8534ED.7060302@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4C8534ED.7060302@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 02:37:33PM -0400, Avi Kivity wrote:
>   On 09/06/2010 06:55 PM, Joerg Roedel wrote:
> > (Now with correct Cc-list. I accidentially copied the wrong line from
> >   MAINTAINERS in the first post of this. Sorry for the double-post)
> >
> > Hi Avi, Marcelo,
> >
> > here is finally the third round of my NPT virtualization patches for KVM. It
> > took a while to get everything running (including KVM itself) on 32 bit again
> > to actually test it. But testing on 32 bit host and with a 32 bit hypervisor
> > was a very good idea. I found some serious bugs and shortcomings in my code
> > that are fixed now in v3.
> >
> 
> <snip>
> 
> > This patchset applies on todays avi/master + the three patches I sent end of
> > last week. These patches are necessary for some of the tests above to run.
> >
> > For the curious and impatient user I put everything in a branch on kernel.org.
> > If you want to test it you can pull the tree from
> >
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-kvm.git npt-virt-v3
> >
> > Please review and/or apply these patches if considered good enough. Otherwise I
> > appreciate your feedback.
> 
> Very impressive patchset.  It's broken out so finely that the careful 
> reader gets the feeling he understands every little detail, without 
> noticing you've introduced recursion into the kvm mmu.

Thanks :-)

> Please also post a unit test that checks that nested page faults for l1 
> ptes with bad NX, U, W, or reserved bits set are correctly intercepted 
> and reported.  W should work already if you tested nested vga, but the 
> rest are untested during normal operation and pose a security problem if 
> they are incorrect.

Okay, I'll write a test for all these cases.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

