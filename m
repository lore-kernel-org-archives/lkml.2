Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761434Ab2FVHCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 03:02:16 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:43550 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761396Ab2FVHCP convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 22 Jun 2012 03:02:15 -0400
Message-Id: <4FE434C0020000780008B45A@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 22 Jun 2012 08:02:56 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Jean Delvare" <khali@linux-fr.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, <x86@kernel.org>,
        "LKML" <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86, cpufeature: Fix duplicate feature name "dts"
References: <20120621162807.3c621d46@endymion.delvare>
 <4FE34BCB.5050305@linux.intel.com>
In-Reply-To: <4FE34BCB.5050305@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 21.06.12 at 18:28, "H. Peter Anvin" <hpa@linux.intel.com> wrote:
> Good spotting, but I'm worried this is the wrong fix.
> 
> This is a userspace ABI change, and the and we have used "dts" for debug
> store (debug trace store?) for a very long tie, whereas digital thermal
> sensor only has been used since 2010; another *major* question is which
> of these is more likely to be of interest to userspace.
> 
> Jan, do you have any feeling on this?

Now that you already figured that there is user space code
depending on the current (questionable) string, I don't think
it matters much - I would have preferred to correct the string
to match the CPUID documentation (albeit I seem to recall
that early on the bit was indeed named DTS in the doc).

Wouldn't it be helpful if mkcapflags.pl detected duplicates?

Jan

