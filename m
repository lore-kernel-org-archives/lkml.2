Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab1FJUtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 16:49:52 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45824 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758004Ab1FJUts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 16:49:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=U8TBrWc72Z5RfBLR5W/65l68bAw+yEa4xsTf5I+m2V1zRenTpGf2jPt/RvW9QdTGxY
         4ZeIdUzObETI3VneqRQTSVzedXefEIq9kih0tw1cW4rYpopx44w4ddtg1L3Wqz4004F2
         LAjESlJ4easmFciXB3yBfGGQMGb/gOhBrWnNY=
MIME-Version: 1.0
In-Reply-To: <4DF1D136.4050903@jp.fujitsu.com>
References: <4df13d2627304cd979@agluck-desktop.sc.intel.com>
	<4DF1D136.4050903@jp.fujitsu.com>
Date: Fri, 10 Jun 2011 13:49:47 -0700
X-Google-Sender-Auth: c1eSlt8I6MjA_l1-YdxzOHPfXVo
Message-ID: <BANLkTi=1nQy03T4LnfHYoB8LBVgFbgaVXA@mail.gmail.com>
Subject: Re: [PATCH 09/10] MCE: run through processors with more severe
 problems first
From: Tony Luck <tony.luck@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
        Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/10 Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>:
> Well, I agree about the point that reordering is required to handle
> shared banks.

Thanks (and thanks for taking the time to look at all of this series
to provide such good feedback)

> I think it is better to put this change in early of the series.

Several of the early parts are position independent w.r.t. each
other - I'm not sure if there is some strong benefit to having
them in any particular order.

> I don't like to have multiple cpumasks here, notably one is just an
> inversion of another...

I wasn't completely thrilled with the way this turned out either.

> How about using severity-leveling?
> Pick cpus with PANIC level first, then AR, AO ...

That sounds like I need even more masks (or lists).

> Or how about checking rip in each mces_seen?

This is equivalent to what I did - but I think the code
will be cleaner. I'll give it a try.

-Tony
