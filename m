Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927Ab1CCWck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 17:32:40 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46792 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758800Ab1CCWci convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 17:32:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=j55dHGelw60W/LXjuiOXFi7TgzX3BfeQcR0/J/we1A7aF5OUlOWn3nXuV2FOUR1u9x
         +27RpNpEZb6Ws1aRYPijtGBKpE+l+aFsZVqI1jTY2sQCv7dUQKdock5q9u5vFUEtBwdt
         ecnttiXXu0DIsliGogKQmTJycOWD9s6sJWqgg=
MIME-Version: 1.0
In-Reply-To: <m1zkpc1rbc.fsf@fess.ebiederm.org>
References: <1298659961-23863-1-git-send-email-lucian.grijincu@gmail.com>
 <20110302.170644.58413369.davem@davemloft.net> <m1zkpc1rbc.fsf@fess.ebiederm.org>
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Thu, 3 Mar 2011 23:32:18 +0100
Message-ID: <AANLkTik_hnW9DEtcYmY9Ne+zGsxWs4q05nXMfdyh13mK@mail.gmail.com>
Subject: Re: RFC v1: sysctl: add sysctl header cookie, share tables between nets
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Miller <davem@davemloft.net>, adobriyan@gmail.com, tavi@cs.pub.ro,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 3, 2011 at 10:33 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> I may be missing something in these patches. I haven't had time to look
> at this most recent batch carefully.  But from a 10,000 foot perspective I
> have a problem with them.  With a handful of network devices the size of
> the data structures is negligible.
>
> So until I can see a reason why we should save a few bytes at the cost
> of greater future maintenance costs I'm not in favor of this patch set.


Sorry, I'm moving between countries and I don't have as much time as
I'd like to.

This patch series adds the "cookie" field and uses it in a few places.
I need this for the next step, but I wanted some feedback regarding
the cookie approach (sane? applicable if the 'dynamic header' feature
is accepted?).

Afterwards I want to add a "dynamic ctl_header" which will implement a
few ops (something on the lines of 'find_in_table' and 'scan' from
proc_sysctl.c).

At 'scan' time the "dynamic header" will create inodes for the
directories underneath with:
  ctl_table='shared ctl table for /proc/sys/net/ipv4/conf' (or
ipv6/addrconf or neigh)
  ctl_table_header=a device specific (not dynamic) table header with
->cookie pointing to a struct {char*dev_name; struct net*net;}

proc_handlers will use the name (or even a pointer to the device or
whatever speeds up the implementation) and the net to find out the
real ->data similar to the netns_proc_handlers from this patch series.

Adding an interface will not need to scan through the list of existing
ctl headers to see if any duplicates exist because there cannot be two
interfaces with the same name.

Promise to get back with patches for this implementation as soon as I can.

PS: sorry if my mumbling does not make much sense, hopefully code will
make things clear.
-- 
 .
..: Lucian
