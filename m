Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935021Ab2JaICR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 04:02:17 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:60266 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933836Ab2JaICI convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 31 Oct 2012 04:02:08 -0400
Message-Id: <5090E93302000078000A59C8@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 31 Oct 2012 08:02:43 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Olaf Hering" <olaf@aepfle.de>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "xen-devel" <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v4] xen PVonHVM: move shared_info to
 reserved memory area
References: <1351612057-21822-1-git-send-email-olaf@aepfle.de>
 <50900B1D02000078000A586C@nat28.tlf.novell.com>
 <20121030163006.GA26404@aepfle.de>
 <5090124C02000078000A58AC@nat28.tlf.novell.com>
 <20121030170321.GA1251@aepfle.de>
In-Reply-To: <20121030170321.GA1251@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.10.12 at 18:03, Olaf Hering <olaf@aepfle.de> wrote:
> On Tue, Oct 30, Jan Beulich wrote:
> 
>> And iirc you're doing this relocation because otherwise the newly
>> booting kernel image may get overwritten at an (from its
>> perspective) arbitrary location. What I'm trying to point out is
>> that the shared info structure is not the only thing (potentially)
>> inside the kernel image that might get overwritten - the relocated
>> (by the old kernel) vCPU info may as well. Plus I think the new
>> kernel has no way of relocating it a second time (including back
>> into the shared info structure) with how the hypervisor works at
>> present.
> 
> Thanks, I have not looked at this, nor was I aware of it until now.
> I will see what needs to be done.
> 
> Is this also an issue with the xenlinux based PVonHVM code?

No - this code doesn't make use of that feature (yet, we've got
a feature request that would involve doing so), as it only ever
touches vCPU 0's info.

Jan

