Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab2JQRHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:07:04 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:26310 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757433Ab2JQRHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:07:02 -0400
Date: Wed, 17 Oct 2012 12:54:52 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        lenb@kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
Subject: Re: Is: axe read_tscp pvops call. Was: Re: [RFC] ACPI S3 and Xen
 (suprisingly small\!).
Message-ID: <20121017165452.GA22740@phenom.dumpdata.com>
References: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com>
 <507ED6C0.4020503@zytor.com>
 <20121017161036.GA10691@phenom.dumpdata.com>
 <507EE1C3.7070300@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507EE1C3.7070300@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 09:50:11AM -0700, H. Peter Anvin wrote:
> On 10/17/2012 09:10 AM, Konrad Rzeszutek Wilk wrote:
> >On Wed, Oct 17, 2012 at 09:03:12AM -0700, H. Peter Anvin wrote:
> >>On 10/17/2012 06:49 AM, Konrad Rzeszutek Wilk wrote:
> >>>
> >>>Note: These are the other patches that went in 3.7-rc1:
> >>>xen/bootup: allow {read|write}_cr8 pvops call [https://lkml.org/lkml/2012/10/10/339]
> >>>xen/bootup: allow read_tscp call for Xen PV guests. [https://lkml.org/lkml/2012/10/10/340]
> >>>
> >>
> >>So WTF do we have a read_tscp PV call?  Again, if there isn't a user
> >>we should just axe it...
> >
> >Let me spin off a patch to see if that can be done.
> >
> 
> Could you do an audit for other pvops calls that have no users?  If
> the *only* user is lguest, we should talk about it, too...

I can do that - but I don't want to be hasty here. There is a bit of
danger here - for example the read_pmc (or read_tsc) is not in use right
now. But it might be when one starts looking at making perf be able to
analyze the hypervisor (hand-waving the implementation details). So while
removing read_pmc now sounds good, it might be needed in the future.

Or maybe not :-)

Let me do a candidate list and get some conversation going.
