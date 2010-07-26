Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab0GZWML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 18:12:11 -0400
Received: from smtp-out.google.com ([74.125.121.35]:23663 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab0GZWMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 18:12:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=p46B5g/wY987XYAC2bs+sq0l3PaMPiU0nCPE+/1jM8Bt+xwfURdSr9RVSTimo10ak
	c6mgucfVh3ge5iVWQ8M0Q==
Date: Mon, 26 Jul 2010 15:12:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: dave b <db.pub.mail@gmail.com>
cc: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: PROBLEM: oom killer and swap weirdness on 2.6.3* kernels
In-Reply-To: <AANLkTikUO+WMHXqTMc7jR84UMgKidzX5d5JX6q=DvmpY@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1007261510320.2993@chino.kir.corp.google.com>
References: <AANLkTimAF1zxXlnEavXSnlKTkQgGD0u9UqCtUVT_r9jV@mail.gmail.com> <AANLkTimUYmUCdFMIaVi1qqcz2DqGoILeu43XWZBHSILP@mail.gmail.com> <AANLkTilmr29Vv3N64n7KVj9fSDpfBHIt8-quxtEwY0_X@mail.gmail.com> <alpine.LSU.2.00.1005211410170.14789@sister.anvils>
 <AANLkTil8sEzrsC9If5HdU8S5R-sK84_fUt_BXUDcAu0J@mail.gmail.com> <alpine.DEB.2.00.1006011351400.13136@chino.kir.corp.google.com> <AANLkTikUO+WMHXqTMc7jR84UMgKidzX5d5JX6q=DvmpY@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jul 2010, dave b wrote:

> Actually it turns out on 2.6.34.1 I can trigger this issue. What it
> really is, is that linux doesn't invoke the oom killer when it should
> and kill something off. This is *really* annoying.
> 

I'm not exactly sure what you're referring to, it's been two months and 
you're using a new kernel and now you're saying that the oom killer isn't 
being utilized when the original problem statement was that it was killing 
things inappropriately?

> I used the follow script - (on 2.6.34.1)
> cat ./scripts/disable_over_commit
> #!/bin/bash
> echo 2 > /proc/sys/vm/overcommit_memory
> echo 40 > /proc/sys/vm/dirty_ratio
> echo 5 > /proc/sys/vm/dirty_background_ratio
> 
> And I was still able to reproduce this bug.
> Here is some c  code to trigger the condition I am talking about.
> 
> 
> #include <stdlib.h>
> #include <stdio.h>
> 
> int main(void)
> {
> 	while(1)
> 	{
> 		malloc(1000);
> 	}
> 
> 	return 0;
> }
> 
