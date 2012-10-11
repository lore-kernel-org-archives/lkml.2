Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933522Ab2JKA1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:27:47 -0400
Received: from ozlabs.org ([203.10.76.45]:53530 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933517Ab2JKA1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:27:32 -0400
Date: Thu, 11 Oct 2012 11:14:44 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Mitch Bradley <wmb@firmworks.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Michal Marek <mmarek@suse.cz>,
        Stephen Warren <swarren@nvidia.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: dtc: import latest upstream dtc
Message-ID: <20121011001444.GJ28467@truffula.fritz.box>
References: <5069C042.40209@gmail.com>
 <5069C11C.6040505@wwwdotorg.org>
 <5069D946.1060502@gmail.com>
 <5069E1F0.5070902@wwwdotorg.org>
 <E1TIktZ-0000U4-Qh@jdl.com>
 <50749441.8030307@wwwdotorg.org>
 <5075ABB8.103@gmail.com>
 <5075BD21.2070106@firmworks.com>
 <5075C254.4040304@wwwdotorg.org>
 <5075C4CB.8020409@firmworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5075C4CB.8020409@firmworks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 08:56:11AM -1000, Mitch Bradley wrote:
> On 10/10/2012 8:45 AM, Stephen Warren wrote:
> > On 10/10/2012 12:23 PM, Mitch Bradley wrote:
> >> On 10/10/2012 7:09 AM, Rob Herring wrote:
> >>> On 10/09/2012 04:16 PM, Stephen Warren wrote:
> >>>> On 10/01/2012 12:39 PM, Jon Loeliger wrote:
[snip]
> >> Instead of making a bunch of rules about how you can only use a small
> >> subset of cpp, why not just add a "define name value" command to DTC?
> > 
> > I implemented a patch to do exactly that, and it was rejected because it
> > only solved part of the problem (named constants) and not the reset (a
> > completely generic macro language/... within dtc). The argument was that
> > defining just the named constant syntax on its own without knowing what
> > the unspecified future macro language will look like might result in the
> > named constant syntax not fitting into it.
> > 
> > That all said, I now think that using cpp is actually a much better
> > solution that adding yet more dtc-specific syntax. The *huge* benefit
> > here is that it allows you to share .h files between *.dts and C code,
> > so you don't have to write out the same set of #defines once in dtc
> > syntax and once in cpp syntax.
> 
> ... and it imposes an equally *huge* restriction that you have to
> restrict the .h file to avoid avoid C constructs.  That can be done, but
> I've personally experienced a lot of headaches when trying to share .h
> files between different languages.

Yes, but we already deal with that for asm files.  And the sorts of
defines we use in asm files are often the same ones we'd want in dts
files.


-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
