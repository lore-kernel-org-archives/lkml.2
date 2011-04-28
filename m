Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab1D1NaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 09:30:25 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:54823 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab1D1NaU convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:3>);
	Thu, 28 Apr 2011 09:30:20 -0400
Message-Id: <4DB98854020000780003EA4D@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 28 Apr 2011 14:31:32 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Heiko Carstens" <heiko.carstens@de.ibm.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        <linux-arch@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] allow placing exception table in .rodata (and do
	 so on x86)
References: <4DB85404020000780003E6D7@vpn.id2.novell.com>
 <20110428104306.GC2431@osiris.boeblingen.de.ibm.com>
 <4DB96E6A020000780003E9EB@vpn.id2.novell.com>
 <BANLkTikJN92ogUfxAc+SgzvX1Q8r48ughw@mail.gmail.com>
 <4DB9748B020000780003EA01@vpn.id2.novell.com>
 <20110428125302.GD2431@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20110428125302.GD2431@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.04.11 at 14:53, Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> On Thu, Apr 28, 2011 at 01:07:07PM +0100, Jan Beulich wrote:
>> >>> On 28.04.11 at 13:47, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> > On Thu, Apr 28, 2011 at 13:40, Jan Beulich <JBeulich@novell.com> wrote:
>> >>>>> On 28.04.11 at 12:43, Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
>> >>> On Wed, Apr 27, 2011 at 04:36:04PM +0100, Jan Beulich wrote:
>> >>> That's odd. The kernel actually writes to it (sort_main_extable()), so
>> >>> it shouldn't be in the ro data section, but the data section.
>> >>
>> >> This area does get written, but only at boot time, before read-only
>> >> data gets set to r/o (on x86 at least). With this in mind, it's better
>> >> to place it in .rodata, as that way run-time protection will be in place
>> >> (and I think you agree that it was misplaced in .text in any case).
>> > 
>> > Which means it may be in ROM (which is really read-only) on some embedded
>> > devices, so it cannot be sorted?
>> 
>> Perhaps - but since sorting is a requirement, people building such
>> systems must have found a way... Anyway, I don't see where both
> 
> Yes, we found a way on s390: we put the exception table in the data section.
> 
>> your and Heiko's comment are heading, since the situation is even
>> worse without the patch afaics (since .text gets marked read-only
>> as much as .rodata does, and could equally be placed in ROM).
> 
> My point is that your default is wrong. If it makes sense to put the extable
> into the rodata section then an architecture could do so. However making the
> default to put data into the rodata section that is actually written to is
> the wrong approach.
> It just asks for breakage.

The patch doesn't make this the default - it just makes it possible
for an architecture to do so.

Jan

