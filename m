Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab2ALJVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 04:21:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36128 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab2ALJVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 04:21:39 -0500
MIME-Version: 1.0
In-Reply-To: <CAFgQCTtQfVXrgS-eP0-58T+Qx4fHJ6nB6qHXKSEsHDTc2zC2nA@mail.gmail.com>
References: <CAFgQCTtQfVXrgS-eP0-58T+Qx4fHJ6nB6qHXKSEsHDTc2zC2nA@mail.gmail.com>
Date: Thu, 12 Jan 2012 09:21:38 +0000
Message-ID: <CAJSP0QW1S87WD2pHZ0xUxTvxpOAxsB-LyOD4skxxziwUCWtkkQ@mail.gmail.com>
Subject: Re: Could anybody give some description about the implement of
 hyercall in kvm?
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Liu ping fan <kernelfans@gmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 4:38 AM, Liu ping fan <kernelfans@gmail.com> wrote:
> Could anybody give some description about the implement of hyercall in
> kvm? Or give some links about it?

Try git grep hypercall arch/x86/kvm.

Take a look at arch/x86/kvm/x86.c kvm_set_msr_common() and
kvm_emulate_hypercall().  Some of the KVM time-keeping, minimal HyperV
support, and async page faults live there.  Also see
arch/x86/include/asm/kvm_para.h.

Hypercalls are architecture-specific so if you are interested in ppc
or s390, check those arch directories.

Stefan
