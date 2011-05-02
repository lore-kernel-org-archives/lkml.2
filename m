Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab1EBTDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 15:03:03 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:60587 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab1EBTDC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 15:03:02 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Octavian Purdila <tavi@cs.pub.ro>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 00/69] faster tree-based sysctl implementation
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
	<m1zkn68mpk.fsf@fess.ebiederm.org>
	<BANLkTi=NcpPQUGkR=pbOMPfMkyL7LiBeoA@mail.gmail.com>
	<m1r58i2g02.fsf@fess.ebiederm.org>
	<BANLkTinTMckhNYx1OiyH_YR+hr31naPQHw@mail.gmail.com>
	<m1aaf5yf64.fsf@fess.ebiederm.org>
	<BANLkTi=PazFJ2QAXArCK52X7JM-xq5Ca5w@mail.gmail.com>
Date: Mon, 02 May 2011 12:02:55 -0700
In-Reply-To: <BANLkTi=PazFJ2QAXArCK52X7JM-xq5Ca5w@mail.gmail.com> (Lucian
	Adrian Grijincu's message of "Mon, 2 May 2011 09:44:05 +0200")
Message-ID: <m1aaf5vsbk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+pCzah5+ges5GQwresMHDdYA4bWch2hw0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucian Adrian Grijincu <lucian.grijincu@gmail.com> writes:

> On Mon, May 2, 2011 at 5:06 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> In particular I was referring to create_proc_entry.  It takes
>> a path and an optional parent directory.
>
> I did something like that in this patch series I sent a month ago
> which was mostly ignored (except for a call from David Miller for
> feedback on the patches):
> http://thread.gmane.org/gmane.linux.kernel/1121889
>
> I'll see how I can add the optional parent directory in this patch series.
>
> Could you please take a look at a few patches in the above series?
>
> The ones that have "cookie:" add a cookie pointer to the
> ctl_table_header making it possible to skip duplicating ctl_table
> arrays in a few places in the kernel. After finishing this series I'll
> send one with the cookie..

The cookie changes seem particularly intrusive, and if I read your
patches properly the cookies are only useful for table sharing when
implementing network namespaces.  At first glance those changes seem
pretty horrible.

Do you also have a lot of network namespaces in the workloads you care
about?

Eric

