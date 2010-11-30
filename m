Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab0K3X4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 18:56:48 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38495 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab0K3X4q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 18:56:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ut8IVt8O9PSvZ7w0AJyb5AYvs2HHbEHICAmfN5RgUwUBYcSIBImGGacS6H+yBjRDEy
         fuafTdeUe34pafhwrMS3YWhXaoWWXJzGVNY+bKHfQZCZJ62pyQOyxGUw7rE9OlJ5TKw2
         LhRvHVB9NW8f5FAIEgSiNHYOfRKJFqCjU6aV0=
MIME-Version: 1.0
In-Reply-To: <987664A83D2D224EAE907B061CE93D530191E8BCF1@orsmsx505.amr.corp.intel.com>
References: <1291085501-31494-1-git-send-email-ying.huang@intel.com>
	<1291085501-31494-3-git-send-email-ying.huang@intel.com>
	<20101129190343.7d7cea12.akpm@linux-foundation.org>
	<987664A83D2D224EAE907B061CE93D530191E8BCF1@orsmsx505.amr.corp.intel.com>
Date: Wed, 1 Dec 2010 07:56:46 +0800
Message-ID: <AANLkTimxPqx_VUBBrmgA1gzYz1p4kC1SQBJO-vv570f+@mail.gmail.com>
Subject: Re: [PATCH -v2 2/3] ACPI, APEI, Add APEI generic error status print support
From: huang ying <huang.ying.caritas@gmail.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Huang, Ying" <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 1, 2010 at 2:00 AM, Luck, Tony <tony.luck@intel.com> wrote:
>> +     for (i = 0; i < strs_size; i++) {
>> +             if (!(bits & (1U << i)))
>> +                     continue;
>> +             str = strs[i];
>> +             if (len && len + strlen(str) + 2 > 80) {
>> +                     printk("\n");
>> +                     len = 0;
>> +             }
>> +             if (!len)
>> +                     len = pr_pfx(pfx, "%s", str);
>> +             else
>> +                     len += printk(", %s", str);
>> +     }
>> +     if (len)
>> +             printk("\n");
>
> Does printk() offer any guarantees about getting all the characters
> from a single printk() call out to the console without interleaving
> with messages from printk() calls on other cpus?  If it does, then
> it would be a good idea to sprintf() the parts of this message to
> a buffer and then use one printk() call.  I think I read that netconsole
> ends up with one packet on the wire for each call to printk().
>
> Trying to parse output jumbled together from multiple cpus
> doesn't sound like fun.

Yes. Will do that.

Best Regards,
Huang Ying
