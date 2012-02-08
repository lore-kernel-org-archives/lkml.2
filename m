Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab2BHR0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 12:26:19 -0500
Received: from vs14.mail.saunalahti.fi ([62.142.117.201]:54639 "EHLO
	vs14.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab2BHR0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 12:26:17 -0500
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Feb 2012 12:26:17 EST
Date: Wed, 8 Feb 2012 19:19:06 +0200 (EET)
From: Kai Makisara <Kai.Makisara@kolumbus.fi>
X-X-Sender: makisara@kai.makisara.local
To: Lee Duncan <lduncan@suse.com>
cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SCSI, st: modify tape driver to allow writing immediate
 filemarks
In-Reply-To: <4F31CAC0.3010905@suse.com>
Message-ID: <alpine.LNX.2.00.1202081910400.6087@kai.makisara.local>
References: <4F31CAC0.3010905@suse.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Feb 2012, Lee Duncan wrote:

> Add an st module option st_nowait_eof which defaults to 0. Setting this
> option to 1 tells the st driver not to wait when writing a filemark, which
> can result in much faster times on streaming tape drives.
> 
> Legacy applications cannot take advantage of the newer MTWEOFI ioctl, so this
> patch gives such applications the ability to write an immediate EOF using the
> normal MTWEOF ioctl if they set st_nowait_eof=1.
> 
> Reference: https://bugzilla.novell.com/show_bug.cgi?id=688996
> 
Is there a real application? I can't open your reference. (Yes, I know 
that this feature can speed up writing dramatically in some cases, but is 
there a case with legacy applications?)

Anyway, I don't think this should be implemented as a pure module option. 
The standard semantics specify that MTWEOF is a synchronization point and 
this module option breaks that for all users.

The driver supports several tape device files with different properties 
that can be set at run-time. Why not implement this as one of the mode 
options? This would allow the "normal" users to use a device file with 
synchronizing MTWEOF and the users needing unsynchronizing MTWEOF would 
use another device file.

The st driver exports the options in sysfs. This is important so that the 
users can check what the options for a device are. This new option should 
also be exported.

Kai
