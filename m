Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab1CIXOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 18:14:01 -0500
Received: from smtp-out.google.com ([74.125.121.67]:25174 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab1CIXN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 18:13:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=PaNhJ58fcBIk4GtP6QoUyPAJpzFrogPwZra4torW7uUzFc51eKFY8sLGiPhVSryQXb
         9gU60vef8GgyjVZByVZw==
MIME-Version: 1.0
In-Reply-To: <1299704969-4485-1-git-send-email-emunson@mgebm.net>
References: <1299704969-4485-1-git-send-email-emunson@mgebm.net>
From: Paul Menage <menage@google.com>
Date: Wed, 9 Mar 2011 15:13:34 -0800
Message-ID: <AANLkTinW99M1FBp5gRA=+SsjUWSJBwByurqrsjXKgQ4=@mail.gmail.com>
Subject: Re: [PATCH] Documentation: cgroups: Add notes on removing PIDs from
 tasks and cgroups requiring setup
To: Eric B Munson <emunson@mgebm.net>
Cc: containers@lists.linux-foundation.org, rdunlap@xenotime.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 9, 2011 at 1:09 PM, Eric B Munson <emunson@mgebm.net> wrote:
>
> +Note: To remove a task from a cgroup you must write its PID to the root
> +tasks file.
> +

This isn't really accurate - the root cgroup is a cgroup like all the
others. More accurate would be something like:

Since every task is always a member of exactly one cgroup in each
mounted hierarchy, to remove a task from its current cgroup you must
move it into a new cgroup (possibly the root cgroup) by writing to the
new cgroup's tasks file.

Paul
