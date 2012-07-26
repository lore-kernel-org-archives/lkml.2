Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab2GZKtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 06:49:35 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46654 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868Ab2GZKte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 06:49:34 -0400
Date: Thu, 26 Jul 2012 14:49:29 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 2/7] procfs: Convert /proc/pid/fdinfo/ handling routines
 to seq-file
Message-ID: <20120726104929.GC26471@moon>
References: <20120725094718.089879534@openvz.org>
 <20120725095024.760705388@openvz.org>
 <50111F36.6000407@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50111F36.6000407@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 02:43:02PM +0400, Pavel Emelyanov wrote:
> On 07/25/2012 01:47 PM, Cyrill Gorcunov wrote:
> > This patch converts /proc/pid/fdinfo/ handling routines to seq-file which
> > is needed to extend seq operations and plug in auxiliary fdinfo provides
> > from subsystems like eventfd/eventpoll/fsnotify.
> > 
> > Note the proc_fd_link no longer call for proc_fd_info, simply because
> > proc_fd_info is converted to seq_fdinfo_open (which is seq-file open()
> > prototype), moreover in further patches I need to provide two seq_fdinfo_open
> > variants -- one with CONFIG_CHECKPOINT_RESTORE and one without this
> > symbol. All in one -- this will look more messy then.
> 
> This is something I'm really not happy with :( After the set applied we will
> have one former proc_fd_info being splitted into 3 (three!) functions doing
> the same (with flavors).
> 
> For me it's better to fix this, otherwise conversion to seq-file looks OK.

OK, thanks for review! I'll try to fix it up.

	Cyrill
