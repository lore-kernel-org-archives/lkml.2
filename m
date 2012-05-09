Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761156Ab2EIUmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:42:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56469 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761065Ab2EIUmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:42:14 -0400
Date: Wed, 9 May 2012 13:42:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        fmhess@users.sourceforge.net, abbotti@mev.co.uk
Subject: Re: [PATCH v2] staging: comedi: remove __user annotation inside of
 struct's
Message-ID: <20120509204210.GA22184@kroah.com>
References: <201205090936.03921.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205090936.03921.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 09:36:03AM -0700, H Hartley Sweeten wrote:
> Remove the __user annotations in the struct definitions in
> comedi.h.
> 
> These structs are used to pass information from user-space
> to kernel-space. The copy_from_user and copy_to_user functions
> are used to transfer the data between the address spaces.
> 
> The drivers then use the information internally under the
> assumption that they are kernel-space objects. Having the
> __user annotations inside the structs produces a number of
> sparse warnings of the type:
> 
> warning: dereference of noderef expression
> 
> According to Grek Kroah-Hartman:
> 
> "When the kernel exports .h files, stuff like this should work
> "automatically", so there is no need to not put __user markings."

Wait, for some reason I thought you were adding __user markings, not
removing them from the structures.  That is why I said the above
statement.

Why again are you removing them?  Didn't you just cause more sparse
warnings to pop up?

confused,

greg k-h
