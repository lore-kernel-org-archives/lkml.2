Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab2FEQSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 12:18:44 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:55095 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab2FEQSn convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Tue, 5 Jun 2012 12:18:43 -0400
Message-Id: <4FCE4D800200007800088546@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 05 Jun 2012 17:18:40 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Cc: <x86@kernel.org>, "Don Zickus" <dzickus@redhat.com>,
        "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86,nmi: Fix section mismatch warnings on 32-bit
References: <1338839763-11140-1-git-send-email-dzickus@redhat.com>
 <4FCDDB7D0200007800088390@nat28.tlf.novell.com>
 <20120605144734.GU32472@redhat.com>
 <20120605161318.GA29751@merkur.ravnborg.org>
In-Reply-To: <20120605161318.GA29751@merkur.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 05.06.12 at 18:13, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Tue, Jun 05, 2012 at 10:47:34AM -0400, Don Zickus wrote:
>> On Tue, Jun 05, 2012 at 09:12:13AM +0100, Jan Beulich wrote:
>> > >>> On 04.06.12 at 21:56, Don Zickus <dzickus@redhat.com> wrote:
>> > > It was reported that compiling for 32-bit caused a bunch of section
>> > > mismatch warnings:
>> > > 
>> > >  VDSOSYM arch/x86/vdso/vdso32-syms.lds
>> > >   LD      arch/x86/vdso/built-in.o
>> > >   LD      arch/x86/built-in.o
>> > > WARNING: arch/x86/built-in.o(.data+0x5af0): Section mismatch in reference 
>> > > from the variable
>> > > test_nmi_ipi_callback_na.10451 to the function 
>> > 
>> > Did you check what this (compiler introduced) variable actually
>> > represents? The problem clearly is that the compiler has no way
>> > of knowing that data it generates referencing an __init function
>> > would actually need to go into .init.data or alike.
>> 
>> I do not know enough about behind the scene compiler magic to track this
>> down correctly.  So any insight/help is greatly appreciated. :-)
> 
> We register a function annotated __init. And the normal use of this 
> register()
> is for functions that survive the init phase.
> So drop the __init annotation on the function we register and the mismatch 
> is fixed.

But in the case here the function really is being used at init time
only. Plus it still escapes me why there would be differences in
behavior depending on bit-ness or compiler version.

Jan

