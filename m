Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab1HADHv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 23:07:51 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:59728 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab1HADHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 23:07:44 -0400
Date: Mon, 1 Aug 2011 12:37:38 +0930
From: Christopher Yeoh <cyeoh@au1.ibm.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Cross Memory Attach v4
Message-ID: <20110801123738.6fd2205c@lilo>
In-Reply-To: <CAM9Y=f4p6Ch4u88K3eykoL_GjNiitJnD_OSOexKGBuXC58x_tQ@mail.gmail.com>
References: <CAM9Y=f4p6Ch4u88K3eykoL_GjNiitJnD_OSOexKGBuXC58x_tQ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Aug 2011 10:06:31 +0800
Daniel J Blueman <daniel.blueman@gmail.com> wrote:

> On Jul 27, 11:30 am, Christopher Yeoh <cyeoh@au1.ibm.com> wrote:
> > Hi Andrew,
> >
> > Here's an updated version of the Cross Memory Attach patch. Changes
> > since the v3:
> >
> > - Adds x86_64 specific wire up
> > - Changes behaviour so process_vm_readv and process_vm_writev return
> >   the number of bytes successfully read or written even if an error
> >   occurs
> > - Adds more kernel doc interface comments
> > - rename of some internal functions (process_vm_rw_check_iovecs,
> >   process_vm_rw) so they make more sense.
> >
> > Still need to do benchmarking to see if the optimisation for small
> > copies using a local on-stack array in process_vm_rw_core is worth
> > it.
> []
> 
> A bit late to the party.
> 
> get_user_pages_fast may be a nice win here, since the pages will
> almost always be present; it'll backoff to the locked get_user_pages
> path to handle the pathological case of swapped pages.

Can't use get_user_pages_fast here as in this case we want to get pages
from a different process.

Chris
-- 
cyeoh@au.ibm.com
