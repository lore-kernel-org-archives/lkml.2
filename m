Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab2EAUoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 16:44:14 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:53683 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab2EAUoN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 16:44:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120501202640.GB16209@phenom.dumpdata.com>
References: <20120501194240.GA15237@phenom.dumpdata.com>
	<CA+5PVA4OorzAkkBe+PayPPHa1k7=X6Y0ALg=jRWLyKxabAPpiw@mail.gmail.com>
	<20120501202640.GB16209@phenom.dumpdata.com>
Date: Tue, 1 May 2012 16:44:13 -0400
Message-ID: <CA+5PVA49wJjDFW7_3kDhG=uVavZrhys8N9-XMq14BGORX65yuA@mail.gmail.com>
Subject: Re: [GIT PULL] stable/for-ingo-v3.5 of IOAPIC abstraction (and then
 some users) for v3.5
From: Josh Boyer <jwboyer@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        mingo@kernel.org, suresh.b.siddha@intel.com, mlin@ss.pku.edu.cn
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 1, 2012 at 4:26 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Tue, May 01, 2012 at 04:08:19PM -0400, Josh Boyer wrote:
>> On Tue, May 1, 2012 at 3:42 PM, Konrad Rzeszutek Wilk
>> <konrad.wilk@oracle.com> wrote:
>> > +
>> > +struct x86_io_apic_ops x86_io_apic_ops = {
>> > +       .init   = native_io_apic_init_mappings,
>> > +       .read   = native_io_apic_read,
>> > +       .write  = native_io_apic_write,
>> > +       .modify = native_io_apic_modify,
>> > +};
>>
>> You'll get a section mismatch warning on this struct.  It's not a huge
>> deal, but native_io_apic_init_mappings is annotated as __init whereas
>> this struct isn't.  In practice it doesn't seem to matter as
>> x86_io_apic_ops.init is only called in setup_arch, but it's still a
>> valid warning.
>
> I think that the mismatch disappears if the structure has the word
> _ops in it. At least that is what I saw (when I ran with the MODULE_SECTION=y
> with the initial implementation of this and then fixed it up).
>
> However, let me double check - I might have seen that with something
> else and misremebered it.

Oh, you might very well be correct.  The bug has an older version of
this patch that just calls it 'x86_ioapic'.  Guess I'll need to poke
around and update whatever we're carrying to the latest version.

If it's gone, sorry for the noise.

josh
