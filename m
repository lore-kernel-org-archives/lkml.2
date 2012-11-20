Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab2KTOrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:47:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51227 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab2KTOru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:47:50 -0500
Date: Tue, 20 Nov 2012 14:47:42 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Constantine Shulyupin <const@MakeLinux.com>, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH v4] checkpatch: debugfs_remove() can take NULL
Message-ID: <20121120144742.GG7955@dm>
References: <1353190818-10070-1-git-send-email-const@MakeLinux.com>
 <20121120142906.GD7955@dm>
 <1353422629.11235.10.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353422629.11235.10.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 06:43:49AM -0800, Joe Perches wrote:
> On Tue, 2012-11-20 at 14:29 +0000, Andy Whitcroft wrote:
> 
> > This all looks sensible, though we still have three blocks doing the
> > same thing.  How about we standardise this check into a single check,
> > generating the capacity from the matched name.
> []
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> []
> > +			if ($line =~ /\b(kfree|usb_free_urb|debugfs_remove(?:_recursive)?)$expr/) {
> > +				my $func = $1;
> > +				my $func_capacity = "NEEDLESS_$1";
> > +
> > +				$func_capacity =~ s/(.$)/\U$1\E/;
> > +
> > +				WARN($func_capacity,
> > +				     "$func(NULL) is safe this check is probably not required\n" . $hereprev);
> 
> Perhaps just
> 				WARN("NEEDLESS_IF",

I would cirtainly be happy with that, I was trying to avoid changing the
capacity for the existing NEEDLESS_KFREE.  If compatibility there isn't
an issue then that makes life even simpler.

-apw
