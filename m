Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752Ab0HYAL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 20:11:29 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27592 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab0HYALZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 20:11:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XOOPRlBH+hb7zWXLl0usjnqMeDOExH0vp6ZUzOHT2yRqrbZyna3tSMe53cpcni23fp
         QugUwd4d3aqq4FoT20Tg==
MIME-Version: 1.0
In-Reply-To: <4C738B34.6070602@cn.fujitsu.com>
References: <20100820185552.426ff12e.kamezawa.hiroyu@jp.fujitsu.com>
	<20100820185816.1dbcd53a.kamezawa.hiroyu@jp.fujitsu.com>
	<4C738B34.6070602@cn.fujitsu.com>
Date: Tue, 24 Aug 2010 17:11:22 -0700
Message-ID: <AANLkTi=HwPeWafzTBh66g37XxZouKicsemmnTE-Cvz=Y@mail.gmail.com>
Subject: Re: [PATCH 1/5] cgroup: ID notification call back
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kamezawa.hiroyuki@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 2:04 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> Maybe pass the id number to id_attached() is better.
>
> And actually the @ss argument is not necessary, because the memcg's
> id_attached() handler of course knows it's dealing with the memory
> cgroup subsystem.
>
> So I suspect we can just remove all the @ss from all the callbacks..

Yes, I don't think any subsystem uses these. They dated originally
from when, as part of the initial cgroups framwork, I included a
library that could wrap a mostly-unmodified CKRM resource controller
into a cgroups subsystem, at which point the callback code didn't
necessarily know which subsystem it was being called for. But that's
obsolete now.

Paul
