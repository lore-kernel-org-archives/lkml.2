Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617Ab0FPHYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 03:24:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294Ab0FPHY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 03:24:29 -0400
Message-ID: <4C187C22.2080505@redhat.com>
Date: Wed, 16 Jun 2010 10:24:18 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Really lazy fpu
References: <1276441427-31514-1-git-send-email-avi@redhat.com>
In-Reply-To: <1276441427-31514-1-git-send-email-avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2010 06:03 PM, Avi Kivity wrote:
> Currently fpu management is only lazy in one direction.  When we switch into
> a task, we may avoid loading the fpu state in the hope that the task will
> never use it.  If we guess right we save an fpu load/save cycle; if not,
> a Device not Available exception will remind us to load the fpu.
>
> However, in the other direction, fpu management is eager.  When we switch out
> of an fpu-using task, we always save its fpu state.
>
> This is wasteful if the task(s) that run until we switch back in all don't use
> the fpu, since we could have kept the task's fpu on the cpu all this time
> and saved an fpu save/load cycle.  This can be quite common with threaded
> interrupts, but will also happen with normal kernel threads and even normal
> user tasks.
>
> This patch series converts task fpu management to be fully lazy.  When
> switching out of a task, we keep its fpu state on the cpu, only flushing it
> if some other task needs the fpu.
>    

Ingo, Peter, any feedback on this?

-- 
error compiling committee.c: too many arguments to function

