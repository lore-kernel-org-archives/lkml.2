Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab1INTPB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 15:15:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42695 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306Ab1INTPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 15:15:00 -0400
Date: Wed, 14 Sep 2011 23:14:17 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] mm: restrict access to /proc/slabinfo
Message-ID: <20110914191417.GA15936@albatros>
References: <20110910164001.GA2342@albatros>
 <20110910164134.GA2442@albatros>
 <1316025701.4478.65.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316025701.4478.65.camel@nimitz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 11:41 -0700, Dave Hansen wrote:
> On Sat, 2011-09-10 at 20:41 +0400, Vasiliy Kulikov wrote:
> > @@ -4584,7 +4584,8 @@ static const struct file_operations proc_slabstats_operations = {
> >  
> >  static int __init slab_proc_init(void)
> >  {
> > -       proc_create("slabinfo",S_IWUSR|S_IRUGO,NULL,&proc_slabinfo_operations);
> > +       proc_create("slabinfo", S_IWUSR | S_IRUSR, NULL,
> > +                   &proc_slabinfo_operations);
> >  #ifdef CONFIG_DEBUG_SLAB_LEAK
> >         proc_create("slab_allocators", 0, NULL, &proc_sla 
> 
> If you respin this, please don't muck with the whitespace.

OK, I was just removing checkpatch warnings.

>  Otherwise,
> I'm fine with this.  Distros are already starting to do this anyway in
> userspace.
> 
> Reviewed-by: Dave Hansen <dave@linux.vnet.ibm.com>

Thank you!

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
