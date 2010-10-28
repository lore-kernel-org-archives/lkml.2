Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588Ab0J1Xzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 19:55:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:58612 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759139Ab0J1Xzf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 19:55:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CGz+VLm586uDthgHaSybpvVgkujTTOafR1dOGw/7ugDEvNBVkg6fEA9VdIvk2of1P9
         fbbMelMqTi1r513naApw==
MIME-Version: 1.0
In-Reply-To: <4CC146D4.7030009@cn.fujitsu.com>
References: <4CC146A4.9090505@cn.fujitsu.com>
	<4CC146D4.7030009@cn.fujitsu.com>
Date: Thu, 28 Oct 2010 16:55:32 -0700
Message-ID: <AANLkTimCD90s+y_6y=LyOL1QqEOOAaT+b2b4guDrzo_g@mail.gmail.com>
Subject: Re: [PATCH 2/7] cgroups: Allow to bind a subsystem to a cgroup hierarchy
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

On Fri, Oct 22, 2010 at 1:09 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> +       /*
> +        * Indicate if this subsystem can be bound/unbound to/from a cgroup
> +        * hierarchy which has child cgroups.
> +        */
> +       unsigned int can_bind:1;

Maybe call this "bindable"?

Basic idea looks great, it could do with a bunch more comments, and
maybe locking rules.

Is there any chance of a lock inversion between dir->i_mutex and
cgroup_lock in hierarchy_popuiate_dir() ?

Paul
