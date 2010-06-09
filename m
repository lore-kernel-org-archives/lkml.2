Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256Ab0FIUrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 16:47:35 -0400
Received: from www.tglx.de ([62.245.132.106]:50890 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756739Ab0FIUre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 16:47:34 -0400
Date: Wed, 9 Jun 2010 22:47:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: =?ISO-8859-15?Q?Ortwin_Gl=FCck?= <odi@odi.ch>,
       linux-kernel@vger.kernel.org
Subject: Re: freeze when strace X
In-Reply-To: <20100609200610.GA27536@srcf.ucam.org>
Message-ID: <alpine.LFD.2.00.1006092232180.2933@localhost.localdomain>
References: <4C0FDF9F.9070000@odi.ch> <20100609195228.GA27088@srcf.ucam.org> <4C0FF34D.6090800@odi.ch> <20100609200610.GA27536@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-846436559-1276116444=:2933"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-846436559-1276116444=:2933
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 9 Jun 2010, Matthew Garrett wrote:

> On Wed, Jun 09, 2010 at 10:02:21PM +0200, Ortwin Glück wrote:
> > On 09.06.2010 21:52, Matthew Garrett wrote:
> > > Just to make sure, you're not trying to strace X from within X, are you?
> > 
> > Oh... now that you mention it... Is that a silly thing to do?
> > strace X from a different terminal works fine :-)
> > 
> > But freezing the system because of that? I mean an error message, log, anything
> > would be "nice".
> 
> strace needs to output text via X, which generates output which needs to 
> be output via X... and you'll tend to deadlock. If X is holding any 
> interesting kernel locks at that point then it wouldn't surprise me if 
> the machine ends up dead.

Nothing to do with kernel locks. strace hooks into the syscall and
intercepts the data, so X is stopped at that point. Now try to send
output to a program which you stopped yourself :)

Thanks,

	tglx
--8323328-846436559-1276116444=:2933--
