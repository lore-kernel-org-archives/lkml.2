Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab2BFQhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:37:32 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:21002 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344Ab2BFQh3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:37:29 -0500
MIME-Version: 1.0
Message-ID: <e871af1b-8003-4d3d-8fde-ea40545ff9fe@default>
Date: Mon, 6 Feb 2012 08:37:17 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-kernel@vger.kernel.org
Subject: RE: [PATCH] xen/tmem: cleanup
References: <4F2C06A00200007800071071@nat28.tlf.novell.com>
 <d86f0be9-1530-47bd-b3fd-8c251e563b25@default>
 <4F2F998202000078000714CD@nat28.tlf.novell.com>
In-Reply-To: <4F2F998202000078000714CD@nat28.tlf.novell.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F3001C2.00CE,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Jan Beulich [mailto:JBeulich@suse.com]
> Sent: Monday, February 06, 2012 1:13 AM
> To: Dan Magenheimer
> Cc: Jeremy Fitzhardinge; xen-devel@lists.xensource.com; Konrad Wilk; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH] xen/tmem: cleanup
> 
> >>> On 04.02.12 at 17:42, Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> >>  From: Jan Beulich [mailto:JBeulich@suse.com]
> >> Subject: [PATCH] xen/tmem: cleanup
> >>
> >> Use 'bool' for boolean variables. Do proper section placement.
> >> Eliminate an unnecessary export.
> >>
> >> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> >> Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
> >>
> >> -int tmem_enabled __read_mostly;
> >> -EXPORT_SYMBOL(tmem_enabled);
> >> +bool __read_mostly tmem_enabled = false;
> >
> > tmem_enabled is used in xen/drivers/xen-selfballoon.c
> 
> Which can't be built as a module, and hence the symbol doesn't need
> exporting. This patch (of course, I'm tempted to say) survived build
> testing.

Yes, correct.  BUT... I think only the reason xen-selfballoon.c
can't be built as a module is because the MM variable vm_committed_as
(or an access function) is not exported.  Ideally xen-selfballoon.c
probably should be a module but putting a core MM change in
the critical path of a Xen-only-related enhancement seemed
a recipe for sure failure.

Konrad, if you (1) disagree entirely, or (2) want to remove the
tmem_enabled EXPORT_SYMBOL now and add it back later if/when
the core MM change happens, I'll leave that up to you.

If (2), the MM change should be added to the minor-tmem-related-
changes-that-need-to-be-eventually-upstreamed list ;-)

Dan
