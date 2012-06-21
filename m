Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab2FUJWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 05:22:11 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:58713 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932417Ab2FUJWK convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Thu, 21 Jun 2012 05:22:10 -0400
Message-Id: <4FE3040B020000780008B030@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 21 Jun 2012 10:22:51 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Bjorn Helgaas" <bhelgaas@google.com>
Cc: <linux-cris-kernel@axis.com>, <mingo@elte.hu>, <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86/PCI: adjust section annotations
References: <4FDF2044020000780008A66F@nat28.tlf.novell.com>
 <CAErSpo4yf66A-MoBLyUynMaha3Oa8_M2rNpwgK+2D1LgTaLhUw@mail.gmail.com>
In-Reply-To: <CAErSpo4yf66A-MoBLyUynMaha3Oa8_M2rNpwgK+2D1LgTaLhUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 21.06.12 at 02:06, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Mon, Jun 18, 2012 at 4:34 AM, Jan Beulich <JBeulich@suse.com> wrote:
>> DMI tables referenced from __init code only can be __initconst, and as
>> a result the functions referenced from there can become __init.
>>
>> pcibios_setup() can be __init as being a command line parsing function
>> only.
>>
>> A few other variables can then also have their attributes adjusted.
> 
> This seems OK as far as it goes.
> 
> However, if you're going to make pcibios_setup() __init for x86, I'd
> really encourage you to make it consistent across all the other
> architectures.  And if you do *that*, I think it would be cool if you
> supplied a generic do-nothing "weak" version in the PCI core.  That
> would allow you to remove it altogether from alpha, ia64, microblaze,
> mips pmc-sierra, parisc, powerpc, sh, sparc, tile, and xtensa.

I'd prefer to leave this to the respective arch maintainers, the
patch here really was meant to be x86 specific (as its title says).

Jan

