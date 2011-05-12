Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553Ab1ELT6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 15:58:55 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33797 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757856Ab1ELT6y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 15:58:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PF/GpHcDLhyiDbBeJSIOIMNiAj4+ah1uBX3FqbE+lxnYYUyMMEMmvJhnsxHWoqw4Q+
         vXfR8ISN7MtuNpFS1oUvXZQwPewoJ14eZxtmg1nNPYffswR21RLpT69A39dc/h89LR92
         29toJgCx+Fh8HFeZCjtpu77bqWVhXto9/PLgk=
MIME-Version: 1.0
In-Reply-To: <20110512.150132.1679483014638599288.davem@davemloft.net>
References: <BANLkTim8mAzZbdOhBodaOFKM5esP-Q+K7g@mail.gmail.com>
	<20110512.140630.1779004012724490077.davem@davemloft.net>
	<20110512183741.GA22269@redhat.com>
	<20110512.150132.1679483014638599288.davem@davemloft.net>
Date: Thu, 12 May 2011 22:58:53 +0300
X-Google-Sender-Auth: g3YKlp1o7Xe_WxmiDTnzg36YNYg
Message-ID: <BANLkTimUko9Y-spdzQFDEvZBjaKSaJrHBw@mail.gmail.com>
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
From: Pekka Enberg <penberg@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: davej@redhat.com, eranian@google.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, Kees Cook <kees.cook@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 10:01 PM, David Miller <davem@davemloft.net> wrote:
> From: Dave Jones <davej@redhat.com>
> Date: Thu, 12 May 2011 14:37:41 -0400
>
>> On Thu, May 12, 2011 at 02:06:30PM -0400, David Miller wrote:
>>  > I hate this too, and I think it's absolutely rediculous.
>>  >
>>  > Also, like you, I lost an entire afternoon trying to figure out why
>>  > this started happening.
>>  >
>>  > I wish we could revert this change.
>>
>> At least it can be permanently disabled..
>>
>> echo kernel.kptr_restrict = 0 >> /etc/sysctl.conf
>
> Regardless, what to do about all of the "perf is broken" reports?

Lets revert the commit 9f36e2c448007b54851e7e4fa48da97d1477a175
("printk: use %pK for /proc/kallsyms and /proc/modules"), please! I
too have been wondering what's going on with perf reporting insane
symbols and this should definitely not be enabled by default.

                        Pekka
