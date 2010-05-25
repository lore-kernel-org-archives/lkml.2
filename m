Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933428Ab0EYRfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 13:35:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34466 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933412Ab0EYRfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 13:35:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=hmE1mFx7nCWUZ0GHgCMTvbU1/ck2UI1IUNWi/GqqOb3/PGQsWInG+CVPGBFGYgmOWY
         xIeU+fviRoSNDXeuc7hwPIUAEDad+19hK+AzEXSKOJwILXzeauMvrkcYbuuxxmIH3N/Z
         8ljw/N2okQ0hgR0tt+VwlX6HpAVe+MGXwuUXA=
MIME-Version: 1.0
In-Reply-To: <20100525171959.GH20853@laptop>
References: <AANLkTimhTfz_mMWNh_r18yapNxSDjA7wRDnFM6L5aIdE@mail.gmail.com>
	<20100525081634.GE5087@laptop>
	<AANLkTilJBY0sinB365lIZFUaMgMCZ1xyhMdXRTJTVDSV@mail.gmail.com>
	<20100525093410.GH5087@laptop>
	<AANLkTikXp5LlKLK1deKOQpciUFNugjlQah5QpNcImf39@mail.gmail.com>
	<20100525101924.GJ5087@laptop>
	<AANLkTimazVL8G-XQURiQ1s0M3NKa2ndXNceSaw9sADRQ@mail.gmail.com>
	<alpine.LFD.2.00.1005250812100.3689@i5.linux-foundation.org>
	<20100525154352.GB20853@laptop>
	<AANLkTilEIwPSN-stGGuu5wV4Q6Ty0GytNMpfq-vRpK_k@mail.gmail.com>
	<20100525171959.GH20853@laptop>
Date: Tue, 25 May 2010 20:35:05 +0300
X-Google-Sender-Auth: 750uUqqg7_aIqxZvevDuqIpTu4o
Message-ID: <AANLkTinqDzRcWd9RzS_o8BUy7uWCls_4jIhWtdYcF5Uo@mail.gmail.com>
Subject: Re: [RFC V2 SLEB 00/14] The Enhanced(hopefully) Slab Allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Matthew Wilcox <willy@linux.intel.com>, Matt Mackall <mpm@selenic.com>,
       Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 8:19 PM, Nick Piggin <npiggin@suse.de> wrote:
>> I'm not totally convinced but I guess we're about to find that out.
>> How do you propose we benchmark SLAB while we clean it up
>
> Well the first pass will be code cleanups, bootstrap simplifications.
> Then looking at what debugging features were implemented in SLUB but not
> SLAB and what will be useful to bring over from there.

Bootstrap might be easy to clean up but the biggest source of cruft
comes from the deeply inlined, complex allocation paths. Cleaning
those up is bound to cause performance regressions if you're not
careful.
