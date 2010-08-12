Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933952Ab0HLQWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 12:22:14 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64213 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab0HLQWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 12:22:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=XVwkV2DD5xRNntf0yUHIoB0TaZeAYPi1egahCAOY20rmS+ra5y8lWNsTf4V8b6Mi3W
         dBzMx78HialnrRDXTk1K6uKjYqVxwVuhQQBplGp2GVeNeQIYeGjwOHPMBCgTg8op5nAv
         7gSecICxhXXDBii5X4HjhauXnqFXJFWOOagi8=
MIME-Version: 1.0
In-Reply-To: <AANLkTimDGbrja5EgGQ+sQxHBRNMnmt7=rjtOfwAKEKFe@mail.gmail.com>
References: <1274733081-4623-1-git-send-email-walken@google.com>
	<1274733081-4623-7-git-send-email-walken@google.com>
	<AANLkTikFEy26V4epRGCJiDkQNQ5BH0fPP0C=4phUB=o3@mail.gmail.com>
	<AANLkTimDGbrja5EgGQ+sQxHBRNMnmt7=rjtOfwAKEKFe@mail.gmail.com>
Date: Thu, 12 Aug 2010 09:22:09 -0700
X-Google-Sender-Auth: aVt575C3uDRky6mis7w6nl_NkhQ
Message-ID: <AANLkTiky4AvhTjt62Uw-VDCGg_wykzVkScYWxrHkhhgJ@mail.gmail.com>
Subject: Re: [PATCH 06/11] rwsem: wake queued readers when writer blocks on
 active read lock
From: Tony Luck <tony.luck@intel.com>
To: Michel Lespinasse <walken@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Waychison <mikew@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 10:02 PM, Michel Lespinasse <walken@google.com> wrote:
> #define RWSEM_UNLOCKED_VALUE __IA64_UL_CONST(0x0000000000000000)
> #define RWSEM_ACTIVE_BIAS (1L)
> #define RWSEM_ACTIVE_MASK (0xffffffffL)
> #define RWSEM_WAITING_BIAS (-0x100000000L)
> #define RWSEM_ACTIVE_READ_BIAS RWSEM_ACTIVE_BIAS
> #define RWSEM_ACTIVE_WRITE_BIAS (RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)

Thanks - that fixes it for me.

-Tony
