Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab1HPCFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:05:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:22497 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676Ab1HPCFM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:05:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,377,1309762800"; 
   d="scan'208";a="7590543"
From: "Ren, Yongjie" <yongjie.ren@intel.com>
To: Florian Mickler <florian@mickler.org>, Avi Kivity <avi@redhat.com>
CC: Pekka Enberg <penberg@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "stefanha@linux.vnet.ibm.com" <stefanha@linux.vnet.ibm.com>,
        KVM General <kvm@vger.kernel.org>
Date: Tue, 16 Aug 2011 10:04:26 +0800
Subject: RE: [Bug #39412] Win Vista and Win2K8 guests' network breaks down
Thread-Topic: [Bug #39412] Win Vista and Win2K8 guests' network breaks down
Thread-Index: AcxbiFx7dtnlYr8zQ8C8a+qojMmVfAALYY9A
Message-ID: <CE59C043D0EC3349B2BF41C0EC72229B12D22FAF9B@shsmsx501.ccr.corp.intel.com>
References: <xuTC4jRtHbB.A.l4H.gMCSOB@chimera>
	<bkwpSnItbJM.A.nx.VNCSOB@chimera>
	<CAOJsxLEToaQe3DrhUQx5FizMnzATxwG8XGCPwZpRFpuBQpq1ug@mail.gmail.com>
	<4E49215A.5080103@redhat.com>	<1313416232.32391.13.camel@jaguar>
	<4E4928A1.1050104@redhat.com>	<20110815163142.0182ce35@schatten.dmk.lab>
	<4E496E7C.30303@redhat.com> <20110815221705.768b56f8@schatten.dmk.lab>
In-Reply-To: <20110815221705.768b56f8@schatten.dmk.lab>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,
I'm the reporter for the bug. Sorry for being late cause I was busy with other stuff.
I only test upstream of Avi's kvm.git and qemu-kvm.git.
>From my test, my automatic test cases for Win Vista and Win2k8 failed at that time. And I also tried this manually, and met the same issue. So I'm sure this was a bug at that time.
Sorry, I don't think I have time to bisect which commit or patch introduced and fixed this issue very accurately.
I can provide some info.
>From git log of Avi's kvm.git tree:
------good commit---------- 
commit e62c2ef9d55731476d5783b06c93976c70b96afa
Merge: 2e0d8e2 ca56a95
Author: Avi Kivity <avi@redhat.com>
Date:   Thu Jun 30 11:45:57 2011 +0300

-------bad commit---------
commit e2dd78cba341fa7f4d2aa2a3f2a5ec48615155ad
Merge: 481ac8d 4dd1b49
Author: Marcelo Tosatti <mtosatti@redhat.com>
Date:   Thu Jul 7 09:29:58 2011 -0300

-----good commit--------(issue has been fixed)
commit e72ef590a3ef3047f6ed5bcb8808a9734f6c4b32
Author: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Date:   Fri Jul 22 12:46:53 2011 +0100


Best Regards,
     Yongjie Ren  (Jay)

> -----Original Message-----
> From: Florian Mickler [mailto:florian@mickler.org]
> Sent: Tuesday, August 16, 2011 4:17 AM
> To: Avi Kivity
> Cc: Pekka Enberg; Rafael J. Wysocki; Linux Kernel Mailing List; Kernel Testers
> List; Maciej Rutecki; Ren, Yongjie; stefanha@linux.vnet.ibm.com; KVM
> General
> Subject: Re: [Bug #39412] Win Vista and Win2K8 guests' network breaks
> down
> 
> On Mon, 15 Aug 2011 12:07:40 -0700
> Avi Kivity <avi@redhat.com> wrote:
> 
> > On 08/15/2011 07:31 AM, Florian Mickler wrote:
> > > On Mon, 15 Aug 2011 07:09:37 -0700
> > > Avi Kivity<avi@redhat.com>  wrote:
> > >
> > > >  On 08/15/2011 06:50 AM, Pekka Enberg wrote:
> > > >  >  Heh, sorry about that, that's the commit SHA mentioned in the
> above
> > > >  >  bugzilla report. :-)
> > > >  >
> > > >  >
> > > >
> > > >  Think of it as 'git bisect good' input, rather than output.
> > > >
> > >
> > > Can you post a comment to the bug when Linus pulled that tree?
> >
> > Most likely kvm.git got that commit from Linus - I don't think the fix
> > came from kvm.git.
> >
> 
> Hm ok. But the tree tested by the reporter is contained in kvm/master
> and kvm/next and not in Linus tree.
> 
> Anyhow, Rafael did ask the correct question on the bug to resolve
> this. :)
> 
> Regards,
> Flo

