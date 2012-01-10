Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab2AJMtD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 07:49:03 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44506 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377Ab2AJMtB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 07:49:01 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Gilad Ben-Yossef" <gilad@benyossef.com>
Cc: "Christoph Lameter" <cl@linux.com>, linux-kernel@vger.kernel.org,
        "Chris Metcalf" <cmetcalf@tilera.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Russell King" <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        "Pekka Enberg" <penberg@kernel.org>, "Matt Mackall" <mpm@selenic.com>,
        "Sasha Levin" <levinsasha928@gmail.com>,
        "Rik van Riel" <riel@redhat.com>, "Andi Kleen" <andi@firstfloor.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Alexander Viro" <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, "Avi Kivity" <avi@redhat.com>
Subject: Re: [PATCH v6 7/8] mm: only IPI CPUs to drain local pages if they
 exist
References: <1326040026-7285-8-git-send-email-gilad@benyossef.com>
 <alpine.DEB.2.00.1201091034390.31395@router.home>
 <op.v7tsxgu33l0zgt@mpn-glaptop>
 <CAOtvUMcJgnGf+RbF6J5zPxi3x4sCt7qoWe+Xd6C8GOhJV=xhqQ@mail.gmail.com>
Date: Tue, 10 Jan 2012 13:48:56 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v7vcjum63l0zgt@mpn-glaptop>
In-Reply-To: <CAOtvUMcJgnGf+RbF6J5zPxi3x4sCt7qoWe+Xd6C8GOhJV=xhqQ@mail.gmail.com>
User-Agent: Opera Mail/11.60 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2012/1/9 Michal Nazarewicz <mina86@mina86.com>:
>> This is initialised in setup_per_cpu_pageset() so it needs to be file
>> scoped.

On Tue, 10 Jan 2012 13:43:21 +0100, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> Yes. The cpumask_var_t abstraction is convenient and all but it does
> make the allocation very non obvious when it does not happen in
> proximity to the variable use - it doesn't *look* like a pointer.

You can say that about any file scoped variable that needs non-const
initialisation, not only pointers.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
