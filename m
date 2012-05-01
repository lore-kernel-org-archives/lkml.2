Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab2EAUzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 16:55:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837Ab2EAUy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 16:54:59 -0400
Subject: Re: x86: runtime waring in pcibios_fwaddrmap_lookup
From: Myron Stowe <mstowe@redhat.com>
To: Meelis Roos <mroos@linux.ee>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <alpine.SOC.1.00.1204280819270.14507@math.ut.ee>
References: <alpine.SOC.1.00.1204122238400.16365@math.ut.ee>
	 <CAErSpo6YnzywdjTTVdVEHj_E-B0ARBpZ+fiy29Rv==fO6m9-FA@mail.gmail.com>
	 <1335557685.2386.62.camel@zim.stowe>
	 <alpine.SOC.1.00.1204280819270.14507@math.ut.ee>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 May 2012 14:54:54 -0600
Message-ID: <1335905694.2386.138.camel@zim.stowe>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-04-28 at 08:36 +0300, Meelis Roos wrote:
> > So, somehow, your system hit the assertion (WARN_ON) in
> > pcibios_fwaddrmap_lookup().  From the dmesg log you provided I can see
> > why pcibios_save_fw_addr() was called - there is a resource collision
> > with the video device's GART - but what I don't understand is how the
> > assertion is being triggered.
> > 
> > There are only two callers of pcibios_fwaddrmap_lookup()
> > (see ./arch/x86/pci/i386.c:: pcibios_save_fw_addr(), and
> > pcibios_retrieve_fw_addr()) and both of those are acquiring the lock
> > before making the call - so triggering the assertion just doesn't seem
> > possible but obviously it is getting triggered.
> > 
> > I don't have any ideas currently but do have some questions that
> > hopefully will start to enlighten us.
> > 
> >         Does your system encounter this consistently upon every boot or
> >         is it hit intermittently?
> 
> Every time.
> 
> >         Do you know of any kernel versions that do not encounter it?
> 
> Checked my logs, no kernel up to 3.3.0 included gave it, next tested 
> kernel was 3.4.0-rc2 and that had the warning and every kernel since has 
> had it.
> 
> >         Are you running a para-virtualized kernel?
> 
> No.

Thanks for the quick response Meelis (unlike myself; I've been consumed
with a hard deadline task recently - sorry).

I got together with Bjorn and after showing him the paths, and locking,
he also did not see how we could be hitting the WARN_ON.  I would like
to take advantage of your system since it encounters this consistently
but really have no idea how to progress currently.  I'll query a couple
of my colleagues for suggestions.  In the meantime, if anyone else -
Jesse - has any ideas, please speak up.

As for you noticing this after 3.3.0 that makes sense as the WARN_ON was
added with 3.3.0.

Myron




