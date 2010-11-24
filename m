Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab0KXPKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 10:10:54 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50201 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab0KXPKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 10:10:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=eO+jy1z7zF5nCFmel2QdtKE/OqGmgy5UdXVM0Hsq8UbAiuOM/79kAZ+QORmTgXNp25
         TBIXmtYYMTGeRiQ4hRX/nJDxzBGOmiFggOQRLtH+FYkv3kxlymZuFkEtwU6KKvyE8VbI
         yuuxk0+Brw2bk2WzgdDsxBmUcE9HnJhsYJJEk=
Date: Wed, 24 Nov 2010 13:10:46 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ian Munsie <imunsie@au1.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 2/2] perf:tools: figure out start address of kernel map
 from /proc/kallsyms
Message-ID: <20101124151046.GC15875@ghostprotocols.net>
References: <1290598533-31855-1-git-send-email-tom.leiming@gmail.com>
 <20101124141129.GA15875@ghostprotocols.net>
 <AANLkTimQddY=1RpYpfELqY3sS6x30Nneo+4vGcPjb8r7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimQddY=1RpYpfELqY3sS6x30Nneo+4vGcPjb8r7@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Nov 24, 2010 at 10:38:29PM +0800, Ming Lei escreveu:
> 2010/11/24 Arnaldo Carvalho de Melo <acme@ghostprotocols.net>:
> > Can you please use kallsyms__parse()? Please take a look at
> > event__synthesize_kernel_mmap as it also uses it.
> 
> Good idea, but kallsyms__parse does not pass a parameter
> which indicates if it is a module or kernel symbol to process handler.
> 
> So could you agree on adding one parameter which indicates if
> the current symbol is module symbol to process handler?
> 
> If so, I can use kallsyms__parse.

It passes, for a line like:

ffffffffa00361ce t serio_raw_connect	[serio_raw]

The process callback will receive:

process_symbol(arg=callback arg,
               symbol_name="serio_raw_connect    [serio_raw]",
               symbol_type='T', start=0xffffffffa00361ce)

That is how we figure out if it is a module when splitting the kallsyms
into modules, as kallsyms__parse is also used in:

	dso__load_kallsyms
          dso__load_all_kallsyms
             kallsyms__parse

- Arnaldo
