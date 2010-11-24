Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab0KXS6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 13:58:48 -0500
Received: from smtp-out.google.com ([74.125.121.35]:47498 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab0KXS6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 13:58:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=RLFp9VFXEBH5LEwDc3s7A4SPf42ln9ql1Rlmmu7TMOGgHAHNXhXMP5elhG4EOv0kjk
         T74mM0bLiwRcf7nFZASw==
MIME-Version: 1.0
In-Reply-To: <4CEC7329.7070909@cn.fujitsu.com>
References: <AANLkTikx6d0_VFtZ4zWQucRCf=vFt7N2M6=0jpnKasEE@mail.gmail.com>
 <1290398767-15230-1-git-send-email-ccross@android.com> <AANLkTi=4-OgPUugnUBaqSU3oC=3wxTjAsOB_Ais3Or+i@mail.gmail.com>
 <4CEC7329.7070909@cn.fujitsu.com>
From: Paul Menage <menage@google.com>
Date: Wed, 24 Nov 2010 10:58:23 -0800
Message-ID: <AANLkTikhE-z7HuLimuj_pJLKd7FHq+w6PQCd85XuT0a8@mail.gmail.com>
Subject: Re: [PATCH] cgroup: Convert synchronize_rcu to call_rcu in cgroup_attach_task
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 6:06 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> If we do this, it's not anymore safe to use get_css_set(), which just
> increments the refcount without checking if it's zero.

I don't believe that it's currently safe to use get_css_set() on a
zero-refcount css_set anyway - a css_set starts with refcount 1 and
can be freed the moment that its refcount reaches 0. You can only use
get_css_set() on a stable reference to an existing css_set, which by
definition has a refcount of at least 1. Were you thinking of any
particular existing uses?

Paul
