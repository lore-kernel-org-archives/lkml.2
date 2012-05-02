Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab2EBJF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 05:05:29 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:38147 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354Ab2EBJF2 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Wed, 2 May 2012 05:05:28 -0400
Message-Id: <4FA114F402000078000810D4@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 02 May 2012 10:05:24 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <david.vrabel@citrix.com>, "xen-devel" <xen-devel@lists.xen.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] auto balloon initial domain and fix dom0_mem=X
 inconsistencies (v5).
References: <1334596539-18172-1-git-send-email-konrad.wilk@oracle.com>
 <20120501163707.GA8741@phenom.dumpdata.com>
In-Reply-To: <20120501163707.GA8741@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 01.05.12 at 18:37, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> On Mon, Apr 16, 2012 at 01:15:31PM -0400, Konrad Rzeszutek Wilk wrote:
>> Changelog v5 [since v4]:
>>  - used populate_physmap, fixed bugs.
>> [v2-v4: not posted]
>>  - reworked the code in setup.c to work properly.
>> [v1: https://lkml.org/lkml/2012/3/30/492]
>>  - initial patchset
> 
> One bug I found was that with 'dom0_mem=max:1G' (with and without these
> patches) I would get a bunch of
> 
> (XEN) page_alloc.c:1148:d0 Over-allocation for domain 0: 2097153 > 2097152
> (XEN) memory.c:133:d0 Could not allocate order=0 extent: id=0 memflags=0 (0 
> of 17)
> 
> where the (0 of X), sometimes was 1, 2,3,4 or 17 -depending on the machine
> I ran on it. I figured it out that the difference was in the ACPI tables
> that are allocated - and that those regions - even though are returned
> back to the hypervisor, cannot be repopulated. I can't find the actual
> exact piece of code in the hypervisor to pin-point and say "Aha".

Are you sure about this? For one, given that you wrote that you saw this
with as little as a single page off, I doubt there's any half way modern
system where ACPI tables all fit into a single page (2 would even seem to
be a theoretical minimum, as there ought to be one NVS region along with
the "normal" tables).

Second, the ability to repopulate shouldn't really depend on the nature of
the corresponding machine pages.

Jan

