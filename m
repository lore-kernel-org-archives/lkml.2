Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab1FFLyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 07:54:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45913 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab1FFLyV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 07:54:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UIP3zu0ah+V0oGn2luXxcTFtGrGa19hVh34MNnWLBVz9gQ7Wu2J7TUy5tL22VTjoUf
         FHMpdUHYlY6mKO8iXMpmUEWqez9/I+N70gk1Qj+xRqhs34uk4XjD4xLhftfAIr+EEY1L
         wVdOfH+Gs2Lrq4dOX4tWlF0nWvE1YMQlQoLRo=
MIME-Version: 1.0
In-Reply-To: <4DECBE44.2070803@unican.es>
References: <4DEA1BA9.7020303@unican.es>
	<4DEA1F22.6000603@unican.es>
	<4DEA255B.2050503@unican.es>
	<4DECBE44.2070803@unican.es>
Date: Mon, 6 Jun 2011 12:54:20 +0100
Message-ID: <BANLkTi=xSJOgY735PE44YtkQmrdhgetGdQ@mail.gmail.com>
Subject: Re: Changing Kernel thread priorities
From: Rolando Martins <rolando.martins@gmail.com>
To: Monica Puig-Pey <puigpeym@unican.es>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I use the following:

PIDs=$(ps -eLo pid,cls,rtprio,pri,nice,cmd | grep -i "irq" | awk '{
print $1; }' | xargs echo)
for i in $PIDs
do
    ret=$(chrt -f -p 99 $i)
done

This will change the kernel thread associated with an irq handler to
RT FIFO prio 99.
Just change the script to your specific interrupt.

Hope it helps,
Rolando

On Mon, Jun 6, 2011 at 12:47 PM, Monica Puig-Pey <puigpeym@unican.es> wrote:
> I am writing a driver which has one kernel thread associated with it.
> I want to change the priority of this thread, so that I can specify the
> order in which it is scheduled following an interrupt.
> I'm using:
>
>  sched_setscheduler(struct task_struct *, int, struct sched_param *);
>
> but it doesn't work. I tried to change the priority from the init_module,
> and also from the Kernel Thread, but there is no way.
>
> Kernel version is 2.6.31-11-rt
>
> What do I call to change a kernel thread priority?
>
> Thanks you very much
>
> Mónica
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
