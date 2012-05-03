Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab2ECPzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 11:55:37 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36170 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab2ECPzg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 11:55:36 -0400
MIME-Version: 1.0
In-Reply-To: <20120503154140.GA2592@linux.vnet.ibm.com>
References: <CA+1xoqd_z8Zavzraq1oXVRpwkJRoac57tojBYf7x=Kzs+cbJ_w@mail.gmail.com>
 <20120503154140.GA2592@linux.vnet.ibm.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Thu, 3 May 2012 17:55:14 +0200
Message-ID: <CA+1xoqepggR4YRzDXFz=Hk9EeXACMRyeXorQm7rE3r5MQyY6Fw@mail.gmail.com>
Subject: Re: rcu: BUG on exit_group
To: paulmck@linux.vnet.ibm.com
Cc: "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 3, 2012 at 5:41 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Thu, May 03, 2012 at 10:57:19AM +0200, Sasha Levin wrote:
>> Hi Paul,
>>
>> I've hit a BUG similar to the schedule_tail() one when. It happened
>> when I've started fuzzing exit_group() syscalls, and all of the traces
>> are starting with exit_group() (there's a flood of them).
>>
>> I've verified that it indeed BUGs due to the rcu preempt count.
>
> Hello, Sasha,
>
> Which version of -next are you using?  I did some surgery on this
> yesterday based on some bugs Hugh Dickins tracked down, so if you
> are using something older, please move to the current -next.

I'm using -next from today (3.4.0-rc5-next-20120503-sasha-00002-g09f55ae-dirty).
