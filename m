Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab2BSL0z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 06:26:55 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:56290 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753147Ab2BSL0y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 06:26:54 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eranian@google.com designates 10.152.115.69 as permitted sender) smtp.mail=eranian@google.com; dkim=pass header.i=eranian@google.com
MIME-Version: 1.0
In-Reply-To: <20120215023705.GA13042@us.ibm.com>
References: <20120126160319.GA5655@quad>
	<20120208223250.282861cb@kryten>
	<CABPqkBRbvs3rHoCw9najObgUvfSCziVrR-U-UARWN3+St2=v8A@mail.gmail.com>
	<20120210031930.GA28023@us.ibm.com>
	<1328854519.3019.3.camel@pasglop>
	<20120215023705.GA13042@us.ibm.com>
Date: Sun, 19 Feb 2012 12:26:52 +0100
Message-ID: <CABPqkBQD0F4QgZaiEXhyGX-CCbPG74jGu+RPmEOk7HcUGT00cA@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix broken intr throttling (v3)
From: Stephane Eranian <eranian@google.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@samba.org>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu, gleb@redhat.com,
        wcohen@redhat.com, vince@deater.net, asharma@fb.com,
        andi@firstfloor.org, paulus@samba.org, emunson@mgebm.net,
        imunsie@au1.ibm.com, Matt Helsley <matthltc@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Did Anton recent fix solve that problem?


On Wed, Feb 15, 2012 at 3:37 AM, Sukadev Bhattiprolu
<sukadev@linux.vnet.ibm.com> wrote:
> Benjamin Herrenschmidt [benh@kernel.crashing.org] wrote:
> | On Thu, 2012-02-09 at 19:19 -0800, Sukadev Bhattiprolu wrote:
> | > Stephane Eranian [eranian@google.com] wrote:
> | > | On Wed, Feb 8, 2012 at 12:32 PM, Anton Blanchard <anton@samba.org> wrote:
> | > | >
> | > | > Hi,
> | > | >
> | > | > On Thu, 26 Jan 2012 17:03:19 +0100
> | The powerpc .git tree is not useful at this point, I haven't opened
> | powerpc -next yet so it's just all old stale stuff. Please work with
> | upstream always unless you have a very good reason to use my tree. It's
> | really only meant as a conduit between me and Linus or for -next.
>
> Ok.
>
> I tried this on current mainline (commit 13d261932) which now includes both
> of Stephane's patches and repeated the nooploop test.
>
> The problem still exists - the number of events reported on Power is far
> fewer than without the patches.
>
> Aggregated stats:
>           TOTAL events:         78
>            MMAP events:         47
>            COMM events:          2
>            EXIT events:          2
>          SAMPLE events:         27
> cycles stats:
>           TOTAL events:         21
>            MMAP events:          4
>            COMM events:          1
>            EXIT events:          2
>          SAMPLE events:         14
> cycles stats:
>           TOTAL events:         13
>          SAMPLE events:         13
>
> Sukadev
>
