Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab0LHBPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:15:12 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:9022 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756494Ab0LHBPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:15:08 -0500
From: Dmitry Torokhov <dtor@vmware.com>
Organization: VMware, Inc.
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] VMware balloon: stop locking pages when hypervisor tells us enough
Date: Tue, 7 Dec 2010 17:15:08 -0800
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.5.3; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pv-drivers@vmware.com" <pv-drivers@vmware.com>
References: <20101203165226.GA16146@dtor-ws.eng.vmware.com> <20101207171023.d28e20ee.akpm@linux-foundation.org>
In-Reply-To: <20101207171023.d28e20ee.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012071715.08384.dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 07, 2010 05:10:23 pm Andrew Morton wrote:
> On Fri, 3 Dec 2010 08:52:26 -0800
> 
> Dmitry Torokhov <dtor@vmware.com> wrote:
> > When hypervisor decides to decrease target balloon size while the
> > balloon driver tries to lock pages hypervisor may respond with
> > VMW_BALLOON_PPN_NOTNEEDED. Use this data and immediately stop reserving
> > pages and wait for the next update cycle to fetch new target instead
> > of continuing trying to lock pages until size of refused list grows
> > above VMW_BALLOON_MAX_REFUSED (16) pages.
> 
> OK, but ... why?  What is the externally visible effect of this change?

As a result the driver stops bothering hypervisor with its attempts to
lock more pages that are not needed anymore. Most likely next order from
hypervisor will be to reduce ballon size anyway.

It is a small optimization.

Thanks,

Dmitry
