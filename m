Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab0CaWUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 18:20:42 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51044 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505Ab0CaWUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 18:20:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sBTaS9LYjiFrRCeWf001s7OG8p2J76QokjNEtd/A1Sv33g/fKr+fW9ovT55fKgZpmD
         U6OkLllHxDKVvdVwEFV7fOwpM2CABePtiZfNq6s3rd2kzjGWkSK1yo/dtUil5N9w0ohO
         9S+P+d+B/mMzAjZtt8+8Gi1Ln8+c6iQAbweVc=
Date: Thu, 1 Apr 2010 00:20:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, Thomas Gleixner <tglx@linutronix.de>,
       jblunck@suse.de, Alan Cox <alan@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
Message-ID: <20100331222040.GG5163@nowhere>
References: <201003242240.54907.arnd@arndb.de> <adazl1ogn0o.fsf@roland-alpha.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adazl1ogn0o.fsf@roland-alpha.cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 03:11:03PM -0700, Roland Dreier wrote:
> Hi Arnd,
> 
> Looking at your tree, I see you have commit 753dd249 ("perf_event: use
> nonseekable_open") that does:
> 
>  > --- a/kernel/perf_event.c
>  > +++ b/kernel/perf_event.c
>  > @@ -2515,6 +2515,8 @@ static int perf_fasync(int fd, struct file *filp, int on)
>  >  }
>  >  
>  >  static const struct file_operations perf_fops = {
>  > +       .open                   = nonseekable_open,
>  > +       .llseek                 = no_llseek,
>  >         .release                = perf_release,
>  >         .read                   = perf_read,
>  >         .poll                   = perf_poll,
> 
> But if I understand this correctly, the assignment to .open is at best
> useless -- these file_operations are only used via anon_inode_getfd()
> and so there is no possible path that can call the .open method.  Or am
> I missing something?
> 
> (The same applies to the kvm_main.c changes too)


Good point, I'll update that.

Thanks.

