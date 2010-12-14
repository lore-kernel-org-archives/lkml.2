Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759423Ab0LNPu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 10:50:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757928Ab0LNPu0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 10:50:26 -0500
MIME-Version: 1.0
In-Reply-To: <20101214152259.67896960@suzukikp>
References: <20101214152259.67896960@suzukikp>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 14 Dec 2010 07:49:37 -0800
Message-ID: <AANLkTim3h2EBcEUP19S2Z0CKA7Oe3k5pB=4LjXsOR3F9@mail.gmail.com>
Subject: Re: [RFC] [Patch 0/21] Non disruptive application core dump infrastructure
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

On Tue, Dec 14, 2010 at 1:52 AM, Suzuki K. Poulose <suzuki@in.ibm.com> wrote:
>
> This is series of patches implementing an infrastructure for capturing the core
> of an application without disrupting its process semantics.
>
> The infrastructure makes use of the freezer subsystem in kernel to freeze the
> threads and then collect the information to generate  the core.

This seems to be a fundamentally flawed approach.

>From a security standpoint, it looks like a total disaster. A frozen
process is really hard to get rid of, so it looks like an obvious DoS
attack to just create lots of processes, then sneakily freeze them
all, and then laugh at the poor system admin who has no idea what's
going on. While frozen, the things are basically unkillable but look
entirely normal, no?

                                     Linus
