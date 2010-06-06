Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab0FFIA0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 04:00:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58006 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab0FFIAY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 04:00:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=IpwCa8atmB3g/rqi8EvDzZvPGPHwVftCgT032ap1OCjoLPCOC1mlkJzZQm/7IkIuzK
         sbPvE4GmnzeStmDPvgJxx4SVwXRnE2zXKqQFJ5hD0zvuqkf42HEDFqLb+WS2Nps1Wgmq
         7KPOR/+r49ac/ybn5N/fM0C8JhlE9wlqug5rE=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Subject: Re: wait_even_interruptible_timeout(), signal, spin_lock() = system hang
Date: Sun, 6 Jun 2010 10:00:19 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.4; i686; ; )
Cc: linux-kernel@vger.kernel.org,
       "linux-fsdevel" <linux-fsdevel@vger.kernel.org>
References: <AANLkTiliRFydAhxH2-Dp1RKuz6sq7vgWIcMvLMi68ftg@mail.gmail.com>
In-Reply-To: <AANLkTiliRFydAhxH2-Dp1RKuz6sq7vgWIcMvLMi68ftg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006061000.19503.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=16139
for your bug report, please add your address to the CC list in there, thanks!

On piątek, 28 maja 2010 o 18:44:46 Shirish Pargaonkar wrote:
> After this sequence of calls, system hangs (smp, x86 box based with
> .34 kernel), can ping only.
> I have not been able to break in with Alt Sysrq t, working on that
> 
>         rc = wait_event_interruptible_timeout(ses->server->response_q,
>                         (midQ->midState != MID_REQUEST_SUBMITTED),
>  timeout); if (rc < 0) {
>                 cFYI(1, ("command 0x%x interrupted", midQ->command));
>                 return -1;
>         }
> 
> and when function that invoking function after coming out with ERESTARTSYS
> (I kill the command with Ctrl C) calls
>  spin_lock(&GlobalMid_Lock);
> 
> system hangs.  If I sleep before return -1 (e.g. msleep(1), no hang)
> 
> I do not have to use wait_event_interruptible_timeout and no such problems
>  with wait_event_timeout, it is only when signal/interrupt is involved, I
>  run into this problem
> 
> Any pointers/ideas what could be happening, would be really really
>  appreciated.
> 
> Regards,
> 
> Shirish
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
