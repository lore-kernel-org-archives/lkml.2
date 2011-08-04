Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab1HDUZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 16:25:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab1HDUZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 16:25:30 -0400
Date: Thu, 4 Aug 2011 16:25:18 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [patch v2 02/10] kdump: Make kimage_load_crash_segment() weak
Message-ID: <20110804202518.GD429@redhat.com>
References: <20110727125504.491183728@linux.vnet.ibm.com>
 <20110727125807.695225427@linux.vnet.ibm.com>
 <20110801203143.GH3805@redhat.com>
 <1312277403.4881.26.camel@br98xy6r>
 <20110802185530.GH6399@redhat.com>
 <1312368088.3783.40.camel@br98xy6r>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312368088.3783.40.camel@br98xy6r>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 12:41:28PM +0200, Michael Holzheu wrote:
> On Tue, 2011-08-02 at 14:55 -0400, Vivek Goyal wrote:
> > On Tue, Aug 02, 2011 at 11:30:03AM +0200, Michael Holzheu wrote:
> > > Hello Vivek,
> > > 
> > > On Mon, 2011-08-01 at 16:31 -0400, Vivek Goyal wrote:
> > > > On Wed, Jul 27, 2011 at 02:55:06PM +0200, Michael Holzheu wrote:
> > > 
> > > [snip]
> > > 
> > > > > --- a/kernel/kexec.c
> > > > > +++ b/kernel/kexec.c
> > > > > @@ -842,8 +842,8 @@ out:
> > > > >  	return result;
> > > > >  }
> > > > >  
> > > > > -static int kimage_load_crash_segment(struct kimage *image,
> > > > > -					struct kexec_segment *segment)
> > > > > +int __weak kimage_load_crash_segment(struct kimage *image,
> > > > > +				     struct kexec_segment *segment)
> > > > 
> > > > A comment here why we are making it weak should help in increasing
> > > > the code readability.
> > > 
> > > What about the following:
> > > 
> > > /*
> > >  * Load crash segment into memory. Architecture code can override this
> > >  * function. E.g. this is necessary for architectures that do not
> > >  * create page tables for crashkernel memory.
> > >  */
> > > int __weak kimage_load_crash_segment(struct kimage *image,
> > 
> > This looks better.
> 
> With that comment change: Do I get an "Acked-by" for this patch from
> you?

Yes, looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek
