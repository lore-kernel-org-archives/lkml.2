Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab1FJSR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 14:17:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56897 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab1FJSR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 14:17:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=qdiaNJRx0xCfl1L7jzzFzdp+kdzMXEIIUzYwW8NCjtdaOJIgp/7Dp4RqBEkZ2662Mx
         f6GC+sKYzvvfDCEavmSXHOLkBhOg3r4IHrMaFj/Wq/YaYHuU+JWHkSUhy8mXgwgLr2OH
         ESyptK6ZEtK9jlIRSGy16l/xxwxTm3jqmEfJA=
MIME-Version: 1.0
In-Reply-To: <20110610093312.GA1621@aftab>
References: <4df13a522720782e51@agluck-desktop.sc.intel.com>
	<4df13bf927261abd27@agluck-desktop.sc.intel.com>
	<20110610093312.GA1621@aftab>
Date: Fri, 10 Jun 2011 11:17:56 -0700
X-Google-Sender-Auth: xleh9IBh69hHSmE6Th5iI-IU5Rg
Message-ID: <BANLkTin8wpKi08UfmzLZiTSD92g4St3NYg@mail.gmail.com>
Subject: Re: [PATCH 04/10] MCE: Move ADDR/MISC reading code into common function
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 2:33 AM, Borislav Petkov <bp@amd64.org> wrote:
>> Used for next patch.
>
> Yeah, let's have a more general comment here like "save us some code
> duplication"

Sure.

>> +/*
>> + * Read ADDR and MISC registers.
>> + */
>
> No need for that comment, IMO. Function is small enough and the macros
> speak for themselves :).

Ok.

>> +static void mce_read_aux(struct mce *m, int i)
>
> inline?

Compiler will possibly do this anyway - I hate to second guess it. I'm not a
big fan of inline for code that isn't in the critical performance path.

-Tony
