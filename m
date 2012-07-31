Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab2GaQlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 12:41:15 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:33714 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab2GaQlN convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Tue, 31 Jul 2012 12:41:13 -0400
Message-Id: <501826EF0200007800091AE9@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 31 Jul 2012 17:41:51 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <Ian.Campbell@citrix.com>, <x86@kernel.org>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH] extend_brk and fixes to users of
 extend_brk (v1).
References: <1343731376-20658-1-git-send-email-konrad.wilk@oracle.com>
 <5017FE81.3080903@zytor.com> <20120731161515.GQ4789@phenom.dumpdata.com>
In-Reply-To: <20120731161515.GQ4789@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 31.07.12 at 18:15, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> On Tue, Jul 31, 2012 at 08:49:21AM -0700, H. Peter Anvin wrote:
>> This means you're either abusing the brk allocator to do something
>> it is not meant to do... which may mean you can a failure in *other*
>> code, or you have a bug in your code that you haven't fixed.
> 
> Its the latter - and of one of the patches in this patchset fixes that.

But then you also can't assume that fitting a 2Gb MMIO hole will
suffice; I have a machine here that I can configure to have a
3Gb hole, so I think you really need to be on the safe side and
allow to cover all the way up to 4Gb with the space you reserve.

Jan

