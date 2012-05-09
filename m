Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317Ab2EIP5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:57:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57192 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297Ab2EIP45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:56:57 -0400
Date: Wed, 9 May 2012 08:56:53 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: comedi: remove __user annotation inside of
 struct's
Message-ID: <20120509155653.GA23058@kroah.com>
References: <201205081641.00358.hartleys@visionengravers.com>
 <ADE657CA350FB648AAC2C43247A983F0020698A1774D@AUSP01VMBX24.collaborationhost.net>
 <4FAA44D7.1040209@mev.co.uk>
 <20120509142436.GC11695@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F0020698A17862@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020698A17862@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 10:52:34AM -0500, H Hartley Sweeten wrote:
> On Wednesday, May 09, 2012 7:25 AM, gregkh@linuxfoundation.org wrote:
> > On Wed, May 09, 2012 at 11:20:07AM +0100, Ian Abbott wrote:
> >> On 2012-05-09 00:55, H Hartley Sweeten wrote:
> >>> On Tuesday, May 08, 2012 4:41 PM, H Hartley Sweeten wrote:
> >>>>
> >>>> The structs' comedi_insn, coomedi_insnlist, comedi_cmd,
> >>>> comedi_chaninfo, and comedi_rangeinfo are all passed to
> >>>> the kernel from user space using ioctl commands. They
> >>>> are then copied to kernel space using copy_from_user()
> >>>> before the data is passed to the drivers.
> >>>>
> >>>> The __user annotation should not be used with variables
> >>>> inside the struct. This produces a lot of sparse warnings
> >>>> like:
> >>>>
> >>>>warning: dereference of noderef expression
> >>>>
> >>>> Signed-off-by: H Hartley Sweeten<hsweeten@visionengravers.com>
> >>>> Cc: Ian Abbott<abbotti@mev.co.uk>
> >>>> Cc: Mori Hess<fmhess@users.sourceforge.net>
> >>>> Cc: Greg Kroah-Hartman<gregkh@linuxfoundation.org>
> >>>>
> >>>> ---
> >>>>
> >>>> Note: This patch exposes some new warnings about different
> >>>> address space. These will be addressed.
> >>>
> >>> Please ignore this patch.
> >>>
> >>> It appears the annotations in the struct definitions are correct.
> >> 
> >> Personally, I think you were on the mark with the patch.  It's
> >> better to avoid using __user in comedi.h so it can be used as-is in
> >> user-space. All of the structures in comedi.h are used in user-space
> >> (although Comedilib uses its own version of comedi.h without all the
> >> typedef eliminations that have been done in "staging") and some of
> >> them are also deep-copied into kernel-space objects of the same
> >> type, where the pointers in the structs would no longer be
> >> user-space pointers.
> >
> > When the kernel exports .h files, stuff like this should work
> > "automatically", so there is no need to not put __user markings.
> >
> > So please, yes, continue to work to get this correct, it is very
> > essencial to ensure we don't mess stuff up.
> 
> Greg,
> 
> Based on the discussion I assume this patch is ok then. Do you
> want me to repost it?

Sure, I'll review it with the other patches you have sent later today.

> I'll work on fixing the other issues with the user <-> kernel transitions.

Wonderful, thanks for the work you are doing on this code, it's greatly
appreciated.

greg k-h
