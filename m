Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab2FYTUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 15:20:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40474 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab2FYTUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 15:20:12 -0400
Date: Mon, 25 Jun 2012 12:20:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: Kay Sievers <kay@vrfy.org>, yuanhan.liu@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] syslog: fill buffer with more than a single message for
 SYSLOG_ACTION_READ
Message-ID: <20120625192007.GA1005@kroah.com>
References: <4FE4AD09020000780008B77F@nat28.tlf.novell.com>
 <CAPXgP13nd7k3v3YGcW9F45L8LhT5tctw64jaooUwQ8=ypfVH+g@mail.gmail.com>
 <4FE829CD020000780008B9DB@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE829CD020000780008B9DB@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 08:05:17AM +0100, Jan Beulich wrote:
> >>> On 23.06.12 at 20:03, Kay Sievers <kay@vrfy.org> wrote:
> >> Furthermore, this patch also addresses the problem dealt with in
> >> commit 4a77a5a06ec66ed05199b301e7c25f42f979afdc ("printk: use mutex
> >> lock to stop syslog_seq from going wild"), so I'd recommend reverting
> >> that one too (albeit there's no direct collision between the two).
> > 
> > Are you sure that is covered? Doesn't the other thread would just
> > return 0 to the caller then, instead of continuing to stay in the
> > syscall when the first thread got the message?
> 
> The old code permitted returning zero in that case too, so I don't
> see why the new code shouldn't be allowed to. But anyway, as
> said this patch doesn't directly conflict, and hence it's up to the
> maintainer(s) of the code to decide whether to keep it. The
> conflicting one, however, imo ought to be reverted in any case.

Ok, so I'm confused, you want me to apply this patch and then revert a
different one?  Which one, 4a77a5a06ec66ed05199b301e7c25f42f979afdc?

Kay, do you agree?

thanks,

greg k-h
