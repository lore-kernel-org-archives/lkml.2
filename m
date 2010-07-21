Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716Ab0GUV3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 17:29:20 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:55103 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758554Ab0GUV3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 17:29:19 -0400
Date: Wed, 21 Jul 2010 17:29:00 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Luming Yu <luming.yu@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC PATCH] use acpi_idle_enter_simple if bm_check && !.bm_control
In-reply-to: <20100419174737.GA13331@srcf.ucam.org>
Message-id: <alpine.LFD.2.00.1007211725530.409@localhost.localdomain>
References: <3877989d0911092212i367b9156n78d57aeee6742147@mail.gmail.com>
 <20100419174737.GA13331@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Apr 2010, Matthew Garrett wrote:

> On Tue, Nov 10, 2009 at 02:12:41PM +0800, Luming Yu wrote:
> 
> > I came across acpi processor idle driver, noticed that we can cut a
> > bit overhead at C3 entry that can improve C3 residency a bit,
> > especially when it has similar kernel config as old RHEL 5 kernel
> > (2.6.18) on systems with as many as 64 logical CPUs. The point of this
> > patch is bm_sts is an optional bit. It never returns 1 on systems with
> > bm_check && !bm_control I tested. Instead, I have observed lower C3
> > residency due to accessing bm_sts and relevant code on a system with
> > 64 logical CPUs with HZ=1000. Please review. If make sense, please
> > apply.
> 
> Saves 40W or so on a dual-socket Nehalem system here. Is there a reason 
> it wasn't picked up?

The reason it wasn't picked up is because it assumed that the need
for checking BM_STS is identical to the ability to use ARB_DIS.

However, the two are entirely independent.  The result is that
with the patch we would stop checking BM_STS for every Core2 Duo
system -- which would be incorrect.

thanks,
Len Brown, Intel Open Source Technology Center



