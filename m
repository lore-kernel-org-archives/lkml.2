Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148Ab2IGHnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 03:43:05 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:55439 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365Ab2IGHnC convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:2>);
	Fri, 7 Sep 2012 03:43:02 -0400
Message-Id: <5049C1DB020000780009998F@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 07 Sep 2012 08:43:55 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Matt Fleming" <matt.fleming@intel.com>
Cc: "Vasco Dias" <rafa.vasco@gmail.com>, "Matthew Garrett" <mjg@redhat.com>,
        <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cJ-ko@zougloub.eu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86, efi: 1:1 pagetable mapping for virtual EFI
 calls
References: <1346937309-1581-1-git-send-email-matt@console-pimps.org>
 <5048D09A020000780009965B@nat28.tlf.novell.com>
 <1346946465.4244.107.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1346946465.4244.107.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.09.12 at 17:47, Matt Fleming <matt.fleming@intel.com> wrote:
> On Thu, 2012-09-06 at 15:34 +0100, Jan Beulich wrote:
>> >>> On 06.09.12 at 15:15, Matt Fleming <matt@console-pimps.org> wrote:
>> > +
>> > +		pgd += i;
>> > +		save[i] = *pgd;
>> > +		set_pgd(pgd, efi_one_to_one_pgd[i]);
>> > +	}
>> 
>> Did you, as an alternative, consider switching to a different
>> CR3 instead of copying back and forth?
> 
> I did consider it, but I couldn't convince myself whether or not the EFI
> pagetable would need to be manually kept in sync with any other
> pagetables. But now I look at the code a bit harder, it seems that
> should be taken care of automatically. In fact, the tboot code seems to
> do something similar. I'll try that approach.

Actually, I think the copying approach is even broken - what if
multiple threads currently on the same address space want to
invoke a runtime call simultaneously? The first one to get here
would save the right values, but the second one wouldn't.

Jan

