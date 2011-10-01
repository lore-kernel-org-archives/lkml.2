Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab1JATZQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 15:25:16 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:58151 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756726Ab1JATZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 15:25:09 -0400
X-Sasl-enc: Clu8stS1TNZW/VnMpGCSKFZlyRPPQvsUPO2rmj/fY2yl 1317497107
Date: Sat, 1 Oct 2011 12:24:38 -0700
From: Greg KH <greg@kroah.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Andy <akwatts@ymail.com>, schwab@linux-m68k.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: hints on how to check your machine for
 intrusion
Message-ID: <20111001192438.GA22938@kroah.com>
References: <4E8655CD.90107@zytor.com>
 <20110930235924.GA25176@kroah.com>
 <20111001141751.GA8937@zeus>
 <20111001142848.GA27058@kroah.com>
 <20111001165659.GB18690@1wt.eu>
 <20111001171916.GA11989@zeus>
 <20111001175456.GC18690@1wt.eu>
 <20111001184044.GA13608@zeus>
 <20111001190612.GA14779@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111001190612.GA14779@1wt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 09:06:12PM +0200, Willy Tarreau wrote:
> On Sat, Oct 01, 2011 at 01:40:44PM -0500, Andy wrote:
> > On Sat, Oct 01, 2011 at 07:54:56PM +0200, Willy Tarreau wrote:
> > >   $ git config tar.umask 022
> > 
> > Andreas/Willy:
> > 
> > It was indeed umask which was skewing the results. Thanks.
> > 
> > Now, I'll wait for Willy's hashes since I can't drill down on
> > Linus' 2.6 tree beyond 2.6.x.
> 
> OK I'm attaching two files, one computed with the initial 002 perms and
> a second one with the new 022 perms. I don't precisely know when the perms
> changed, hence the two files. I noticed that 2.6.25 was still 002, and that
> 2.6.32 was 022. In between I don't know. Note that I'm missing some tags
> (at least 2.6.35.12 and a few 2.6.33.x and 2.6.34.x).
> 
> The file is formated to be easily used with "md5sum -c" that dirty way
> (once hashes are split/joined at the location where the umask changed) :
> 
>   cd /path/to/mirror/2.6
>   cp linux-*.tar.gz /tmp
>   cd /tmp
>   gunzip linux-*.tar.gz
>   md5sum -c expected-hashes.md5
> 
> It would be nice if someone with an access to a mirror could check the
> perms of *every* tarball so that we can establish the definitive list
> of signatures. I'm pretty sure the umask history is not linear. For
> instance, I'm pretty sure I did not change the umask in my config when
> releasing 2.6.27.x kernels and it seems like Greg did not do this either
> so we have 2.6.27 022 and 2.6.27.x 002. Something like this might do it
> (untested) :
> 
>   for i in linux-*.tar.gz; do
>     set -- $(tar tvf $i|head -1)
>     [ "$1" == "drwxrwxr-x" ] && echo "$i 002" || echo "$i 022"
>   done
> 
> Hoping this helps a bit.

Very nice, thanks so much for providing an independant verification of
the tarballs, it is much appreciated.

And yes, the umask problem did trip us up when we did the initial
verification as well, fun to see that you all figured out and solved the
problem faster than I did :)

thanks again,

greg k-h
