Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab1CWQUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 12:20:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62744 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab1CWQUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 12:20:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 0/7] char/mei: Intel MEI Driver
Date: Wed, 23 Mar 2011 17:20:26 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Weil, Oren jer" <oren.jer.weil@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "david@woodhou.se" <david@woodhou.se>
References: <1300791092-14319-1-git-send-email-oren.jer.weil@intel.com> <F28B59AD52D84B479DCA469824475335065A96C0AD@hasmsx503.ger.corp.intel.com> <20110323160624.GA8972@suse.de>
In-Reply-To: <20110323160624.GA8972@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103231720.27107.arnd@arndb.de>
X-Provags-ID: V02:K0:/sYcm+mLM+UBr3Uryz0uCQwvv2Jp8wxnxAJi+dd6HIy
 yLxy2aiQy3vRvWxu/jczTsbAy8IyWuHjRqgVsElj7as9+/VsCu
 js0M0/0zsAR1Xqpm0xy7VDWUSvhIy0SP1vwfWTmw6aw9/NAGsI
 CUZ+99fzde/RIZNuG1RNAeGRPPeaQ35GmWQU428XiMozopNi9K
 jPQMBQrVh8kGbej447diw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 March 2011, Greg KH wrote:
> On Wed, Mar 23, 2011 at 05:55:47PM +0200, Weil, Oren jer wrote:
> > >> >I suppose one of the important things to do here is integrate the
> > >> >watchdog part into the common watchdog infrastructure in
> > >> >drivers/watchdog. Maybe this driver can export a simple interface to
> > >> >another module that implements the watchdog device?
> > >>
> > >> Yes, this is one the ideas the Alan suggested, we are thinking about
> > >> this direction in the future.
> > >
> > >What's keeping you from doing this now?
> > 
> > We need to change the driver to expose functions to communicate with the FW
> > Client (feature) 
> > From other kernel models, the design for now is only from user space.

For a simple example, look at drivers/watchdog/riowd.c (most other
files in that directory do as well), just replace the riowd_writereg()
function in there with one that calls an exported function from your
hardware. This should really be trivial to do.
 
> So you need to add support to the watchdog infrastructure for this?  For
> some reason I thought you could kick the watchdog from within kernel
> code, did I get this wrong?

A watchdog must be triggered from user space, in Linux we do this by
writing to /dev/watchdog. If you did it from kernel space, the watchdog
would not detect the case where the system is half-broken and still
able to trigger the watchdog, but not do much beyond that.

	Arnd
