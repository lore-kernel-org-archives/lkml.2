Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935387Ab1JEUS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 16:18:28 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60874 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935179Ab1JEUS0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 16:18:26 -0400
MIME-Version: 1.0
In-Reply-To: <20111005201244.GA13027@suse.de>
References: <1317750395.18063.11.camel@gandalf.stny.rr.com>
	<20111004180237.GA15087@suse.de>
	<1317752148.18063.16.camel@gandalf.stny.rr.com>
	<20111004182615.GA16224@suse.de>
	<1317753468.18063.19.camel@gandalf.stny.rr.com>
	<1317779312.1662.37.camel@schurl.linbit>
	<20111005065309.GA6676@suse.de>
	<1317813674.1623.10.camel@schurl.linbit>
	<20111005201244.GA13027@suse.de>
Date: Wed, 5 Oct 2011 16:18:25 -0400
Message-ID: <CA+5PVA4BOE=mwHu0wu+C6hyyCZ1Ki+Y-cy4DM7sbFB5Lhyf8oA@mail.gmail.com>
Subject: Re: [Quilt-dev] [RFC][PATCH v2][QUILT] Add gpg signing to quilt mail
From: Josh Boyer <jwboyer@gmail.com>
To: quilt-dev@nongnu.org
Cc: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        John Kacur <jkacur@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 5, 2011 at 4:12 PM, Greg KH <gregkh@suse.de> wrote:
> On Wed, Oct 05, 2011 at 01:21:07PM +0200, Andreas Gruenbacher wrote:
>> I've tried to address this as follows now:
>>
>> commit f3e7822028616014f933b99d05f42fc028f8d12c
>> Author: Andreas Gruenbacher <agruen@linbit.com>
>> Date:   Wed Oct 5 12:57:48 2011 +0200
>>
>>     quilt mail: Allow commas in Signed-off-by and Acked-by lines
>>
>>     The standard quilt_mail_patch_filter() in quilt mail tries to extract email
>>     addresses from Signed-off-by and Acked-by lines.  It adds Cc headers with those
>>     addresses.
>>
>>     Signed-off-by and Acked-by lines sometimes contain commas as part of the
>>     address.  When put in recipient headers (To, Cc, Bcc), the commas are
>>     interpreted as separators, which breaks things.
>>
>>     Try to recognize this case and add the appropriate quotes.  For example, the
>>     email address in ``Signed-off-by: Gruenbacher, Andreas <agruen@linbit.com>'' is
>>     now extracted as ``"Gruenbacher, Andreas" <agruen@linbit.com>''.
>>
>>     Note that quilt_mail_patch_filter() can be overridden in .quiltrc; you may need
>>     to update your .quiltrc.
>>
>> commit c6750845136ff21eb13bc99ec7a6e1689100a13a
>> Author: Andreas Gruenbacher <agruen@linbit.com>
>> Date:   Wed Oct 5 12:08:05 2011 +0200
>>
>>     quilt mail: Support double quoted special characters in email adresses
>>
>>     Addresses like "Gruenbacher, Andreas" <agruen@linbit.com> will work now.
>>
>>
>> Please give it a shot.
>
> Thanks for doing this.  I can't seem to find the git tree for quilt at
> the moment, any pointers to where it is?

http://savannah.nongnu.org/git/?group=quilt

josh
