Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab1BJUqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 15:46:10 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49553 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab1BJUqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 15:46:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=udspEpVulPQrpfE17eLrnxtFDfUiUqg6O9U2K8v5uBRJC+XgbtGhH0U8OBMmzMDXfV
         eDbRc6KawPV3EzTSTjnTIVcQrTTZG0r8DxFrE8NO51P78z2PcDzJ89IVqQZkoPq9iazM
         Kx7gOQiO7b5lxnm1tcaFGcNkibMH7JrL59bI8=
MIME-Version: 1.0
In-Reply-To: <20110210202023.GG20676@ghostprotocols.net>
References: <AANLkTi=4_p73eHhQbj5DDDEzTWaLou+u2igiY+yNiPQ9@mail.gmail.com>
	<20110210190843.GE20676@ghostprotocols.net>
	<AANLkTi=WRrBnyiDqOeR7PnqVhh8wLFx5W0tgjNaPvkLg@mail.gmail.com>
	<20110210202023.GG20676@ghostprotocols.net>
Date: Thu, 10 Feb 2011 12:46:07 -0800
X-Google-Sender-Auth: 69EQIKI8lNnMUb2XXs4qO_WaKeA
Message-ID: <AANLkTi=H9+rKjgkmfbS2jzfPjryah0cc9sajSgN8WOaQ@mail.gmail.com>
Subject: Re: 2.6.37 kernel warning in perf_events code
From: Arun Sharma <arun@sharma-home.net>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 12:20 PM, Arnaldo Carvalho de Melo
<acme@redhat.com> wrote:
>
>> >> perf record -g -p <pid> cs -o csw.data -- sleep 3
>
> Arun, are you shure the above line is right? I guess it should read:
>
>
> perf record -g -p <pid> -e cs -o csw.data -- sleep 3
>
> To specify the context switches soft event, right?
>

You caught a cut and paste error. I'm pretty sure I had the -e in
there when the warning triggered. I tried this command a few times,
just to verify and here's what I found:

* Under low loads, everything works fine.
* Under a heavy work load - I'm not able to reproduce the warning, but
hitting very similar symptoms:

[ perf record: Captured and wrote 2.282 MB /tmp/junk.data (~99721 samples) ]
[ perf record: Captured and wrote 1.734 MB /tmp/junk.data (~75740 samples) ]
[ perf record: Captured and wrote 0.091 MB /tmp/junk.data (~3975
samples) ]  <--- bad run

The bad run made my shell unresponsive and took around 30-40 seconds
to complete (whereas the good runs completed in less than 5 secs).
Could this be some kind of a feedback loop where what the measurement
machinery is perturbing what's being measured?

 -Arun
