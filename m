Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372Ab0J2ACf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 20:02:35 -0400
Received: from smtp-out.google.com ([216.239.44.51]:60719 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933300Ab0J2ACa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 20:02:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JBkwezGDLjvxnu/wpArprR9OVZWh9Va3QMR0sX7WxSXJl03y2sN6yNgUG7HonUh57N
         +G14rPZ1ZzIyi27xfdCw==
MIME-Version: 1.0
In-Reply-To: <4CC146F5.9060006@cn.fujitsu.com>
References: <4CC146A4.9090505@cn.fujitsu.com>
	<4CC146F5.9060006@cn.fujitsu.com>
Date: Thu, 28 Oct 2010 17:02:27 -0700
Message-ID: <AANLkTimUEWrfvuRFAkHkMyefNfQqUW9_ksB9jNHb+n2g@mail.gmail.com>
Subject: Re: [PATCH 3/7] cgroups: Allow to unbind subsystem from a cgroup hierarachy
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "akpm >> Andrew Morton" <akpm@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 1:10 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> -               for_each_set_bit(i, &added_bits, CGROUP_SUBSYS_COUNT)
> -                       cg->subsys[i] = cgrp->subsys[i];
> +               for_each_set_bit(i, &bits, CGROUP_SUBSYS_COUNT) {
> +                       if (add)
> +                               cg->subsys[i] = cgrp->subsys[i];
> +                       else
> +                               cg->subsys[i] = dummytop->subsys[i];
> +               }

Should these technically be rcu_assign_pointer() ?

Paul
