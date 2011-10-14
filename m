Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab1JNMVD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:21:03 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55514 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab1JNMVA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:21:00 -0400
MIME-Version: 1.0
In-Reply-To: <20111012085024.634281a2@nehalam.linuxnetplumber.net>
References: <1318000849-2531-1-git-send-email-mmaruseac@ixiacom.com>
 <1318413446-22258-1-git-send-email-mmaruseac@ixiacom.com> <20111012085024.634281a2@nehalam.linuxnetplumber.net>
From: Mihai Maruseac <mihai.maruseac@gmail.com>
Date: Fri, 14 Oct 2011 15:20:40 +0300
Message-ID: <CAOMsUMKWzKNNR-cDK7eSK-+F-hhCc8BhkzrpLHRs2tsmjXxdXw@mail.gmail.com>
Subject: Re: [PATCH] dev: use ifindex hash for dev_seq_ops
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: davem@davemloft.net, eric.dumazet@gmail.com, mirq-linux@rere.qmqm.pl,
        therbert@google.com, jpirko@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dbaluta@ixiacom.com,
        Mihai Maruseac <mmaruseac@ixiacom.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 6:50 PM, Stephen Hemminger
<shemminger@vyatta.com> wrote:
> On Wed, 12 Oct 2011 12:57:26 +0300
> Mihai Maruseac <mihai.maruseac@gmail.com> wrote:
>
> It looks like you lost the ability to seek back and read the header
> (start token).  How is the header handled, is possible to rewind
> the file and read it over again?

We tested with a simple program reading a part of the /proc file and
then doing a seek to the start and rereading. It worked with latest
submitted patch.

>> +static inline struct net_device *next_dev(struct seq_file *seq, loff_t *pos)
>> +{
>> +     struct dev_iter_state *state = seq->private;
>> +     struct net *net = seq_file_net(seq);
>> +     struct net_device *dev = NULL;
>> +     loff_t off;
>> +
>> +     ++*pos;
>> +     dev = dev_get_by_index_rcu(net, state->ifindex);
>
> Looks good a couple of minor nits.
>
> 1. The function should not be inline, since it is in no way performance
>   critical. The compiler will probably inline it anyway.
>
> 2. dev does not have to be initialized since it is assigned a few
>   lines later.  Most programmers are trained now to always initialize
>   variables, but often it is unnecessary.
>
> 3. The name next_dev() is a little generic; maybe a better name.
>

Fixed all of them,

Thanks,
-- 
Mihai
