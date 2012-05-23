Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab2EWU1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 16:27:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65089 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab2EWU1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 16:27:03 -0400
Date: Wed, 23 May 2012 13:26:57 -0700
From: Tejun Heo <tj@kernel.org>
To: =?iso-8859-1?Q?J=F6rg-Volker?= Peetz <jvpeetz@web.de>
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: Re: Linux 3.4 released
Message-ID: <20120523202657.GB3933@htj.dyndns.org>
References: <CA+55aFwaobhbBZkE1LTyQJYhk8w8zk-cyOXXuXfPyE=BXzT3PA@mail.gmail.com>
 <4FBBB11D.7020904@web.de>
 <20120522155345.GC14339@google.com>
 <4FBBC461.4060008@web.de>
 <20120522170320.GD14339@google.com>
 <jpglns$1uj$1@dough.gmane.org>
 <CAOS58YPMh_hbJ4a49j4p9H68n8U1LzMUuaxmHx57gVTkmfxF6A@mail.gmail.com>
 <4FBBEDF2.8060803@web.de>
 <20120523182457.GD18143@google.com>
 <4FBD40F4.4090201@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FBD40F4.4090201@web.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc'ing Takashi.  Hi!

On Wed, May 23, 2012 at 09:56:36PM +0200, Jörg-Volker Peetz wrote:
> May 23 21:32:33 hostname kernel: XXX delayed_work_timer_fn: cwq
> (null), fn=hdmi_repoll_eld

So, we have the winner.

Takashi, sound/pci/hda/patch_hdmi.c::hdmi_repoll_eld() is causing
workqueue code dereference %NULL pointer.  It *looks* like something
is corrupting the work item while it's queued.  It could be a
workqueue bug but I don't think that's likely - the code has been
stable for quite some time now.  I glanced through the code and
nothing stands out.  Does something ring a bell?

> (without line-break).
> 
> By the way, don't know if this is related, I have a phenomenon with a spurious
> interrupt with every linux version I've used before on this notebook. Half a
> minute after starting the system the computer produces approx. 220 lines like
> 
> ... kernel: hda-intel: spurious response 0x0:0x0, last cmd=0x170503
> 
> Now with 3.4.0, I see an additional message right before (the minute before) the
> "XXX ..." line:
> 
> ...kernel: hda_intel: azx_get_response timeout, switching to single_cmd mode:
> last cmd=0x003f0900

These too seem to be for you, Takashi. :)

Thanks.

-- 
tejun
