Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab2IRU2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 16:28:16 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48785 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab2IRU2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 16:28:12 -0400
MIME-Version: 1.0
In-Reply-To: <20120918201231.GF8474@google.com>
References: <20120917201721.GJ18677@google.com> <20120918201231.GF8474@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 18 Sep 2012 13:27:50 -0700
X-Google-Sender-Auth: UpQL0U083Ja1yJb6UqnrkXAVI1c
Message-ID: <CA+55aFwt9Wd9cwk3B4U0+B+EyBJm8oG0r0ADQvEa0D4HmrMWQQ@mail.gmail.com>
Subject: Re: [PATCH 3.6-rc6] cpufreq/powernow-k8: workqueue user shouldn't
 migrate the kworker to another CPU
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        Duncan <1i5t5.duncan@cox.net>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 1:12 PM, Tejun Heo <tj@kernel.org> wrote:
> So, with work_on_cpu() reimplementation just posted[1], we can do the
> following instead.  Functionally it's about the same but less ugly.
> Ugly as it may be, I think the previous open coded version is better
> suited as a fix and for -stable.  Thoughts?

I have to say, since the work_on_cpu() reimplementation seems to
seriously simplify the code, and removes more lines than it adds, and
makes this patch smaller than your original patch, I would personally
prefer this approach instead anyway.

It's what we want long-range, isn't it? And it's smaller and simpler.
Sure, it might be a *conceptually* bigger change, but since it's both
prettier and *practically* smaller, I do like it more. Even at this
stage of -rc (and even for backporting to -stable).

Can we get some quick testing of this two-patch series from the people
who saw the original K8 cpufreq issue? Duncan?

           Linus
