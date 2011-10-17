Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab1JQRwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 13:52:08 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:57565 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab1JQRwH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 13:52:07 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Don Zickus <dzickus@redhat.com>, "Luck, Tony" <tony.luck@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "hughd@chromium.org" <hughd@chromium.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Mon, 17 Oct 2011 13:34:20 -0400
Subject: RE: [RFC][PATCH -next] make pstore/kmsg_dump run after stopping
 other cpus in panic path
Thread-Topic: [RFC][PATCH -next] make pstore/kmsg_dump run after stopping
 other cpus in panic path
Thread-Index: AcyM8W5zjVDyG6T+Smq3Ji0gFMX0JAAAMa9g
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C5747E25E@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C5747DC7B@USINDEVS01.corp.hds.com>
 <20111017160904.GG5795@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301EE911C66@orsmsx505.amr.corp.intel.com>
 <20111017172229.GH5795@redhat.com>
In-Reply-To: <20111017172229.GH5795@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1110170202
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I agree with Tony's concern.
But as Don told,  the best way to go proceed is fixing backend drivers step by step.

Seiji


>-----Original Message-----
>From: Don Zickus [mailto:dzickus@redhat.com]
>Sent: Monday, October 17, 2011 1:22 PM
>To: Luck, Tony
>Cc: Seiji Aguchi; linux-kernel@vger.kernel.org; Matthew Garrett; Vivek Goyal; Chen, Gong; Andrew Morton; Brown, Len; Huang,
>Ying; ak@linux.intel.com; hughd@chromium.org; mingo@elte.hu; jmorris@namei.org; a.p.zijlstra@chello.nl;
>namhyung@gmail.com; dle-develop@lists.sourceforge.net; Satoru Moriya
>Subject: Re: [RFC][PATCH -next] make pstore/kmsg_dump run after stopping other cpus in panic path
>
>On Mon, Oct 17, 2011 at 09:56:50AM -0700, Luck, Tony wrote:
>> > All this lock busting probably isn't pretty and causes one to reflect what
>> > is going on here.  But as long as we are going to keep the kmsg_dump
>> > design, changes like this seem necessary to make sure the locking stays
>> > sane(r) for now.
>>
>> So should we let the back-end know that locks have been busted?  I worry
>> that we'll get through the pstore layer by blasting away at any locks that
>> get in our way - but then the backend (which may well have been written on
>> the assumption that pstore serialized calls to it) will not do anything
>> useful (and may cause its own hang).
>
>I was kinda alluding to something like that, when I said we probably need
>follow on patches to clean up the backend.  But maybe it would be smarter
>to set a flag in pstore to let the backend know we busted the locks
>instead of letting them do panic checks themselves.  I agree with your
>concerns.
>
>I really can't think of a good overall solution other than slowly
>step-by-step untangle things by making subtle changes, this round being
>the serialization of kmsg_dump().
>
>My brain is to small to figure this out.  I keep thinking about making an
>ascii art diagram to see all the various paths and their contexts, but
>then I keep finding more interesting things to do. :-)
>
>Perhaps we should do that and make some rules about what the back-end can
>and can not do when plugging into kmsg_dump.
>
>Cheers,
>Don

