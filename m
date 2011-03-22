Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab1CVWUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 18:20:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43723 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab1CVWUC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 18:20:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=FefkflOg+Ze29nxdMfwWbydmigqoZUVpTuPfqtnNK0AHNEZHk9sb2e/3GbOZlJwwz6
         Hchpls73u9jkAWKFxc8zmIax/cm/RCOsp0VumJh4dNc8DNvz53gdJWN8q7S9xgEtgRlT
         QXFEJMLP3WZWLFYyg2/rc1gCpBjqsdqO9BAb4=
MIME-Version: 1.0
In-Reply-To: <AANLkTikCycUCyc9nqtFzYPUX2kSuWPLX-y=jXaJ4RomR@mail.gmail.com>
References: <1300826388-22881-1-git-send-email-vapier@gentoo.org>
 <alpine.DEB.2.00.1103221601010.16870@router.home> <AANLkTikCycUCyc9nqtFzYPUX2kSuWPLX-y=jXaJ4RomR@mail.gmail.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Tue, 22 Mar 2011 18:19:32 -0400
X-Google-Sender-Auth: L8nLkVlIPrfsQhb9O3cfHZg8PsA
Message-ID: <AANLkTintEJ5mwmME6sUSXBpL7aGTT+G=psmSvjKqCYjS@mail.gmail.com>
Subject: Re: [PATCH] percpu: cast away printk format warning
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 17:17, Mike Frysinger wrote:
> On Tue, Mar 22, 2011 at 17:03, Christoph Lameter <wrote:
>> On Tue, 22 Mar 2011, Mike Frysinger wrote:
>>> So add an explicit cast to unsigned long here.
>>
>> I believe we have a format character %t to avoid the cast.
>
> thanks, i wasnt aware of the ptrdiff_t extension.  i'll send out an update.

actually, that doesnt work.  ptrdiff_t  is a type unto itself.  in
order for this to work, every arch would need to cast/type
VMALLOC_{START,END} to a pointer type so that they could then be
subtracted.  or, add a ptrdiff_t cast to this file ;).
-mike
