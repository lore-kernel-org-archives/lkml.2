Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab0KTBKB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 20:10:01 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58164 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab0KTBJ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 20:09:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xUmUwx3RGi/LaXkUdZzp6iNzm7rWjYzs4J71KmZu0WkonrEA2eJEypZ7vY/casts1h
         BOgTPvbka7EGDSCQ7UHpDwP8WtiWMB9FFUNo61FPJMutRaqWevrlgmZ0UlJy5KekfLVJ
         bY0urPcm+Ld8EEns1GhalUrLqUNrST5A9yY7I=
MIME-Version: 1.0
In-Reply-To: <AANLkTikPTYLELKMLOeB868rW9cN40897TRg0dtuN=zQQ@mail.gmail.com>
References: <1290154233-28695-1-git-send-email-ying.huang@intel.com>
	<1290154233-28695-3-git-send-email-ying.huang@intel.com>
	<AANLkTikPTYLELKMLOeB868rW9cN40897TRg0dtuN=zQQ@mail.gmail.com>
Date: Sat, 20 Nov 2010 09:09:58 +0800
Message-ID: <AANLkTimWbcemRbB-1XCTOSi-tpGLB2O1O5uueg_PzPWX@mail.gmail.com>
Subject: Re: [PATCH 2/2] Hardware error record persistent support
From: huang ying <huang.ying.caritas@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 11:52 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Nov 19, 2010 at 12:10 AM, Huang Ying <ying.huang@intel.com> wrote:
>> Normally, corrected hardware error records will go through the kernel
>> processing and be logged to disk or network finally.  But for
>> uncorrected errors, system may go panic directly for better error
>> containment, disk or network is not usable in this half-working
>> system.  To avoid losing these valuable hardware error records, the
>> error records are saved into some kind of simple persistent storage
>> such as flash before panic, so that they can be read out after system
>> reboot successfully.
>
> I think this is totally the wrong thing to do. TOTALLY.
>
> The fact is, concentrating about "hardware errors" makes this
> something that I refuse to merge. It's such an idiotic approach that
> it's disgusting.
>
> Now, if this was designed to be a "hardware-backed persistent 'printk'
> buffer", and was explicitly meant to save not just some special
> hardware error, but catch all printk's (which may be due to hardware
> errors or oopses or warnings or whatever), that would be useful.
>
> But limiting it to just some special source of errors makes this
> pointless and not ever worth merging.

Yes. APEI ERST can be used to back persistent 'printk', and that is in
our plan too. But APEI ERST is not limited to do that, it can be used
for printk, hardware error, and maybe some other users. When we design
APEI ERST support, we have multiple users in mind.

Best Regards,
Huang Ying
