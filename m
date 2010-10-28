Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934069Ab0J1Rjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 13:39:48 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33223 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758881Ab0J1Rjp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 13:39:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TGzGs8g1vo5LL4MBJRtdyaCluhE5HvTBdE38GUDG70TO1/MvBKEz+dUhm//9aWmSVa
         cpW2b5z8QUVjbKh7rfKOw+UMiPmfpQ+k29oB2mSx4AxccqK2uLjyLKob4XS8HsZCbfgs
         6++RCE0nbI2KLDpLKW3tmlGLfbaTZOwQINp8s=
MIME-Version: 1.0
In-Reply-To: <4CC99A65.9050706@sssup.it>
References: <4CC99A65.9050706@sssup.it>
Date: Thu, 28 Oct 2010 19:39:44 +0200
Message-ID: <AANLkTimrSxANNzYF3AYf1uhC3SGW7c3Tf=ksBn-QUobP@mail.gmail.com>
Subject: Re: Understanding cgroups
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding a few more people and the containers to the copy]

On Thu, Oct 28, 2010 at 5:44 PM, Tommaso Cucinotta
<tommaso.cucinotta@sssup.it> wrote:
> Hi,
>
> I'm trying to get some understanding of the current cgroups in-kernel
> implementation
> (after having read Documentation/cgroup* and having browsed a bit the code).
> To this purpose, I tried to draw the relationships among the involved data
> structures
> (I'm limited to its relationship with [real-time] scheduling), and obtained
> this:
>
>  http://retis.sssup.it/~tommaso/cgroups.odg
>  http://retis.sssup.it/~tommaso/cgroups.eps
>
> (You can see in the bottom left part of the diagram a little
> "key/legend/pattern" for representing lists).
>
> I might have done mistakes, however the greatest doubts that I have now
> concern the relative
> cardinalities of the various associated items. Namely:
> a) why doesn't a cgroup object directly point to a css_set one, but to a
> list of them (via cg_cgroup_list elements) ?
>    it seems that a cgroup object may be associated to multiple css_set
> objects, which in turn contain vectors of
>    cgroup_subsys_state;
> b) however, cgroup.subsys[] would point to a single cgroup_subsys_state
> object per subsys_id, so, what is the
>    difference between cgroup.subsys[] and css_set.subsys[] ? (or, are these
> all redundant pointers and point
>    to the same cgroup_subsys_state objects ?)
> c) is css_set.cg_links used to point to (the head of) a list of
> cg_cgroup_link objects, or is it used to link multiple css_set objects into
> a list ? In the latter case, where is the head of the list pointed to from ?
>
> Apologies for the newbie questions that I might have posted; FYI, I'm trying
> to set-up RT scheduling groups without using the VFS-based cgroups
> interface.
>
> Thanks in advance, regards (please, reply in cc to my e-mail address).
>
>    Tommaso
>
> --
