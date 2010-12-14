Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436Ab0LNPzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 10:55:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757749Ab0LNPzv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 10:55:51 -0500
MIME-Version: 1.0
In-Reply-To: <20101214153135.5f4423e0@suzukikp>
References: <20101214152259.67896960@suzukikp> <20101214153135.5f4423e0@suzukikp>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 14 Dec 2010 07:55:00 -0800
Message-ID: <AANLkTimA635P-X5SVaBwY9exfODSgzhDWCJebSRcbLO=@mail.gmail.com>
Subject: Re: [Patch 4/21] Make fill_psinfo generic
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
        Amerigo Wang <amwang@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 2:01 AM, Suzuki K. Poulose <suzuki@in.ibm.com> wrote:
> +       /*
> +        * If we are dumping core for "another task"
> +        * we can't use copy_from_user().
> +        */
> +       if (p->group_leader == current->group_leader) {

This is totally bogus. "group_leader" has absolutely nothing to do
with whether the process shares the address space. It's about signal
sharing etc.

The way to check whether they share the same address space is to check
whether "mm" is the same.

                                      Linus
