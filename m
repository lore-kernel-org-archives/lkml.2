Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425Ab1EWE1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 00:27:24 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55170 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab1EWE1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 00:27:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Octavian Purdila <tavi@cs.pub.ro>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [v3 00/39] faster tree-based sysctl implementation
References: <BANLkTim7xn8tM4wTyd_m_nwUQg_CUTapeA@mail.gmail.com>
Date: Sun, 22 May 2011 21:27:14 -0700
In-Reply-To: <BANLkTim7xn8tM4wTyd_m_nwUQg_CUTapeA@mail.gmail.com> (Lucian
	Adrian Grijincu's message of "Mon, 23 May 2011 04:56:11 +0300")
Message-ID: <m14o4mavod.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+L+OGeMB9TXT4LVOWHy2Mc0c0yOOl82XE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucian Adrian Grijincu <lucian.grijincu@gmail.com> writes:

> Hi
>
> This is version 3 of a patch series that introduces a faster/leaner
> sysctl internal implementation.
>
> Due to high number of patches and low general interest I'll just point
> you to the tree/branch:
>
>   git://github.com/luciang/linux-2.6-new-sysctl.git   v3-new-sysctl-alg
>
>
> Patches are on top of v2.6.39. I did not pick a more recent (random)
> point in Linus' tree to rebase these onto to not mess up testing.


Thanks for keeping going on this.

This patchset looks like it is deserving of some close scrutiny, and
not just the high level design overview I have given the previous
patches.  This is going to be a busy week for me so I probably won't
get through all of the patches for a while.

I will mention a couple of nits I noticed while I was skimming through
your patches.
- There can be multiple proc superblocks and thus multiple inodes
  referring to the same /proc/sys file, if there are multiple pid
  namespaces. 

- I have a hope to move /proc/sys into /proc/<pid>/sys so we don't have
  to look at current to determine the namespace we want to display.
  That would allow the deeply magic sysctl_is_seen check to be removed
  from proc_sys_compare.  That is not your problem, but of an
  explanation why the namespaces are passed through.

Eric
