Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759653Ab2EIRyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:54:43 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:37024 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754872Ab2EIRym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:54:42 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Iuzt4SgVM1nuxwQiZnx0GmpaPvZboBO8ZR8O1Rte8bk92Mv
 lTEDNLQILATh0bXvxczM3Vj.3UgrZ087in6SIb3aFWX9L7j8ia5kh_f9lXvV
 UPeyS.BAK1Y_UCn.IAy62It3_x_Ld2JtRMiB2xvHN7feLmzH7KIELu8k25AV
 AtPLVtJs5.y4RDJgA49w4HNdgW3hAdLW0L7Z5j0rmL7wlwBX8WHac60kUpTf
 0wuxI7LJxr6.1xC9G6i1av1TvHCm7mVNmbjcOJuuaHa5dI0BdKElpX4EsjRQ
 8CleZWsAaUt4siMWWpOcOCkjHPk8DmPawDS2nbtcuwWIIdKsPXr03n3F8rMF
 Uh4FhanGXzUDLjkv0lz.UhUNjZCtegos1y5FYnViizGBS8WDP6xZDV.0cVlF
 BhnIdGQsTubUwnuJxG0coce6lIInmI6X2vjk4
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 9 May 2012 12:54:37 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Sam Ravnborg <sam@ravnborg.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>, Yinghai Lu <yinghai@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [patch 00/10] (no)bootmem bits for 3.5
In-Reply-To: <20120509173528.GD24636@google.com>
Message-ID: <alpine.DEB.2.00.1205091252450.11225@router.home>
References: <1336390672-14421-1-git-send-email-hannes@cmpxchg.org> <20120507204113.GD10521@merkur.ravnborg.org> <20120507220142.GA1202@cmpxchg.org> <20120508175748.GA11906@merkur.ravnborg.org> <20120509173528.GD24636@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2012, Tejun Heo wrote:

> Indeed, preferring node 0 for bootmem allocation on x86_32 got lost
> across the nobootmem changes.  I followed the git history and
> preferring NODE_DATA(0) goes back to the initial git branch creation
> time (2.6.12) and I couldn't find any explanation, and nobody
> complained about the changed behavior.  hpa, do you know why the code
> to prefer node 0 for bootmem allocations was added in the first place?
> Maybe we can just remove it?

On some early 32 bit NUMA platforms only node 0 had ZONE_NORMAL memory.
There is just no other ZONE_NORMAL memory available on other nodes on that
hardware. But that is ancient history.

Wondering if 32 bit numa machines still exist. If so how do they partition
memory below 1G?

