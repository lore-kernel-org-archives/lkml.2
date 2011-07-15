Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965077Ab1GOI4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 04:56:45 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:59494 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964782Ab1GOI4o convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Fri, 15 Jul 2011 04:56:44 -0400
Message-Id: <4E201CE8020000780004D8F0@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 15 Jul 2011 09:56:40 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ian Campbell" <Ian.Campbell@citrix.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Olaf Hering" <olaf@aepfle.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Keir Fraser" <keir@xen.org>
Subject: Re: [Xen-devel] [PATCH] xen: update machine_to_phys_order on
	 resume
References: <20110701104148.GA32729@aepfle.de>
 <20110712164342.GA12867@aepfle.de> <20110712181118.GA18662@dumpdata.com>
 <1310548364.634.355.camel@zakaz.uk.xensource.com>
 <20110713132037.GC7618@dumpdata.com>
In-Reply-To: <20110713132037.GC7618@dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 13.07.11 at 15:20, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> On Wed, Jul 13, 2011 at 10:12:44AM +0100, Ian Campbell wrote:
>> On Tue, 2011-07-12 at 19:11 +0100, Konrad Rzeszutek Wilk wrote:
>> > On Tue, Jul 12, 2011 at 06:43:42PM +0200, Olaf Hering wrote:
>> > > 
>> > > Migration of pv guests fails, the guest crashes on the target host once 
> the
>> > > guest is unpaused after transit. It happens when the guest is started on a
>> > > small systen, then migrated from that small system to a large system.
>> > > If the guest is started on a large system, then migrated to a small system 
> and
>> > > back to the large system, the migration will be successful.
>> > > 
>> > > The issue is that mfn_to_pfn() makes use of machine_to_phys_order, which
>> > > is only configured once early in the boot process. After migration to a
>> > > large host the mfns will exceed the order from the small system and a
>> > > wrong code path is taken.
>> > > 
>> > > Calling xen_setup_machphys_mapping() again in the resume path will avoid
>> > > the crash.
>> > 
>> > Oh, duh!
>> > 
>> > Let me queue that up for 3.0-rc7 unless there are objections?
>> 
>> It's not so much an objection to this patch but this issue seems to have
>> been caused by Xen cset 20892:d311d1efc25e which looks to me like a
>> subtle ABI breakage for guests. Perhaps we should introduce a feature
>> flag to indicate that a guest can cope with the m2p changing size over
>> migration like this?
> 
> Sounds reasonable to me.. I will wait (I can always submit it during 3.1 
> cycle
> and CC stable@kernel.org to backport it to 3.0.1).
> 
> Jan, you are the one who came up with the c/s - what's your thought?
> How does your kernel handle the changing size of the M2P - like the patch 
> below?

As said in an earlier reply to Ian, I didn't pay attention to the
migration aspects and I'm in favor of introducing a feature flag
to control the behavior.

In the meantime, as an immediate fix, I just sent out a patch to
revert to original behavior for all but Dom0.

Jan

