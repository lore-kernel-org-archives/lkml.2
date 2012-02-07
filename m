Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab2BGHwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 02:52:03 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:30962 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab2BGHwB convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Tue, 7 Feb 2012 02:52:01 -0500
Message-Id: <4F30E62B02000078000717EB@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 07 Feb 2012 07:51:55 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, <xen-devel@lists.xensource.com>,
        "Dan Magenheimer" <dan.magenheimer@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen/tmem: cleanup
References: <4F2C06A00200007800071071@nat28.tlf.novell.com>
 <d86f0be9-1530-47bd-b3fd-8c251e563b25@default>
 <4F2F998202000078000714CD@nat28.tlf.novell.com>
 <e871af1b-8003-4d3d-8fde-ea40545ff9fe@default>
 <4F3012B602000078000716AB@nat28.tlf.novell.com>
 <20120206170224.GD23240@phenom.dumpdata.com>
In-Reply-To: <20120206170224.GD23240@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.02.12 at 18:02, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> On Mon, Feb 06, 2012 at 04:49:42PM +0000, Jan Beulich wrote:
>> >>> On 06.02.12 at 17:37, Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
>> >>  From: Jan Beulich [mailto:JBeulich@suse.com]
>> >> > tmem_enabled is used in xen/drivers/xen-selfballoon.c
>> >> 
>> >> Which can't be built as a module, and hence the symbol doesn't need
>> >> exporting. This patch (of course, I'm tempted to say) survived build
>> >> testing.
>> > 
>> > Yes, correct.  BUT... I think only the reason xen-selfballoon.c
>> > can't be built as a module is because the MM variable vm_committed_as
>> > (or an access function) is not exported.  Ideally xen-selfballoon.c
>> > probably should be a module but putting a core MM change in
>> > the critical path of a Xen-only-related enhancement seemed
>> > a recipe for sure failure.
>> 
>> No, this isn't the main reason (as you say further down, this could
>> easily be adjusted for) afaict. The main reason is that
>> register_xen_selfballooning() is being called from non-modular
>> code (xen-balloon.c), which could be made a module too, but in
>> turn has at least one reference that wouldn't be nice to become
>> an export (balloon_set_new_target()).
> 
> It would be nice if all of it could become modules. That way HVM
> device driver domains could load the whole thing without having much
> built-in code in the kernel.
> 
> Is it possible to do that?

As outlined above, it is possible, but I'm not certain it is a good idea
to have balloon_set_new_target() exported. If you think that's
acceptable, I can certainly put together a patch doing that (on top
of the one here, and probably not immediately).

Jan

