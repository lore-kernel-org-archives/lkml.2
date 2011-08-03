Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab1HCKlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 06:41:42 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:36855 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab1HCKlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 06:41:37 -0400
Subject: Re: [patch v2 02/10] kdump: Make kimage_load_crash_segment() weak
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20110802185530.GH6399@redhat.com>
References: <20110727125504.491183728@linux.vnet.ibm.com>
	 <20110727125807.695225427@linux.vnet.ibm.com>
	 <20110801203143.GH3805@redhat.com> <1312277403.4881.26.camel@br98xy6r>
	 <20110802185530.GH6399@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Wed, 03 Aug 2011 12:41:28 +0200
Message-ID: <1312368088.3783.40.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-02 at 14:55 -0400, Vivek Goyal wrote:
> On Tue, Aug 02, 2011 at 11:30:03AM +0200, Michael Holzheu wrote:
> > Hello Vivek,
> > 
> > On Mon, 2011-08-01 at 16:31 -0400, Vivek Goyal wrote:
> > > On Wed, Jul 27, 2011 at 02:55:06PM +0200, Michael Holzheu wrote:
> > 
> > [snip]
> > 
> > > > --- a/kernel/kexec.c
> > > > +++ b/kernel/kexec.c
> > > > @@ -842,8 +842,8 @@ out:
> > > >  	return result;
> > > >  }
> > > >  
> > > > -static int kimage_load_crash_segment(struct kimage *image,
> > > > -					struct kexec_segment *segment)
> > > > +int __weak kimage_load_crash_segment(struct kimage *image,
> > > > +				     struct kexec_segment *segment)
> > > 
> > > A comment here why we are making it weak should help in increasing
> > > the code readability.
> > 
> > What about the following:
> > 
> > /*
> >  * Load crash segment into memory. Architecture code can override this
> >  * function. E.g. this is necessary for architectures that do not
> >  * create page tables for crashkernel memory.
> >  */
> > int __weak kimage_load_crash_segment(struct kimage *image,
> 
> This looks better.

With that comment change: Do I get an "Acked-by" for this patch from
you?

Michael

