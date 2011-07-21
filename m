Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab1GUIG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 04:06:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425Ab1GUIG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 04:06:26 -0400
Message-ID: <4E27DEA9.20404@redhat.com>
Date: Thu, 21 Jul 2011 10:09:13 +0200
From: Kevin Wolf <kwolf@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        levinsasha928@gmail.com, penberg@kernel.org, kwolf@redhat.com,
        tglx@linutronix.de
CC: linux-tip-commits@vger.kernel.org, kvm-devel <kvm@vger.kernel.org>
Subject: Re: [tip:tools/kvm] kvm tools, qcow: Fix copy-on-write image corruption
References: <tip-4839bcd6b04a1b628f0f00d535ddca2ee872e9fa@git.kernel.org>
In-Reply-To: <tip-4839bcd6b04a1b628f0f00d535ddca2ee872e9fa@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.07.2011 21:49, schrieb tip-bot for Pekka Enberg:
> Commit-ID:  4839bcd6b04a1b628f0f00d535ddca2ee872e9fa
> Gitweb:     http://git.kernel.org/tip/4839bcd6b04a1b628f0f00d535ddca2ee872e9fa
> Author:     Pekka Enberg <penberg@kernel.org>
> AuthorDate: Wed, 20 Jul 2011 16:28:31 +0300
> Committer:  Pekka Enberg <penberg@kernel.org>
> CommitDate: Wed, 20 Jul 2011 16:28:31 +0300
> 
> kvm tools, qcow: Fix copy-on-write image corruption
> 
> We don't handle refcount table properly so make sure we only write to clusters
> that have the "copied" flag set.
> 
> Cc: Kevin Wolf <kwolf@redhat.com>
> Cc: Sasha Levin <levinsasha928@gmail.com>
> Signed-off-by: Pekka Enberg <penberg@kernel.org>

Hm, I must have missed this patch on the KVM mailing list...

You should also error out before creating a new L2 table as its refcount
would have to be updated, too. On the other hand, the patch is a bit too
restrictive, because it applies the check to qcow1 which doesn't even
have a refcount table.

I'm not sure if everyone is aware of it, so another hint: Now that you
can't grow qcow2 any more, you might find it useful to use qemu-img
create -f qcow2 -o preallocation=metadata, so that all clusters are
already present and you don't get random failures.

Kevin
