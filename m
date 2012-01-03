Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab2ACBIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 20:08:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43966 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab2ACBIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 20:08:30 -0500
Date: Tue, 3 Jan 2012 02:08:26 +0100
From: Jan Kara <jack@suse.cz>
To: Jorge Bastos <mysql.jorge@decimal.pt>
Cc: "'Jan Kara'" <jack@suse.cz>, linux-kernel@vger.kernel.org,
        reiserfs-devel@vger.kernel.org, haiyangz@microsoft.com,
        hjanssen@microsoft.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Reiserfs.c bug in 3.2-rc5
Message-ID: <20120103010826.GF3626@quack.suse.cz>
References: <43556.213.228.140.150.1323560920.squirrel@webmail.decimal.pt>
 <20111213180707.GI11747@quack.suse.cz>
 <!&!AAAAAAAAAAAYAAAAAAAAAKCACr8ZwetPrGXZsycJodKihAAAEAAAAGPJDX4w3wxIo8Onu2+q/xMBAAAAAA==@decimal.pt>
 <20120102115222.GA3626@quack.suse.cz>
 <005301ccc998$201c9da0$6055d8e0$@jorge@decimal.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <005301ccc998$201c9da0$6055d8e0$@jorge@decimal.pt>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Mon 02-01-12 21:47:29, Jorge Bastos wrote:
> > > No SELinux, the only change is from 3.1.1 to 3.2-rc5.
> > > Tried the new 3.2-rc7 and the problem persists.
> >   OK, so do I understand right that 3.1.1 is OK but 3.2-rc5/rc7 have
> > the problem?
> > 
> > > Is there a way that the ReiserFS people can commit the fix?
> >   Sure, we just have to find where the problem is. Can you please run
> > with the attached debugging patch applied and send me kernel output
> > when the system crashes? Thanks.
> 
> Yes, till 3.1.6 everything works, with 3.2-rc7 (or rc5) it doesn't.
> 
> Here are the images with the output, I can't copy the text since this is a
> VM.
> 
> http://neotrix.decimal.pt/bugs/reiserfs_1.jpg
> http://neotrix.decimal.pt/bugs/reiserfs_2.jpg
> http://neotrix.decimal.pt/bugs/reiserfs_3.jpg
> http://neotrix.decimal.pt/bugs/reiserfs_4.jpg 
> 
> Does this help? If not let me know further instructions.
  Yes, thanks! So we see that reiserfs_security_init() returned bogus
number 790797. This is caused by security_old_inode_init_security() either
returning some bogus number or setting sec->length to something bogus. In
any case it's some security module problem so I'm adding Mimi Zohar who did
the changes in this code recently to CC. I'm also adding Rafael since this
is a regression.

  Also I think he might use your kernel config so can you please send it?
Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
