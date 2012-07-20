Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab2GTExv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 00:53:51 -0400
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:41897 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab2GTExu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 00:53:50 -0400
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jul 2012 00:53:50 EDT
Date: Fri, 20 Jul 2012 13:44:11 +0900
From: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
To: vgoyal@redhat.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com
Subject: Re: [PATCH] kdump: Append newline to the last lien of vmcoreinfo
 note
Message-Id: <20120720134411.85fd3f731063e43e52092e1a@mxc.nes.nec.co.jp>
In-Reply-To: <20120719134920.GA2761@redhat.com>
References: <20120717173655.GC11031@redhat.com>
	<20120718150439.48360f16.akpm@linux-foundation.org>
	<20120719134920.GA2761@redhat.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

On Thu, 19 Jul 2012 09:49:21 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Wed, Jul 18, 2012 at 03:04:39PM -0700, Andrew Morton wrote:
> > On Tue, 17 Jul 2012 13:36:55 -0400
> > Vivek Goyal <vgoyal@redhat.com> wrote:
> > 
> > > Last line of vmcoreinfo note does not end with \n. Parsing all the lines
> > > in note becomes easier if all lines end with \n instead of trying to special
> > > case the last line.
> > > 
> > > I know atleast one tool, vmcore-dmesg in kexec-tools tree which made the
> > > assumption that all lines end with \n. I think it is a good idea to
> > > fix it.
> > > 
> > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > > ---
> > >  kernel/kexec.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > Index: linux-2.6/kernel/kexec.c
> > > ===================================================================
> > > --- linux-2.6.orig/kernel/kexec.c	2012-07-17 19:26:38.844033784 -0400
> > > +++ linux-2.6/kernel/kexec.c	2012-07-17 23:51:33.311701781 -0400
> > > @@ -1424,7 +1424,7 @@ static void update_vmcoreinfo_note(void)
> > >  
> > >  void crash_save_vmcoreinfo(void)
> > >  {
> > > -	vmcoreinfo_append_str("CRASHTIME=%ld", get_seconds());
> > > +	vmcoreinfo_append_str("CRASHTIME=%ld\n", get_seconds());
> > >  	update_vmcoreinfo_note();
> > >  }
> > 
> > huh, that was a screwup.  And now we have to make what must be
> > viewed as a non-back-compatible ABI change.
> > 
> > Ho hum, presumably there isn't a lot of code out there which is
> > dependent upon a non-newline-terminated CRASHTIME record.
> 
> I think so. AFAIK, makedumpfile (vmcore filtering utility) is only
> user of CRASHTIME=.
> 
> > 
> > Why did this work at all, anyway?  Is CRASHTIME always the last-emitted
> > record?
> 
> Yes, CRASHTIME= is always the last emitted line in vmcoreinfo note.
> 
> I had a quick look at makedumpfile code and looks like they read the whole
> note, dump it to a file and then do fgets() on the file in a loop. As it is
> last line in the file, fgets encounters EOF and reads the CRASHTIME= line
> successfully. So even after this change makedumpfile should remain
> unaffected. 
> 
> CCing makedumpfile maintainer, Atsushi Kumagai.

As you said, makedumpfile reads VMCOREINFO line by line with fgets().
So, it's OK that the end of the last line is whether \n or EOF.

Therefore, this change doesn't affect makedumpfile. 


Thanks
Atsushi Kumagai
