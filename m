Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759141Ab1JFUDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 16:03:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab1JFUDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 16:03:21 -0400
Date: Thu, 6 Oct 2011 16:03:15 -0400
From: Dave Jones <davej@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: virtualbox tainting.
Message-ID: <20111006200315.GA25681@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Valdis.Kletnieks@vt.edu,
	Greg KH <greg@kroah.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20111006190526.GA13883@redhat.com>
 <20111006194432.GA21642@kroah.com>
 <20111006195007.GA24900@redhat.com>
 <14371.1317930822@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14371.1317930822@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 03:53:42PM -0400, Valdis.Kletnieks@vt.edu wrote:
 > On Thu, 06 Oct 2011 15:50:07 EDT, Dave Jones said:
 > 
 > > I feel a bit dirty overloading TAINT_CRAP (even if the name is apropos).
 > > Should I introduce a TAINT_OUT_OF_TREE perhaps instead ?
 > 
 > That would fix my biggest issue with the patch - it's a slippery slope.  But if
 > we bite the bullet and go straight to the bottom of the slope with an
 > OUT_OF_TREE taint, I'd be happy with that.
 > 
 > Is there a good way to identify at modprobe time if a module is in-tree or
 > out-of-tree?

Not easily from within the kernel. (and doing it in userspace is pointless,
as out of tree modules could just add themselves to the list of 'clean' modules)

We actually used to do something in RHEL a few years ago where we gpg signed the
modules we were building, for pretty much this reason. (also useful for spotting when
for eg, an IHV replaces ext3.ko with their own version in their preloads).

A bit overkill though compared to just having a hardcoded list of offenders in the kernel.

	Dave

