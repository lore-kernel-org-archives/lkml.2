Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323Ab2BXVwo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 16:52:44 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59307 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab2BXVwj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 16:52:39 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of penberg@gmail.com designates 10.52.23.169 as permitted sender) smtp.mail=penberg@gmail.com; dkim=pass header.i=penberg@gmail.com
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1202241342240.22880@chino.kir.corp.google.com>
References: <20120222115320.GA3107@x61.redhat.com>
	<alpine.DEB.2.00.1202221640420.14213@chino.kir.corp.google.com>
	<20120223150238.GA15427@dhcp231-144.rdu.redhat.com>
	<alpine.DEB.2.00.1202231505080.26362@chino.kir.corp.google.com>
	<20120224151025.GA1848@localhost.localdomain>
	<alpine.DEB.2.00.1202241342240.22880@chino.kir.corp.google.com>
Date: Fri, 24 Feb 2012 23:52:38 +0200
X-Google-Sender-Auth: rhJ8Ji-Fqghwx2UEjYpVzeCJA2Y
Message-ID: <CAOJsxLHEAZbN-sPeJ10qAN-HVEj0Rq_RkLt0QCvZHhZitW+9pw@mail.gmail.com>
Subject: Re: [PATCH] oom: add sysctl to enable slab memory dump
From: Pekka Enberg <penberg@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Josef Bacik <josef@redhat.com>, Rafael Aquini <aquini@redhat.com>,
        linux-mm@kvack.org, Randy Dunlap <rdunlap@xenotime.net>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Feb 2012, Josef Bacik wrote:
>> Um well yeah, I'm rewriting a chunk of btrfs which was rapantly leaking memory
>> so the OOM just couldn't keep up with how much I was sucking down.  This is
>> strictly a developer is doing something stupid and needs help pointing out what
>> it is sort of moment, not a day to day OOM.

On Fri, Feb 24, 2012 at 11:45 PM, David Rientjes <rientjes@google.com> wrote:
> If you're debugging new kernel code and you realize that excessive amount
> of memory is being consumed so that nothing can even fork, you may want to
> try cat /proc/slabinfo before you get into that condition the next time
> around, although I already suspect that you know the cache you're leaking.
> It doesn't mean we need to add hundreds of lines of code to the kernel.
> Try kmemleak.

Kmemleak is a wonderful tool but it's also pretty heavy-weight which
makes it inconvenient in many cases.

                                Pekka
