Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987Ab0JFWpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 18:45:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759350Ab0JFWpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 18:45:19 -0400
Date: Wed, 6 Oct 2010 15:45:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memblock: Fix big size with find_region()
Message-Id: <20101006154503.db30e742.akpm@linux-foundation.org>
In-Reply-To: <4CACF453.5020205@zytor.com>
References: <4CA1ABA4.6070803@kernel.org>
	<20101006140604.982b22d6.akpm@linux-foundation.org>
	<4CACF453.5020205@zytor.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Oct 2010 15:12:35 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 10/06/2010 02:06 PM, Andrew Morton wrote:
> > 
> > This seems rather odd.  If some caller is passing in size>end then that
> > caller is buggy isn't it?  A memory block which ends at 0x1000 and has
> > a size of 0x2000 is nonsensical.
> > 
> > So shouldn't we at leat emit a warning so tht the offending caller can
> > be found and fixed?
> > 
> 
> I don't think this is necessarily a bug in the caller -- it just
> indicates that it has a request that is impossible to fulfill -- but
> that can happen for a lot of other reasons.
> 
> Keep in mind that the range and the size will typically come from
> different origins.  As such, it's not clear to me that this is something
> that requires printing a specific error message for any more than any
> other allocation failure, but perhaps you disagree?
> 

whomeidunno.  The question is "is this something we want to know
about".  If it's a BIOS/acpi/whatever error then I'd think "yes",
because that would then lead to useful kernel workarounds or BIOS
updates?
