Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab0EZRfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 13:35:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37836 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757184Ab0EZRfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 13:35:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BZz44+U082ZLJIUZ1JEp5uep19BmbMaLBGnqz2D1R7bd35CpPKFqeaczMUiZlgNX1o
         kO4Cr2AQZ1XKVXCn/dc77UjSfW49T8in25g+U+9b5CMvhv89iUDZN5M+/gBXOB0QDdDA
         7jjSwqHpJIVhGRAx4JFsiq/fnXBO7W8pNLJVw=
Date: Wed, 26 May 2010 19:35:16 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Michael Neuling <mikey@neuling.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, shaggy@linux.vnet.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Millton Miller <miltonm@bga.com>, David Gibson <dwg@au1.ibm.com>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [Patch 1/4] Allow arch-specific cleanup before breakpoint
	unregistration
Message-ID: <20100526173515.GE5299@nowhere>
References: <20100526065129.GA3746@in.ibm.com> <20100525083055.342788418@linux.vnet.ibm.com> <20100525091356.GB29003@in.ibm.com> <1274787559_8162@mail4.comsite.net> <4250.1274867681@redhat.com> <20100526171742.GA5563@in.ibm.com> <20100526172314.GD5299@nowhere> <20100526173124.GA8283@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100526173124.GA8283@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 11:01:24PM +0530, K.Prasad wrote:
> On Wed, May 26, 2010 at 07:23:15PM +0200, Frederic Weisbecker wrote:
> > On Wed, May 26, 2010 at 10:47:42PM +0530, K.Prasad wrote:
> > > On Wed, May 26, 2010 at 10:54:41AM +0100, David Howells wrote:
> > > > K.Prasad <prasad@linux.vnet.ibm.com> wrote:
> > > > 
> > > > > > My understanding is weak function definitions must appear in a different C
> > > > > > file than their call sites to work on some toolchains.
> > > > > > 
> > > > > 
> > > > > Atleast, there are quite a few precedents inside the Linux kernel for
> > > > > __weak functions being invoked from the file in which they are defined
> > > > > (arch_hwblk_init, arch_enable_nonboot_cpus_begin and hw_perf_disable to
> > > > > name a few).
> > > > > Moreover the online GCC docs haven't any such constraints mentioned.
> > > > 
> > > > I've seen problems in this area.  gcc sometimes inlines a weak function that's
> > > > in the same file as the call point.
> > > > 
> > > 
> > > We've seen such behaviour even otherwise....even with noinline attribute
> > > in place. I'm not sure if this gcc fix
> > > (http://gcc.gnu.org/bugzilla/show_bug.cgi?id=16922) helped correct the
> > > behaviour, but the lesson has been to not trust a function to be
> > > inlined/remain non-inline consistently.
> > 
> > 
> > If we can't put the call to the function in the same file of its weak
> > definition, then perf is totally screwed.
> > 
> > And in fact it makes __weak basically useless and unusable. I guess
> > that happened in old gcc versions that have been fixed now.
> > 
> > Anyway, I'm personally fine with this patch (you can put my hack
> > if you want).
> >
> 
> I guess you meant "Acked-by:" :-)



Oops, right :)

