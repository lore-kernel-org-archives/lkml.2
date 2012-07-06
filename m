Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab2GFNwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 09:52:51 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:53466 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab2GFNwt convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 6 Jul 2012 09:52:49 -0400
Message-Id: <4FF70A09020000780008E155@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 06 Jul 2012 14:53:45 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Olaf Hering" <olaf@aepfle.de>
Cc: <kexec@lists.infradead.org>, <xen-devel@lists.xensource.com>,
        "Daniel Kiper" <dkiper@net-space.pl>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] incorrect layout of globals from head_64.S
 during kexec boot
References: <20120705210607.GA26908@aepfle.de>
 <20120706084120.GA31219@router-fw-old.local.net-space.pl>
 <20120706120750.GA8970@aepfle.de>
 <4FF6FCA9020000780008E0BB@nat28.tlf.novell.com>
 <20120706133105.GA20600@aepfle.de>
In-Reply-To: <20120706133105.GA20600@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.07.12 at 15:31, Olaf Hering <olaf@aepfle.de> wrote:
> On Fri, Jul 06, Jan Beulich wrote:
> 
>> >>> On 06.07.12 at 14:07, Olaf Hering <olaf@aepfle.de> wrote:
>> > But adding some debug to inspect
>> > *output in parse_elf() shows that the second entry in program headers is
>> > already shifted by 44 bytes in my testing, the others are shifted by the
>> > same amount.
>> 
>> Unfortunately it's not clear what is shifted - the printout below
>> looks just fine. Also, from your first mail I understood that the shift
>> there was by an amount not divisible by 4 - does that amount vary?
> 
> The memory location of the second LOAD entry (the .data section) is wrong.
> It should be at 0x1c00000, but in fact its content starts at 0x1c0002c.
> I looked at the x86 boot code, the vmlinux is gzipped and placed as
> binary blob, which is then extracted by decompress().

Are the virtual addresses then offset as well?

Is phdr->p_offset sane?

And you didn't clarify whether the offset was always the same.

Jan

