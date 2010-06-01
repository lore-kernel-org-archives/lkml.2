Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab0FAPxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 11:53:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54248 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580Ab0FAPxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 11:53:11 -0400
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com,
       hpa@zytor.com, mingo@elte.hu, npiggin@suse.de, tglx@linutronix.de,
       mtosatti@redhat.com
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
From: Andi Kleen <andi@firstfloor.org>
References: <20100601093515.GH24302@redhat.com>
Date: Tue, 01 Jun 2010 17:53:09 +0200
In-Reply-To: <20100601093515.GH24302@redhat.com> (Gleb Natapov's message of "Tue\, 1 Jun 2010 12\:35\:15 +0300")
Message-ID: <87sk56ycka.fsf@basil.nowhere.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gleb Natapov <gleb@redhat.com> writes:
>
> The patch below allows to patch ticket spinlock code to behave similar to
> old unfair spinlock when hypervisor is detected. After patching unlocked

The question is what happens when you have a system with unfair
memory and you run the hypervisor on that. There it could be much worse.

Your new code would starve again, right?

There's a reason the ticket spinlocks were added in the first place.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
