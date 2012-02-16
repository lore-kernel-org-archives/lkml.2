Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab2BPFnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 00:43:47 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:33379 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752361Ab2BPFno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 00:43:44 -0500
Message-ID: <1329371019.5082.9.camel@joe2Laptop>
Subject: Re: [PATCH 4/4] PCI: quirk print dev name with duration
From: Joe Perches <joe@perches.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Date: Wed, 15 Feb 2012 21:43:39 -0800
In-Reply-To: <CAE9FiQUK8m5KKb0or59wH7BD6Eo5ddx9NaF7vszNeR0T3UYMRw@mail.gmail.com>
References: <1329369296-4255-1-git-send-email-yinghai@kernel.org>
	 <1329369296-4255-5-git-send-email-yinghai@kernel.org>
	 <1329369930.5082.4.camel@joe2Laptop>
	 <CAE9FiQUK8m5KKb0or59wH7BD6Eo5ddx9NaF7vszNeR0T3UYMRw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-15 at 21:35 -0800, Yinghai Lu wrote:
> On Wed, Feb 15, 2012 at 9:25 PM, Joe Perches <joe@perches.com> wrote:
> > On Wed, 2012-02-15 at 21:14 -0800, Yinghai Lu wrote:
> >> So could find out which device is involved with the calling
> > []
> >> +++ linux-2.6/drivers/pci/quirks.c
> >> @@ -2854,14 +2854,15 @@ static void do_one_fixup_debug(void (*fn
> >>       ktime_t calltime, delta, rettime;
> >>       unsigned long long duration;
> >>
> >> -     printk(KERN_DEBUG "calling  %pF @ %i\n", fn, task_pid_nr(current));
> >> +     printk(KERN_DEBUG "calling  %pF @ %i for %s\n",
> >> +                     fn, task_pid_nr(current), dev_name(&dev->dev));
> >
> > Might be better to use dev_dbg
> >
> >        dev_dbg(&dev->dev, "calling %pF @ %i\n", fn, task_pid_nr(current));
> >
> > []
> >
> >> -     printk(KERN_DEBUG "pci fixup %pF returned after %lld usecs\n", fn,
> >> -             duration);
> >> +     printk(KERN_DEBUG "pci fixup %pF returned after %lld usecs for %s\n",
> >> +                     fn, duration, dev_name(&dev->dev));
> >
> >        dev_dbg(&dev->dev, "pci fixup %pF returned after %llu usecs\n",
> >                fn, duration);
> 
> Not sure if that is going to break Arjan 's tool that analyze the boot time.

That depends on the tool code.
Either change might break it.
Did you test your change with Arjan's tool?
Do you have a link to the tool?

