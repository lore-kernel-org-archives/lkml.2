Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281Ab0KXC3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 21:29:39 -0500
Received: from smtp-out.google.com ([216.239.44.51]:50516 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab0KXC3h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 21:29:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=IqgG8nJw7jojfzVqmdl+MTmq+uJJd/+E+9cgxuLIiHMDRr8EgYZMdkz3zcDxF6ZeWQ
         J4MbNGlklQQTBaCmSS3w==
MIME-Version: 1.0
In-Reply-To: <1290563018-2804-1-git-send-email-ccross@android.com>
References: <AANLkTi=4-OgPUugnUBaqSU3oC=3wxTjAsOB_Ais3Or+i@mail.gmail.com>
	<1290563018-2804-1-git-send-email-ccross@android.com>
Date: Tue, 23 Nov 2010 18:29:32 -0800
X-Google-Sender-Auth: xYO0XA8UaM97zWf2OU8nkq8ttNU
Message-ID: <AANLkTikCbj7eivr0_k--FCD9HqVk8OoOo76mQHctzmSa@mail.gmail.com>
Subject: Re: [PATCH] cgroup: Remove call to synchronize_rcu in cgroup_attach_task
From: Colin Cross <ccross@android.com>
To: Paul Menage <menage@google.com>
Cc: Colin Cross <ccross@android.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 5:43 PM, Colin Cross <ccross@android.com> wrote:
> This patch is similar to what you described.  The main differences are
> that I used a new atomic to handle the rmdir case, and I converted
> check_for_release to be callable in softirq context rather than schedule
> work in free_css_set_rcu.  Your css_set scanning in rmdir sounds better,
> I'll take another look at that.  Is there any problem with disabling irqs
> with spin_lock_irqsave in check_for_release?

free_css_set_rcu needs to take a write lock on css_set_lock to protect the
list_del(&link->cgrp_link_list).  I'll convert it to schedule work, and change
the spin_lock_irqsave back to spin_lock.
