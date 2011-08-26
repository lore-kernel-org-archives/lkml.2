Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab1HZMjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 08:39:51 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41759 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab1HZMjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 08:39:49 -0400
Date: Fri, 26 Aug 2011 16:39:43 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org,
        James Bottomley <jbottomley@parallels.com>, containers@lists.osdl.org,
        Andi Kleen <andi@firstfloor.org>, Nathan Lynch <ntl@pobox.com>,
        LINUXFS-ML <linux-fsdevel@vger.kernel.org>, Zan Lynx <zlynx@acm.org>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [RFC] fs, proc: Introduce the /proc/<pid>/map_files/ directory v2
Message-ID: <20110826123943.GL3903@sun>
References: <20110824111806.GA7191@albatros>
 <20110825082944.GH10030@sun>
 <20110825170147.GM2803@mtj.dyndns.org>
 <20110825170705.GA6387@sun>
 <20110825205426.GO2803@mtj.dyndns.org>
 <20110825211213.GP2803@mtj.dyndns.org>
 <20110825213459.GA1929@sun>
 <20110825213931.GR2803@mtj.dyndns.org>
 <20110826112943.GI3903@sun>
 <20110826122851.GA25853@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110826122851.GA25853@shutemov.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 03:28:51PM +0300, Kirill A. Shutemov wrote:
...
> >  
> > -static int proc_cwd_link(struct inode *inode, struct path *path)
> > +static int proc_cwd_link(struct dentry *dentry, struct inode *inode, struct path *path)
> 
> Put proc_get_link() change in separate patch?
> 

Will do, but let leave it to a final pass, ie when all get agreed on idea and
details, ok? Since I'll be re-sending the final version seraparely anyway.
...
> > +		down_read(&mm->mmap_sem);
> > +
> > +		nr_files = 0;
> > +		for (vma = mm->mmap; vma; vma = vma->vm_next) {
> > +			if (vma->vm_file)
> > +				nr_files++;
> > +		}
> > +		if (!nr_files)
> > +			goto out;
> 
> up_read(&mm->mmap_sem); ?
> 
> > +
> > +		info = kmalloc(nr_files * sizeof(*info), GFP_KERNEL);
> > +		if (!info) {
> > +			ret = -ENOMEM;
> > +			goto out;
> 
> Ditto.
> 

Yeah, thanks Kirill!
