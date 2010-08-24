Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab0HXBl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 21:41:27 -0400
Received: from smtp-out.google.com ([216.239.44.51]:16588 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab0HXBlX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 21:41:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=eMdYFxYHpyYbNwg8JM4OVIQVlCQj0T3NNaDa3SGuuU+xyFlwSeqzGRlXMLypawVQrK
         PS5rxx9LMwn6oSNf+tPw==
MIME-Version: 1.0
In-Reply-To: <20100824100943.F3B6.A69D9226@jp.fujitsu.com>
References: <20100821054808.GA29869@localhost> <AANLkTikS+DUfPz0E2SmCZTQBWL8h2zSsGM8--yqEaVgZ@mail.gmail.com>
 <20100824100943.F3B6.A69D9226@jp.fujitsu.com>
From: Michael Rubin <mrubin@google.com>
Date: Mon, 23 Aug 2010 18:41:00 -0700
Message-ID: <AANLkTi=OwGUzM0oZ5qTEFnGTuo8kVfW79oqH-Dcf8jdp@mail.gmail.com>
Subject: Re: [PATCH 4/4] writeback: Reporting dirty thresholds in /proc/vmstat
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "jack@suse.cz" <jack@suse.cz>, "riel@redhat.com" <riel@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "npiggin@kernel.dk" <npiggin@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 6:20 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> On Fri, Aug 20, 2010 at 10:48 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
>> LOL. I know about these counters. This goes back and forth a lot.
>> The reason we don't want to use this interface is several fold.
>
> Please don't use LOL if you want to get good discuttion. afaict, Wu have
> deep knowledge in this area. However all kernel-developer don't know all
> kernel knob.

Apologies. No offense was intended. I was laughing at the situation
and how I too once thought the per bdi counters were enough. Feng has
been very helpful and patient. The discussion has done nothing but
help the code so far so it is appreciated.

> In nowadays, many distro mount debugfs at boot time. so, can you please
> elaborate you worried risk?  even though we have namespace.

Right now we don't mount all of debugfs at boot time. We have not done
the work to verify its safe in our environment. It's mostly a nit.

Also I was under the impression that debugfs was intended more for
kernel devs while /proc and /sys was intended for application
developers.

>> 3) Full system counters are easier to handle the juggling of removable
>> storage where these numbers will appear and disappear due to being
>> dynamic.

This is the biggie to me. The idea is to get a complete view of the
system's writeback behaviour over time. With systems with hot plug
devices, or many many drives collecting that view gets difficult.

>> The goal is to get a full view of the system writeback behaviour not a
>> "kinda got it-oops maybe not" view.
>
> I bet nobody oppose this point :)

Yup.

mrubin
