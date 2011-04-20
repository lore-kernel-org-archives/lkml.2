Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab1DTQph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 12:45:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755296Ab1DTQpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 12:45:33 -0400
Message-ID: <4DAF0DAA.5080608@redhat.com>
Date: Wed, 20 Apr 2011 12:45:30 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: rwhitton@iee.org
CC: linux-kernel@vger.kernel.org
Subject: Re: Background memory scrubbing
References: <42558.1303286300@jupiter.eclipse.co.uk>
In-Reply-To: <42558.1303286300@jupiter.eclipse.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2011 03:58 AM, Robert Whitton wrote:

> for each PFN from 256 to the highest valid PFN
> {
>    if (pfn_valid(PFN))
>    {
>      page = pfn_to_page(PFN)
>      va = kmap(page)
>      atomic_scrub(va, PAGE_SIZE)
>      kunmap(page)
>    }
>
>    sleep(for_a_while)
> }

What exactly does atomic_scrub do?

> This code works absolutely fine up to a short distance beyond the 16MB boundary (specifically it seems to always fail on my hardware at PFN 4105). At this point despite the fact that kmap returns a valid virtual address (and it is the virtual address that I expect - 0xffff880001009000) I get the kernel oops - "unable to handle kernel paging request".

Looks like you might be making some of the kernel code that
is running at that moment unreachable, leading to a kernel
page fault.
