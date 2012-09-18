Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab2IRUhC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 16:37:02 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:42318 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109Ab2IRUg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 16:36:57 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1209181322490.25146@chino.kir.corp.google.com>
References: <20120918143504.GA30585@redhat.com> <CA+55aFxd08idQXqm+JJ6xD+uzX_f7Qa25zFHb-eWBRQcEDPhkg@mail.gmail.com>
 <20120918192338.GA25845@phenom.dumpdata.com> <alpine.DEB.2.00.1209181322490.25146@chino.kir.corp.google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 18 Sep 2012 13:36:35 -0700
X-Google-Sender-Auth: VSAp9Td8dVueILaMfOzuybvJqiw
Message-ID: <CA+55aFx4Bni8Wn_LMJZD1rkmuW0onUzjKJX1k72kf6SSp8wAjw@mail.gmail.com>
Subject: Re: 3.6rc6 slab corruption.
To: David Rientjes <rientjes@google.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 1:24 PM, David Rientjes <rientjes@google.com> wrote:
> On Tue, 18 Sep 2012, Konrad Rzeszutek Wilk wrote:
>
>>       u32 elements;
>> +     struct mutex lock;
>
> This should be a spinlock.

I don't think it can be a spinlock since it needs to protect the
user-space accesses (which Konrad admittedly didn't do, but that's
just a bug)

            Linus
