Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab2BGFjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 00:39:20 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49619 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab2BGFjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 00:39:18 -0500
MIME-Version: 1.0
In-Reply-To: <20120207042026.GA25524@oksana.dev.rtsoft.ru>
References: <20120203163056.GA4190@redhat.com> <20120206162935.GB5117@oksana.dev.rtsoft.ru>
 <CAHGf_=oVQQRdfNYm0gOwzjxbUqPB5jMdsibLATCrt718-sMm7w@mail.gmail.com> <20120207042026.GA25524@oksana.dev.rtsoft.ru>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 7 Feb 2012 00:38:58 -0500
Message-ID: <CAHGf_=rW-EJvj-hsKgEGw4F4uAKMv-U-iG6aROzw2rN4tXPFFQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] oom: Get rid of sparse warnings
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> task struct only have allock_lock, not alloc_loc.
>
> Funnily, but sparse does not care. :-) __release(foo) will work as
> well. Seems like sparse counts locking balance globally.
>
> This is now fixed in the patch down below, thanks for catching.
>
>> Moreover we don't release
>> the lock in this code path. Seems odd.
>
> Indeed. That's exactly what sparse seeing is as well. We exit
> without releasing the lock, which is bad (in sparse' eyes). So
> we lie to sparse, telling it that we do release, so it shut ups.

Hmmm....

To be honest, I really dislike any lie annotation. Why? It is very
fragile and easily
become broken from unrelated but near line changes. Please consider to
enhance sparse at first.
