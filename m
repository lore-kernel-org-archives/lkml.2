Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab1BAKqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 05:46:12 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:43625 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab1BAKqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 05:46:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=agB1jhcODTxj2rqUJnifR6qXF8pU/hREsDJIL6XR4f4hfrh6+IvG2j5ZoQ4XIoHT4v
         888FnCM+UHiCPSu6HL6yvMqUHk8Y7CU0IowLgwy80IVApSMSoM0nyPCD6hDCHiMANL+k
         58KM7pUwKUhNugaeOlsqjYXZM9j2ItNGEbRoU=
Date: Tue, 1 Feb 2011 18:46:02 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Kazuhisa Ichikawa <ki@epsilou.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: Why one of the 2 patches to fix "autogroup" sched problem on
 UP machines is missing in -rc3?
Message-ID: <20110201104602.GA3397@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <AANLkTikYw73nixqMtNSDzus2M5RCN2Zy4PzfbPAxtTBC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTikYw73nixqMtNSDzus2M5RCN2Zy4PzfbPAxtTBC@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 06:05:23PM +0900, Kazuhisa Ichikawa wrote:
> Hi Yong,
> 
> Now 2.6.38-rc3 is out, and I think one of the 2 patches you wrote to
> fix "autogroup" sched problem on UP machines is missing there.

Actually the merged one hide the initialising problem.
Because when we enqueue a process to an empty group, update_cfs_shares()
will be called, thus tg->se->load is updated.
enqueue_task_fair()
  update_cfs_shares()
    reweight_entity()
      update_load_set()

> 
> More precisely, your first patch for kernel/sched.c (titled:?sched:
> tg->se->load should be initialised to tg->shares) is missing, while
> the second one for kernel/sched_fair.c (titled:?sched: Fix poor
> interactivity on UP systems due to group scheduler nice tune bug) is
> in -rc3.

See my above answer.

> 
> So what happened to the first patch? Was it superseded and made
> obsolete by the second patch?

Yes.

> 
> # Sorry for not replying to your original post. I'm not subscribing to
> linux kernel mailing list.

Thanks for taking care of this issue :)

Thanks,
Yong
