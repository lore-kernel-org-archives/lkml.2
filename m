Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759726Ab0J2ANq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 20:13:46 -0400
Received: from smtp-out.google.com ([74.125.121.35]:23035 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759508Ab0J2ANk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 20:13:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tGnm5crr81ouCNYTdIIbzeSZiLq33i0dOeMW5/WQGbwSwk0rkKclvh5UC0WBoEp8Ru
         SiHlysU3IZWNx0Cry9XQ==
MIME-Version: 1.0
In-Reply-To: <4CC14769.2000406@cn.fujitsu.com>
References: <4CC146A4.9090505@cn.fujitsu.com>
	<4CC14769.2000406@cn.fujitsu.com>
Date: Thu, 28 Oct 2010 17:13:36 -0700
Message-ID: <AANLkTinbtLkF=haFeDkzecEWv_FE9jG4TefiptSnZcPi@mail.gmail.com>
Subject: Re: [PATCH 7/7] cgroups: Update documentation for bindable subsystems
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

>
>  Called when a cgroup subsystem is rebound to a different hierarchy
> -and root cgroup. Currently this will only involve movement between
> -the default hierarchy (which never has sub-cgroups) and a hierarchy
> -that is being created/destroyed (and hence has no sub-cgroups).
> +and root cgroup. For some subsystems this will only involve movement
> +between the default hierarchy (which never has sub-cgroups) and a
> +hierarchy that is being created/destroyed (and hence has no sub-cgroups).
> +For some other subsystems this can involve movement between the default
> +hierarchy and a mounted hierarchy which may have sub-cgroups in it.

This is a bit vague. How about:

For non-bindable subsystems, this will  only involve movement
between the default hierarchy (which never has sub-cgroups) and a
hierarchy that is being created/destroyed (and hence has no sub-cgroups).

For binadable subsystems, this may also involve movement between the
default hierarchy and a mounted hierarchy that's populated with
sub-cgroups.

Also, the docs should mention that a cgroup setting the can_bind flag
has to be able to support side-effect free movement of a task into any
just-created cgroup, and into the root cgroup at any time. i.e. it's
not suitable for any subsystem where can_attach() might return false
for the root cgroup or a newly-created cgroup, or attach() might have
side-effects for those same cases.

Actually, perhaps we should forbid the combination of having both an
attach() callback and can_bind=true ?

Also, post_clone() doesn't get called when creating the css hierarchy
during binding.

Paul
