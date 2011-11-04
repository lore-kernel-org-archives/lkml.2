Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab1KDNiv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 09:38:51 -0400
Received: from swift.blarg.de ([78.47.110.205]:50882 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932119Ab1KDNiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 09:38:50 -0400
Date: Fri, 4 Nov 2011 14:38:48 +0100
From: Max Kellermann <max@duempel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, "Brian K. White" <brian@aljex.com>,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] new cgroup controller "fork"
Message-ID: <20111104133848.GA9116@Debian-60-squeeze-64-minimal>
Mail-Followup-To: Glauber Costa <glommer@parallels.com>,
	Li Zefan <lizf@cn.fujitsu.com>, "Brian K. White" <brian@aljex.com>,
	cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <20111103165903.GA4755@Debian-60-squeeze-64-minimal>
 <20111103182101.5037c1e5@lxorguk.ukuu.org.uk>
 <20111103185108.GA5153@Debian-60-squeeze-64-minimal>
 <20111103190330.02590426@lxorguk.ukuu.org.uk>
 <20111103192039.GA5300@Debian-60-squeeze-64-minimal>
 <4EB2EA93.2050206@parallels.com>
 <4EB2F5CF.5010604@aljex.com>
 <4EB30DAF.4090704@parallels.com>
 <4EB3560D.7000002@cn.fujitsu.com>
 <4EB3E47E.2080003@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB3E47E.2080003@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011/11/04 14:11, Glauber Costa <glommer@parallels.com> wrote:
> For other uses, we can watch the task counter increase until a
> certain value, and then set the limit to 0.
> 
> Max, wouldn't it be enough for your use?

No.  We do have a process limit already (I didn't publish it yet), but
we might adopt Frederic's new controller as soon as it hits our
servers.  The fork controller complements it, and we have many others.
We run a shared CGI hosting platform with millions of accounts, and
many users have badly designed or even vulnerable PHP scripts.  The
fork controller is very effective at stopping certain kinds of those.
Other controllers shall keep other problems small.  This mix of many
different measures has been working very well for quite a few years.

We'll just keep that code on our private git repository .. rebasing on
new kernel releases is easy enough for me.

Max
