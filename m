Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab1CAWl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 17:41:58 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64098 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496Ab1CAWl4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 17:41:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=m/zOHzbce1LrSjyYTPkKxkhdZu764upUsPpTyB+VRUz5Dy9x+P4kYHCZMhKg3egyp6
         p3eLlbxseAEZa+bdQ45utyRp1Dz9t4Dwlqz8nF7kDZhid+HwFrik3R493eKS7vMXKX6e
         cfqYv8JZcNqriqGVHc+++J6O5u72GWr06vIEo=
MIME-Version: 1.0
In-Reply-To: <20110226143730.GA26864@htj.dyndns.org>
References: <20110226143730.GA26864@htj.dyndns.org>
Date: Tue, 1 Mar 2011 14:41:55 -0800
X-Google-Sender-Auth: gh67eDWZ1Kbl_G4EPRLMKwbhMuk
Message-ID: <AANLkTinW-nQV4tL-_PicOb-N6imv3gtWuG-J69-6VUQd@mail.gmail.com>
Subject: Re: [RFC] Reverting NUMA-affine page table allocation
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 26, 2011 at 6:37 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> I've been looking through NUMA-affine page table allocation code and
> the proposed changes, and there currently are the a couple of
> problems.
>
> 1. Holes or misaligned nodes will force use of smaller sized mappings.
>   Patches to fix the problem have been posted by Yinghai[1].

	git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-2.6-yinghai.git
memblock

>
> 2. find_early_table_space() always calculates the amount of the needed
>   space from 0 to the specified @end.  As nodes are registered, each
>   node would try to allocate accumulative amount of space for page
>   table.  This probably wouldn't cause any actual problem (may affect
>   emulated configurations a bit tho).

interesting.

Yinghai
