Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab0HQMss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 08:48:48 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64377 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab0HQMsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 08:48:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MX02MPetqeXAZACJrLZfyeGgIhJedTPdB+ms/6CSdiCcWVwCW9Fmpnv7I61Yf1Yyg/
         gvKN2KdN992pi2CjeO5929+LG8qXOiaPEW0wbix42JGcKPvvYQBU4xOeuIkSU0ZmxvGu
         7/56fxuT/nNg2mxTf7b84MrBQVoQiAV+Q2O9s=
Date: Tue, 17 Aug 2010 20:48:39 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix BUG using smp_processor_id() in touch_nmi_watchdog
 and touch_softlockup_watchdog
Message-ID: <20100817124839.GA2838@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20100816133452.GS4879@redhat.com>
 <1281966418.1926.1421.camel@laptop>
 <20100816140829.GA5225@swordfish.minsk.epam.com>
 <20100817025954.GA12366@nowhere>
 <AANLkTikdng247Fct0ANXiitC3ja98_ee3-fUVDGraEwo@mail.gmail.com>
 <20100817083945.GA12022@swordfish.minsk.epam.com>
 <AANLkTik-4S_=L5FLhMfommf5Umd0xO+h4QP9uoxwrgFE@mail.gmail.com>
 <20100817092407.GB12022@swordfish.minsk.epam.com>
 <AANLkTikjR1nC3DYdvSw=FEmAVZ98=ju2RNq-MF1L7U3u@mail.gmail.com>
 <20100817102819.GC12022@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100817102819.GC12022@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 01:28:19PM +0300, Sergey Senozhatsky wrote:
> > So preempt_disable() is redundant here.
> >
> 
> Shouldn't we be for sure not preepmtible when calling __raw_get_cpu_var?

IMHO, it's the caller's responsibility.

> 
> preempt_disable is reduntant here because current_thread_info()->cpu is 
> atomic and we just don't want preempt_(enable|disable) overhead?

Yep.

Thanks,
Yong
