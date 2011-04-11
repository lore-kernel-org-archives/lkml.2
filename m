Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab1DKR2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 13:28:37 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:62978 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab1DKR2g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 13:28:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XDVo8BfrtnKYXSt/gNTjtpczDDddRBJVA88fqayppFkNj85t9z73lMz+SSxHvrcpLd
         nffyIK4pCFfnadHyQBsB57zrMTFbmeaLQfDIn/kk0/Wq9Q1l8hNVYuUBaLPbtlqgi6EJ
         RjXFqkcoj2B3djvQYPtDynCS5gVw9i0aR6v8k=
MIME-Version: 1.0
In-Reply-To: <BANLkTikLBv1bzohbG7e+M47xJ_fDuES=9Q@mail.gmail.com>
References: <BANLkTi=n+ckDXVk6rN=Mgh+BApbrPqPfmg@mail.gmail.com>
	<BANLkTikLBv1bzohbG7e+M47xJ_fDuES=9Q@mail.gmail.com>
Date: Mon, 11 Apr 2011 19:28:34 +0200
Message-ID: <BANLkTimBVzC2jz2MtqZFk4P5i5JyZKa3ng@mail.gmail.com>
Subject: Re: Crash with kfree(null) on MacBook? kobject_set_name_vargs
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Bob Copeland <me@bobcopeland.com>, Andy Botting <andy@andybotting.com>,
        Arend van Spriel <arend@broadcom.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just got report from Arend that he's hitting the same issue. I've no
idea what's wrong with my dev_set_name call. Should I pre-init struct
dev somehow? Before calling dev_set_name on it?

W dniu 10 kwietnia 2011 23:28 użytkownik Bob Copeland
<me@bobcopeland.com> napisał:
> 2011/4/10 Rafał Miłecki <zajec5@gmail.com>:
>> I'm writing new axi bus driver and one of the early testers reported
>> it crashing for him. Andy is using MacBook and backtrace+debugging
>> pretty clearly point to kfree being called on null string.
>
>> bcopeland on #linux-wireless suggested turning on SLAB or SLUB. Is
>> this going to provide some interesting info?
>
> To be precise, I said slab or slub _debugging_.  The reason I said
> this is that often a crash on kfree() is due to memory corruption.
> Many places in the kernel rely on kfree(NULL) being a safe operation,
> so it's likely something more than that.  SL?B debugging adds
> poisoning and corresponding checks that detect several kinds of
> corruption like buffer overruns, use-after-free, etc.
>
> The other thing you can do is get the disassembly of the Code portion
> for your oops and match it up with specific C code, look at the
> register file in the oops and match that up with variable names, and
> work backwards to figure out which pointers are broken.  Sometimes
> this can be enlightening, like if a pointer has ascii values, or is a
> small number (0 + some struct offset).

Andy, Arend: I'm not sure if someone will have straight idea whats
wrong with my code. Could you try this SL?B debugging maybe?

-- 
Rafał
