Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab2G0KRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 06:17:46 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:44177 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab2G0KRo convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 27 Jul 2012 06:17:44 -0400
Message-Id: <501286E50200007800090ECB@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 27 Jul 2012 11:17:41 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ian Campbell" <Ian.Campbell@citrix.com>
Cc: "Ian Jackson" <Ian.Jackson@eu.citrix.com>,
        "xen-devel" <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [RFC PATCH] Boot PV guests with more than
 128GB (v1) for 3.7
References: <1343335652-5659-1-git-send-email-konrad.wilk@oracle.com>
 <501260980200007800090E08@nat28.tlf.novell.com>
 <1343383205.6812.137.camel@zakaz.uk.xensource.com>
In-Reply-To: <1343383205.6812.137.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 27.07.12 at 12:00, Ian Campbell <Ian.Campbell@citrix.com> wrote:
> On Fri, 2012-07-27 at 08:34 +0100, Jan Beulich wrote:
>> >>> On 26.07.12 at 22:47, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>> >  2). Allocate a new array, copy the existing P2M into it,
>> >     revector the P2M tree to use that, and return the old
>> >     P2M to the memory allocate. This has the advantage that
>> >     it sets the stage for using XEN_ELF_NOTE_INIT_P2M
>> >     feature. That feature allows us to set the exact virtual
>> >     address space we want for the P2M - and allows us to
>> >     boot as initial domain on large machines.
>> 
>> And I would hope that the tools would get updated to recognize
>> this note too, so that huge DomU-s would become possible as
>> well.
> 
> Does this help us with >160GB 32 bit PV guests too? I'm guessing not
> since the real limitation there is the relatively small amount of kernel
> address space.

Correct - 32-bit PV guests are limited anyway (and it's for a
reason the Dom0 support in the hypervisor only deals with
64-bit ones). And honestly, considering the huge page
information table such a memory amount would require, I
doubt this big a PV guest would even boot (or if it does, be
of any use).

Jan

