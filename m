Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372Ab0FREXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 00:23:05 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48292 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab0FREXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 00:23:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KKePwc0a+/g8zxFTBrAf/7Kp4bU6N6D1y6DIuzrxyGqVmvP4lGSjwE4/GSLsgKKzLz
         I4Z6kPNQXXsOwCE50VumobCyKpnvAJg4q131J4fgQ47TVPOQonBnMtan5exnsN/k7QtD
         kqunicOVtRwWRxffCwsv0/yWf3dh7JN/kvod4=
Subject: Re: [BUG] perf: installed python -report scripts have bogus paths
From: Tom Zanussi <tzanussi@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       acme@infradead.org, perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <AANLkTinB-0TzyRnjvOwWFetub1-4lhqxXFxYwsOhL3Kl@mail.gmail.com>
References: <AANLkTinB-0TzyRnjvOwWFetub1-4lhqxXFxYwsOhL3Kl@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 17 Jun 2010 23:22:57 -0500
Message-Id: <1276834977.7762.4.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2010-06-17 at 16:54 +0200, Stephane Eranian wrote:
> Hi,
> 
> I was looking at the perf trace and python scripting support.
> But I quickly ran into an issue. I compiled with:
> $ make prefix=/usr
> $ make prefix=/usr install
> 
> All the scripts are installed in /usr/libexec/perf-core/scripts/.....
> 
> The problem is that all the -report scripts have the .py script
> paths hardcoded as ~/libexec/.....
> 
> Here is an example with syscall-counts-report
> perf trace $@ -s ~/libexec/perf-core/scripts/python/syscall-counts.py $comm
> 
> That should either be stripped to syscall-counts.py and perf trace adds the
> prefix or make install needs to patch the path in. Otherwise I don't see how
> this can work unless I am confused about the usage model.

You're right - it's not a great idea to be hard-coding the path in like
this.

I'll submit a patch shortly to have perf trace add the prefix.

Thanks,

Tom


