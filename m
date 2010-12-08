Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab0LHJSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 04:18:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab0LHJSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 04:18:12 -0500
Message-ID: <4CFF4D4C.2070002@redhat.com>
Date: Wed, 08 Dec 2010 11:18:04 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: David Sharp <dhsharp@google.com>
CC: rostedt@goodmis.org, linux-kernel@vger.kernel.org, mrubin@google.com,
        kvm-devel <kvm@vger.kernel.org>
Subject: Re: [PATCH 07/15] ftrace: fix event alignment: kvm:kvm_hv_hypercall
References: <1291421609-14665-1-git-send-email-dhsharp@google.com> <1291421609-14665-8-git-send-email-dhsharp@google.com> <4CF9F7AB.8050802@redhat.com> <AANLkTi=H9eSAOKmN8KdKDKiFZdD7DjQC=wa+fqrDpe2q@mail.gmail.com> <4CFDFCEF.3080708@redhat.com> <AANLkTinK7Zqh=GfFLeyJLxA4u2ozyVj-Ja435iBJPV13@mail.gmail.com>
In-Reply-To: <AANLkTinK7Zqh=GfFLeyJLxA4u2ozyVj-Ja435iBJPV13@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2010 11:16 PM, David Sharp wrote:
> >
> >  I don't understand this.  Can you elaborate?  What does "32-bit addressable"
> >  mean?
>
> The ring buffer gives you space that is a multiple of 4 bytes in
> length, and 32-bit aligned. Therefore it is useless to attempt to
> align the structure beyond 32-bit boundaries, eg, a 64-bit boundary,
> because it is unpredictable if the memory the structure will be
> written to is at a 64-bit boundary (addr % 8 could be 0 or 4).
>
> >  And "predicated on packing the event structures"?  Is the structure
> >  __attribute__((packed)), or is it not?
>
> It is not packed in Linus' tree, but one of the patches before this
> patch in this patch series adds __attribute__((packed)). This patch
> assumes that the event packing patch has been applied. This patch
> should not be applied if the packing patch is not (hence,
> "predicated").

Thanks for the explanations, it makes sense now.

-- 
error compiling committee.c: too many arguments to function

