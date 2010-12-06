Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab0LFUiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:38:51 -0500
Received: from smtp-out.google.com ([74.125.121.35]:34196 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab0LFUiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:38:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=sudrAoDBCzwii4HHM+8TAEvQnIz3i5uNpHNYaCYbCtNKId21y4c+77HkHVSFUQQlLo
         UQgk1VkoGyYrOslxdNQA==
MIME-Version: 1.0
In-Reply-To: <4CF9F7AB.8050802@redhat.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
 <1291421609-14665-8-git-send-email-dhsharp@google.com> <4CF9F7AB.8050802@redhat.com>
From: David Sharp <dhsharp@google.com>
Date: Mon, 6 Dec 2010 12:38:26 -0800
Message-ID: <AANLkTi=H9eSAOKmN8KdKDKiFZdD7DjQC=wa+fqrDpe2q@mail.gmail.com>
Subject: Re: [PATCH 07/15] ftrace: fix event alignment: kvm:kvm_hv_hypercall
To: Avi Kivity <avi@redhat.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org, mrubin@google.com,
        kvm-devel <kvm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oB6Kd2xg018873

On Sat, Dec 4, 2010 at 12:11 AM, Avi Kivity <avi@redhat.com> wrote:
> On 12/04/2010 02:13 AM, David Sharp wrote:
>>
>> Signed-off-by: David Sharp<dhsharp@google.com>
>> ---
>>  arch/x86/kvm/trace.h |    8 ++++----
>>  1 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
>> index a6544b8..ab41fb0 100644
>> --- a/arch/x86/kvm/trace.h
>> +++ b/arch/x86/kvm/trace.h
>> @@ -62,21 +62,21 @@ TRACE_EVENT(kvm_hv_hypercall,
>>        TP_ARGS(code, fast, rep_cnt, rep_idx, ingpa, outgpa),
>>
>>        TP_STRUCT__entry(
>> -               __field(        __u16,          code            )
>> -               __field(        bool,           fast            )
>>                __field(        __u16,          rep_cnt         )
>>                __field(        __u16,          rep_idx         )
>>                __field(        __u64,          ingpa           )
>>                __field(        __u64,          outgpa          )
>> +               __field(        __u16,          code            )
>> +               __field(        bool,           fast            )
>>        ),
>>
>
> Looks like a pessimisation.
>
> Before: 24 bytes
> After: 32 bytes
>
> (on a 64-bit machine, assuming no packing)

This patch is predicated on packing the event structures. And since
the ring buffer is 32-bit addressable, I don't attempt to improve
alignment beyond 32-bit boundaries.

>
> --
> I have a truly marvellous patch that fixes the bug which this
> signature is too narrow to contain.
>
>
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
