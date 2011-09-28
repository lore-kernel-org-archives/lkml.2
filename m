Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab1I1PoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 11:44:05 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:60532 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab1I1PoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 11:44:02 -0400
Date: Wed, 28 Sep 2011 23:42:42 +0800
From: Ram Pai <linuxram@us.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, weiyang@linux.vnet.ibm.com,
        wangyun@linux.vnet.ibm.com, shangw@linux.vnet.ibm.com,
        Michal Ludvig <mludvig@logix.net.nz>
Subject: Re: [PATCH] Resource: wrong resource window calculation
Message-ID: <20110928154200.GA2477@ram-ThinkPad-T61>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <CAErSpo70k6UnhvvOMgQQxJ6BHZOwym=-jaPMvOukAaCr-B0+cQ@mail.gmail.com>
 <4E5EFFBD.4050201@logix.net.nz>
 <CAErSpo6bofeiAxeRo_RjXQSnwmcWrdymn0MK8H4_CwqwoeD1jg@mail.gmail.com>
 <4E634814.4050508@logix.net.nz>
 <20110909113409.GE2416@ram-ThinkPad-T61>
 <4E6C05B7.9000904@logix.net.nz>
 <20110913110646.GB2425@ram-ThinkPad-T61>
 <4E6F400A.6090909@logix.net.nz>
 <20110922074858.GG5085@ram-ThinkPad-T61>
 <4E7B04F8.3090500@logix.net.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E7B04F8.3090500@logix.net.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11092815-3270-0000-0000-0000007A0145
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 09:50:48PM +1200, Michal Ludvig wrote:
> On 09/22/2011 07:48 PM, Ram Pai wrote:
> >   	Resource: wrong resource window calculation
> >
> >__find_resource() incorrectly returns a resource window which overlaps an
> >existing allocated window. This happens when the parent's resource-window spans
> >0x00000000 to 0xffffffff and is entirely allocated to all its children
> >resource-windows.
> >
> >__find_resource() looks for gaps in resource allocation among the children
> >resource windows.  When it encounters the last child window it blindly tries
> >the range next to one allocated to the last child. Since the last child's
> >window ends at 0xffffffff the calculation overflows, leading the algorithm to
> >believe that any window in the range 0x0000000 to 0xfffffff is available for
> >allocation. This leads to a conflicting window allocation.
> >
> >Michal Ludvig reported this issue seen on his platform. The following patch
> >fixes the problem and has been verified by Michal. I believe this bug has been
> >there for ages. It got exposed by git commit
> >2bbc6942273b5b3097bd265d82227bdd84b351b2
> >[PATCH] PCI : ability to relocate assigned pci-resources
> >
> >Signed-off-by: Ram Pai<linuxram@us.ibm.com>
> 
> Tested-by: Michal Ludvig <mludvig@logix.net.nz>
> 
> Works fine on top of 3.1.0-rc7 and solves the problem with my Jetway board.
> 
> Thanks Ram!
> 
> M.

Linus,

	Do you plan to take this patch for 3.1? It fixes a regression w.r.t 3.0
	https://bugzilla.kernel.org/show_bug.cgi?id=42002 captures the bug report.

RP

