Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab1HZNZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 09:25:25 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38327 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029Ab1HZNZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 09:25:24 -0400
Message-ID: <4E579E9F.9090906@linux.vnet.ibm.com>
Date: Fri, 26 Aug 2011 08:24:47 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Nebojsa Trpkovic <trx.lists@gmail.com>, linux-kernel@vger.kernel.org,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: cleancache can lead to serious performance degradation
References: <4E4C395E.20000@gmail.com 20110825041212.GA5014@dumpdata.com> <3aef71a8-d390-4a91-bfef-561c89edc040@default>
In-Reply-To: <3aef71a8-d390-4a91-bfef-561c89edc040@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2011 11:56 AM, Dan Magenheimer wrote:

> Third, zcache is relatively new and can certainly benefit from
> the input of other developers.  The lzo1x compression in the kernel
> is fairly slow; Seth Jennings (cc'ed) is looking into alternate
> compression technologies.  Perhaps there is a better compression
> choice more suitable for older-slower processors, probably with a
> poorer compression ratio.  Further, zcache currently does compression
> and decompression with interrupts disabled, which may be a
> significant factor in the slowdowns you've observed.  This should
> be fixable.

This was something I've meaning to ask about.  Why are compression
and decompression done with interrupts disabled?  What would need
to change so that we don't have to disable interrupts?

<cut>
>>> I guess that possible workaround could be to implement some kind of
>>> compression throttling valve for cleancache/zcache:
>>>
>>> - if there's available CPU time (idle cycles or so), then compress
>>> (maybe even with low CPU scheduler priority);
> 
> Agreed, and this low-priority kernel thread ideally would also
> solve the "compress while irqs disabled" problem!

--
Seth
