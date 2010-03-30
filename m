Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab0C3Guq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 02:50:46 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:61511 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab0C3Guo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 02:50:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=RH6es/K6Jmjq8p9Zq8NKnKZM4HfOT8GRblSwnQOjMF4a5s1ngegKnd/uP2Mt4FTYot
         TnF7iZU5rV/WnGTCIr/swVewPEO9GEb0vlE/2WnrE/5zt3DVkHlH+m5kFb+aZ4O78P5g
         vLzMRyCVCKFK1xjrh/ZV0GdgZjdAXwCYv2KiY=
Date: Tue, 30 Mar 2010 08:50:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/6] procfs: Kill BKL in llseek on proc base
Message-ID: <20100330065046.GA22419@nowhere>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <1269930015-863-2-git-send-regression-fweisbec@gmail.com> <b6fcc0a1003292340w3452b4c3wc25282811365c7ef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b6fcc0a1003292340w3452b4c3wc25282811365c7ef@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 09:40:24AM +0300, Alexey Dobriyan wrote:
> On Tue, Mar 30, 2010 at 9:20 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > --- a/fs/proc/base.c
> > +++ b/fs/proc/base.c
> > @@ -728,6 +728,7 @@ out_no_task:
> >
> >  static const struct file_operations proc_info_file_operations = {
> >        .read           = proc_info_read,
> > +       .llseek         = generic_file_llseek,
> 
> There is no warning for default default_llseek case.
> This should be done same way as proc ioctls.


I don't think we should. We have overriden the llseek for
the procfs users located in the proc core (just fs/proc)
but we haven't touched all of the external users, and since
there are hundreds of them, I guess a lot don't implement
llseek.

We would need to first override those that are visible upstream
and warn for the further ones after this step only.

