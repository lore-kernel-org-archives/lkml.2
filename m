Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab0HXMuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 08:50:10 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:55715 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab0HXMuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 08:50:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NoAEs3gPd4GOcHSul8rKXuafck7gni2wIjweEEj/6SXnVZEwrU3pdF6Ti6+P9oMGDV
         YGFq5z9d2CDLPCT8YAxi+MXWMv1/5oG1kU4UphaIQbriab4FTybXAIEAiW65odn+0FWf
         +Eg6APZYV8u2RJUBUq4Vf2S6KC9iPxUUi/7SY=
Date: Tue, 24 Aug 2010 20:49:58 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, mingo@elte.hu, peterz@infradead.org
Subject: Re: [RFC PATCH 1/3] timer: fix comments of try_to_del_timer_sync()
Message-ID: <20100824124958.GA3070@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1282633129-9187-1-git-send-email-yong.zhang0@gmail.com>
 <1282633129-9187-2-git-send-email-yong.zhang0@gmail.com>
 <20100824121109.GA13061@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100824121109.GA13061@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 02:11:09PM +0200, Oleg Nesterov wrote:
> On 08/24, Yong Zhang wrote:
> >
> > From: Yong Zhang <yong.zhang@windriver.com>
> >
> > In commit fd450b7318b75343fd76b3d95416853e34e72c95, it was saying
> > try_to_del_timer_sync() can be used in interrupt context.
> 
> Yes, but not in UP case.

Yeah, but in UP case there is no try_to_del_timer_sync(), it's redefined
to del_timer().

> 
> Please remove "#ifdef CONFIG_SMP" from set_running_timer(), then iirc
> it can be used from irq.

I have noticed your comments in the commit log, but I think it's about
introducing the same semantic of try_to_del_timer_sync() on UP as well
as SMP. But this patch is focusing on the current code(SMP special).
Not about realizing try_to_del_timer_sync() on UP case. Do we need
to do that?

Thanks,
Yong
