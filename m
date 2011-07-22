Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab1GVIXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 04:23:36 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:65267 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab1GVIXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 04:23:31 -0400
Date: Fri, 22 Jul 2011 11:21:09 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tiger
To: Kevin Wolf <kwolf@redhat.com>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        levinsasha928@gmail.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org, kvm-devel <kvm@vger.kernel.org>
Subject: Re: [tip:tools/kvm] kvm tools, qcow: Fix copy-on-write image
 corruption
In-Reply-To: <4E27DEA9.20404@redhat.com>
Message-ID: <alpine.DEB.2.00.1107221118380.2996@tiger>
References: <tip-4839bcd6b04a1b628f0f00d535ddca2ee872e9fa@git.kernel.org> <4E27DEA9.20404@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jul 2011, Kevin Wolf wrote:
> Hm, I must have missed this patch on the KVM mailing list...

It wasn't on the list, sorry.

> You should also error out before creating a new L2 table as its refcount
> would have to be updated, too. On the other hand, the patch is a bit too
> restrictive, because it applies the check to qcow1 which doesn't even
> have a refcount table.

Oh, right, I broken QCOW1.

> I'm not sure if everyone is aware of it, so another hint: Now that you
> can't grow qcow2 any more, you might find it useful to use qemu-img
> create -f qcow2 -o preallocation=metadata, so that all clusters are
> already present and you don't get random failures.

Yup, I'm aware that you can't grow images anymore. The patch was meant as 
a stop-gap measure while I'm hacking on refcount table support.

 			Pekka
