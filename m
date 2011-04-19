Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab1DSLrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 07:47:45 -0400
Received: from smtp-out.google.com ([216.239.44.51]:3940 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab1DSLro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 07:47:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=a5wuXLZlFMUW9hFCTqUN3COO061OxZKko/6x99OvDudTRcqeoMOlggcIsYlYB/mLnB
         3s3UNJYx8FjIwboLsmUQ==
MIME-Version: 1.0
In-Reply-To: <4DAD6D22.7000002@parallels.com>
References: <20110419100739.8464.80475.stgit@localhost6> <BANLkTimRV7STKcdWFXmmsQ+DLxN0bAnv3A@mail.gmail.com>
 <4DAD6D22.7000002@parallels.com>
From: Paul Menage <menage@google.com>
Date: Tue, 19 Apr 2011 13:47:21 +0200
Message-ID: <BANLkTi=4vb5bm0xD=XVJGGD06_BHz+Ciyw@mail.gmail.com>
Subject: Re: [PATCH] cpuset: allow empty cpu/node masks
To: Konstantin Khlebnikov <khlebnikov@parallels.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 1:08 PM, Konstantin Khlebnikov
<khlebnikov@parallels.com> wrote:
> Is cgroup.clone_children=1 planned to be default?

I don't think so. It would be a user-visible API change, for no
significant benefit.

>
> So, I just want to make cgroup worked out of the box:
>
> mount -t cgroup cgroup /cgroup
> mkdir /cgroup/foo
> echo $$ > /cgroup/foo/tasks

Just because cgroups has a very simple filesystem-based ASCII API,
that doesn't stop it from being a complex and
barely-human-comprehendable system. :-)

I'm not sure what we gain by making that approach work - to do useful
stuff with cgroups (rather than simply playing around with moving
tasks into cgroups) you do need to have a better understanding of
what's going on. It's not too hard to make the initial instructions
explain how to only mount the subsystems that you want, or pass the
clone_children option.

Paul
