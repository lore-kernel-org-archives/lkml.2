Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab2BFQtv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:49:51 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:32016 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab2BFQtu convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 6 Feb 2012 11:49:50 -0500
Message-Id: <4F3012B602000078000716AB@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 06 Feb 2012 16:49:42 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Dan Magenheimer" <dan.magenheimer@oracle.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, <xen-devel@lists.xensource.com>,
        "Konrad Wilk" <konrad.wilk@oracle.com>, <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] xen/tmem: cleanup
References: <4F2C06A00200007800071071@nat28.tlf.novell.com>
 <d86f0be9-1530-47bd-b3fd-8c251e563b25@default>
 <4F2F998202000078000714CD@nat28.tlf.novell.com>
 <e871af1b-8003-4d3d-8fde-ea40545ff9fe@default>
In-Reply-To: <e871af1b-8003-4d3d-8fde-ea40545ff9fe@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.02.12 at 17:37, Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
>>  From: Jan Beulich [mailto:JBeulich@suse.com]
>> Sent: Monday, February 06, 2012 1:13 AM
>> To: Dan Magenheimer
>> Cc: Jeremy Fitzhardinge; xen-devel@lists.xensource.com; Konrad Wilk; 
> linux-kernel@vger.kernel.org 
>> Subject: RE: [PATCH] xen/tmem: cleanup
>> 
>> >>> On 04.02.12 at 17:42, Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
>> >>  From: Jan Beulich [mailto:JBeulich@suse.com]
>> >> Subject: [PATCH] xen/tmem: cleanup
>> >>
>> >> Use 'bool' for boolean variables. Do proper section placement.
>> >> Eliminate an unnecessary export.
>> >>
>> >> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>> >> Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
>> >>
>> >> -int tmem_enabled __read_mostly;
>> >> -EXPORT_SYMBOL(tmem_enabled);
>> >> +bool __read_mostly tmem_enabled = false;
>> >
>> > tmem_enabled is used in xen/drivers/xen-selfballoon.c
>> 
>> Which can't be built as a module, and hence the symbol doesn't need
>> exporting. This patch (of course, I'm tempted to say) survived build
>> testing.
> 
> Yes, correct.  BUT... I think only the reason xen-selfballoon.c
> can't be built as a module is because the MM variable vm_committed_as
> (or an access function) is not exported.  Ideally xen-selfballoon.c
> probably should be a module but putting a core MM change in
> the critical path of a Xen-only-related enhancement seemed
> a recipe for sure failure.

No, this isn't the main reason (as you say further down, this could
easily be adjusted for) afaict. The main reason is that
register_xen_selfballooning() is being called from non-modular
code (xen-balloon.c), which could be made a module too, but in
turn has at least one reference that wouldn't be nice to become
an export (balloon_set_new_target()).

Jan

> Konrad, if you (1) disagree entirely, or (2) want to remove the
> tmem_enabled EXPORT_SYMBOL now and add it back later if/when
> the core MM change happens, I'll leave that up to you.
> 
> If (2), the MM change should be added to the minor-tmem-related-
> changes-that-need-to-be-eventually-upstreamed list ;-)
> 
> Dan



