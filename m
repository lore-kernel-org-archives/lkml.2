Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1GVIas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 04:30:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765Ab1GVIar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 04:30:47 -0400
Message-ID: <4E2935DD.20005@redhat.com>
Date: Fri, 22 Jul 2011 10:33:33 +0200
From: Kevin Wolf <kwolf@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        levinsasha928@gmail.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org, kvm-devel <kvm@vger.kernel.org>
Subject: Re: [tip:tools/kvm] kvm tools, qcow: Fix copy-on-write image corruption
References: <tip-4839bcd6b04a1b628f0f00d535ddca2ee872e9fa@git.kernel.org> <4E27DEA9.20404@redhat.com> <alpine.DEB.2.00.1107221118380.2996@tiger>
In-Reply-To: <alpine.DEB.2.00.1107221118380.2996@tiger>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.07.2011 10:21, schrieb Pekka Enberg:
> On Thu, 21 Jul 2011, Kevin Wolf wrote:
>> Hm, I must have missed this patch on the KVM mailing list...
> 
> It wasn't on the list, sorry.
> 
>> You should also error out before creating a new L2 table as its refcount
>> would have to be updated, too. On the other hand, the patch is a bit too
>> restrictive, because it applies the check to qcow1 which doesn't even
>> have a refcount table.
> 
> Oh, right, I broken QCOW1.
> 
>> I'm not sure if everyone is aware of it, so another hint: Now that you
>> can't grow qcow2 any more, you might find it useful to use qemu-img
>> create -f qcow2 -o preallocation=metadata, so that all clusters are
>> already present and you don't get random failures.
> 
> Yup, I'm aware that you can't grow images anymore. The patch was meant as 
> a stop-gap measure while I'm hacking on refcount table support.

Yeah, I was pretty sure you were aware of _that_, but maybe not everyone
knows that metadata preallocation exists.

Kevin
