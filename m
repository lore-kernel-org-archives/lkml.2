Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab0LHJeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 04:34:22 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:57398 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab0LHJeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 04:34:18 -0500
X-IronPort-AV: E=Sophos;i="4.59,315,1288584000"; 
   d="scan'208";a="125875428"
Subject: Re: [PATCH 1/3] x86-32: Separate 1:1 pagetables from swapper_pg_dir
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Greg KH <greg@kroah.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Joerg Roedel <joerg.roedel@amd.com>,
        Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20101208041528.GA2211@kroah.com>
References: <20101111141358.GA4641@kroah.com>
	 <1289488576-18117-2-git-send-email-joerg.roedel@amd.com>
	 <20101207210512.GA14849@kroah.com> <4CFEF637.4020203@goop.org>
	 <20101208041528.GA2211@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 8 Dec 2010 09:34:15 +0000
Message-ID: <1291800855.13966.4404.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 04:15 +0000, Greg KH wrote:
> On Tue, Dec 07, 2010 at 07:06:31PM -0800, Jeremy Fitzhardinge wrote:
> > On 12/07/2010 01:05 PM, Greg KH wrote:
> > > On Thu, Nov 11, 2010 at 04:16:14PM +0100, Joerg Roedel wrote:
> > >> commit fd89a137924e0710078c3ae855e7cec1c43cb845 upstream
> > > applied, thanks.
> > 
> > This will need as well 5b5c1af104ab5adec1be9dcb4c787492d83d8d83 to
> > prevent Xen regressions.
> 
> So should I add that to a specific release? The next .36 stable or something else?

5b5c1af104ab5 fixed an issue exposed by b40827fa7268. I'm not sure if
fd89a13792 also exposes a similar issue, but I think it does not:

It looks to me like fd89a13792 only reads from swapper_pg_dir and writes
to trampoline_pg_dir which is unpinned (and unused) under Xen and hence
there is no problem and 5b5c1af104ab5 is not needed.

b40827fa7268 is in 2.6.37-rc and doesn't seem to be targeted for a
stable backport AFAICT.

Ian.

