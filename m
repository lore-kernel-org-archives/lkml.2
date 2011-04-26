Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab1DZCsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 22:48:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42366 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757481Ab1DZCs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 22:48:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=fN7AOLHGVs/qgV8YIMlRT6Yvfn710H45MEsUBM5Ubuj/z0rrca8Ji7uRUr7XG5C3Ko
         VV2YCscok98kKFoFK1Pv2QiV5rXL39hOMrz/y+VAdyIk6k93+Vuvm+fUJO7VIrxLMxfI
         oikSHLPHM4vMMjurLfRuu0W2gUgOTBi7TJG+I=
Date: Tue, 26 Apr 2011 10:48:10 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Jiri Kosina <trivial@kernel.org>
Subject: Re: [TRIVIAL PATCH] treewide: Cleanup continuations and remove
 logging message whitespace
Message-ID: <20110426024807.GA2751@gmail.com>
Mail-Followup-To: Randy Dunlap <randy.dunlap@oracle.com>,
	linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
	Jiri Kosina <trivial@kernel.org>
References: <65136ab68431de0cc0c554663cee33fc9d4a9850.1303615717.git.joe@perches.com>
 <20110425082230.6d656ed0.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110425082230.6d656ed0.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 08:22:30AM -0700, Randy Dunlap wrote:
> On Sat, 23 Apr 2011 20:38:19 -0700 Joe Perches wrote:
> 
> > Using C line continuation inside format strings is error prone.
> > Clean up the unintended whitespace introduced by misuse of \.
> > Neaten correctly used line continations as well for consistency.
> > 
> > drivers/scsi/arcmsr/arcmsr_hba.c has these errors as well,
> > but arcmsr needs a lot more work and the driver should likely be
> > moved to staging instead.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
>
Acked-by: Harry Wei <harryxiyou@gmail.com>
> 
> 
> Joe,
> Is there a decent fix for this warning in linux-next:
> 
> drivers/tty/n_gsm.c:535: warning: zero-length gnu_printf format string
Hi Randy & Joe,
   I have seen the drivers/tty/n_gsm.c. 
>From line 529 to line 540 in drivers/tty/n_gsm.c like following.

529 static void hex_packet(const unsigned char *p, int len)
530 {
531	int i;
532	for (i = 0; i < len; i++) {
533		if (i && (i % 16) == 0) {
534			pr_cont("\n");
535			pr_debug("");                                                                      
536		}
537		pr_cont("%02X ", *p++);
538	}
539	pr_cont("\n");
540 }

Should we need the line 535? If true, i wanna the function of 
'pr_debug("");'

Thanks.
Harry Wei.
