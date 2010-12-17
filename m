Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab0LQKKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 05:10:50 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37569 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab0LQKKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 05:10:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=LFeONvwTffV7r8l7Do3+qt5cVYUHMcSYk5AH53tnCvgglrXcAiusdwV1z5PEnDtma4
         j63VKnAsCJMTHREc1argN8X7SvrNSrYJynC7NPRDJ6hHCZ90LARGvmMOSIYHuMA8jHJf
         JV/iixHCS+Qa8Zn7c73dNoF7xKVsvzW8/YybM=
Date: Fri, 17 Dec 2010 18:10:39 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Am??rico Wang <xiyou.wangcong@gmail.com>,
        Mariusz Kozlowski <mk@lab.zgora.pl>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rculist: fix borked __list_for_each_rcu() macro
Message-ID: <20101217101039.GC8413@cr0.nay.redhat.com>
References: <1292451072-5095-1-git-send-email-mk@lab.zgora.pl>
 <20101215232005.GB6595@linux.vnet.ibm.com>
 <20101216060236.GB4826@mako-laptop>
 <20101216073840.GA5313@cr0.nay.redhat.com>
 <20101216155054.GB2203@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101216155054.GB2203@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 07:50:54AM -0800, Paul E. McKenney wrote:
>On Thu, Dec 16, 2010 at 03:38:40PM +0800, Américo Wang wrote:
>> On Thu, Dec 16, 2010 at 07:02:36AM +0100, Mariusz Kozlowski wrote:
>> >On Wed, Dec 15, 2010 at 03:20:05PM -0800, Paul E. McKenney wrote:
>> >> On Wed, Dec 15, 2010 at 11:11:12PM +0100, Mariusz Kozlowski wrote:
>> >> > This restores parentheses blance.
>> >> 
>> >> Good catch, queued!!!
>> >> 
>> >> This does not actually appear to be in use anywhere in the kernel any
>> >> more, so I queued this for 2.6.38 rather than in the 2.6.37 urgent queue.
>> >> So, just out of curiosity, how did you find this one?
>> >
>> >Some years ago I wrote a dumb script that walks trees of () and {}.
>> >It catches unbalanced trees. It's dumb enough to fail with #ifdef etc,
>> >but most of the time it does its job. It reaches unreachable code
>> >and unused one too.
>> 
>> gcc will complain about this, however, in this case, it is used.
>
>Hello, Américo!
>
>I did a "git grep -l __list_for_each_rcu" and its output was only:
>
>	include/linux/rculist.h:#define __list_for_each_rcu(pos, head) \
>
>This was in Linus's tree.  And gcc certainly would have failed if
>this macro had been used in any recent build.
>

Yeah, my bad, actually I meant to say "unused"... :-(
Sorry for confusing!

My point is that gcc should do this basic lexical check, no need
to invent another tool. :)

Thanks.
