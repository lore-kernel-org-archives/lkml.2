Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab0FBNi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 09:38:59 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:42094 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758075Ab0FBNi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 09:38:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=dDVDE/6ZOFHWqOEEWDJbacPCsuer3c2pCHTbXoer6vwto7gNFwnGRzNaiLyDA3fJsE
         uxUBelMHu8hMcTYpa58zT5N1SwErrQmo4Kt+RqwlO0Qgs7nWWkXWi46z75O9JD6W7kep
         OQwi8zSEjwK8NZVclM6Y9fY29tkEE5mskJLGM=
Date: Wed, 2 Jun 2010 06:39:10 -0700
From: mark gross <640e9920@gmail.com>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: markgross@thegnar.org, Florian Mickler <florian@mickler.org>,
       640e9920@gmail.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Brian Swetland <swetland@google.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100602133910.GA9106@gvim.org>
Reply-To: markgross@thegnar.org
References: <AANLkTik_4ezDAQoAQjkpEgwD9SLKeOjDzy2H7T2v6uCP@mail.gmail.com>
 <Pine.LNX.4.44L0.1005292026080.6300-100000@netrider.rowland.org>
 <AANLkTikxws5kmFhnBO1MLzE65ETka3Jy0R5ayAKTS1Lc@mail.gmail.com>
 <201005312338.55109.rjw@sisk.pl>
 <20100531232617.GF31155@gvim.org>
 <20100601090737.4bc243d9@schatten.dmk.lab>
 <20100601140519.GC1281@gvim.org>
 <AANLkTikF-B23_UWG1O3tlBl4m8NStAJllGhhevNhYZT6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikF-B23_UWG1O3tlBl4m8NStAJllGhhevNhYZT6@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 08:50:02PM -0700, Arve Hjønnevåg wrote:
> On Tue, Jun 1, 2010 at 7:05 AM, mark gross <640e9920@gmail.com> wrote:
> > On Tue, Jun 01, 2010 at 09:07:37AM +0200, Florian Mickler wrote:
> ...
> >> +static void update_target_val(int pm_qos_class, s32 val)
> >> +{
> >> +     s32 extreme_value;
> >> +     s32 new_value;
> >> +     extreme_value = atomic_read(&pm_qos_array[pm_qos_class]->target_value);
> >> +     new_value = pm_qos_array[pm_qos_class]->comparitor(val,extreme_value);
> >> +     if (extreme_value != new_value)
> >> +             atomic_set(&pm_qos_array[pm_qos_class]->target_value,new_value);
> >> +}
> >> +
> >
> > Only works 1/2 the time, but I like the idea!
> > It fails to get the righ answer when constraints are reduced.  But, this
> > idea is a good improvement i'll roll into the next pm_qos update!
> >
> 
> I think it would be a better idea to track your constraints with a
> sorted data structure. That way you can to better than O(n) for both
> directions. If you have a lot of constraints with the same value, it
> may even be worthwhile to have a two stage structure where for
> instance you use a rbtree for the unique values and list for identical
> constraints.

I don't agree, we went through this tree vrs list discussion a few times
before in other areas of the kernel.  Wherever the list tended to be
short, a simple list wins.  However; we can try it, after we have some
metrics and stress test cases identified we can measure its effectivenes
against.

--mgross

