Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab2KUTpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 14:45:50 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58325 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818Ab2KUTpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 14:45:49 -0500
MIME-Version: 1.0
In-Reply-To: <50AD0E22.3020807@zytor.com>
References: <1353482170-10160-1-git-send-email-yinghai@kernel.org>
	<1353482170-10160-2-git-send-email-yinghai@kernel.org>
	<50AD0E22.3020807@zytor.com>
Date: Wed, 21 Nov 2012 11:45:47 -0800
X-Google-Sender-Auth: Vta8fJeRlhlVn9uzFSgyEElWkl4
Message-ID: <CAE9FiQVreVFJ5tASirYkzTUvYw1XombdArqN3N1HnAP9wLijhQ@mail.gmail.com>
Subject: Re: [PATCH v3 01/12] x86, boot: move verify_cpu.S after 0x200
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Content-Type: multipart/mixed; boundary=000e0ce0452cd5bfb704cf069811
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0ce0452cd5bfb704cf069811
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Nov 21, 2012 at 9:23 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 11/20/2012 11:15 PM, Yinghai Lu wrote:
>>
>> We are short of space before 0x200 that is entry for startup_64.
>>
>> And we can not change startup_64 to other value --- ABI ?
>
>
> Here you are saying "I don't understand how this works."  It is YOUR
> responsibility to find out and write a definite statement rather than
> leaving that to the reader, or expect the maintainer to edit this.

actually, i can not find that out.
in the code of arch/x86/boot/compressed/head_64.S

        /*
         * Be careful here startup_64 needs to be at a predictable
         * address so I can export it in an ELF header.  Bootloaders
         * should look at the ELF header to find this address, as
         * it may change in the future.
         */
        .code64
        .org 0x200
ENTRY(startup_64)
        /*
         * We come here either from startup_32 or directly from a
         * 64bit bootloader.  If we come here from a bootloader we depend on
         * an identity mapped page table being provied that maps our
         * entire text+data+bss and hopefully all of memory.
         */
#ifdef CONFIG_EFI_STUB
        /*
         * The entry point for the PE/COFF executable is 0x210, so only
         * legacy boot loaders will execute this jmp.
         */
        jmp     preferred_addr

        .org 0x210
        mov     %rcx, %rdi

and it says that 0x200 will be changed later..

so you said it has to stay with 0x200, do you mean 0x210 from PE/COFF
force that?

wonder if you are considering attatched patch to move startup_64 down...
we could kill one jmp.

Thanks

Yinghai

--000e0ce0452cd5bfb704cf069811
Content-Type: application/octet-stream; name="new_startup_64_0x400.patch"
Content-Disposition: attachment; filename="new_startup_64_0x400.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h9sv2rui0

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2Jvb3QvY29tcHJlc3NlZC9oZWFkXzY0LlMgYi9hcmNoL3g4
Ni9ib290L2NvbXByZXNzZWQvaGVhZF82NC5TCmluZGV4IDJjNGIxNzEuLjRjYjQwZDcgMTAwNjQ0
Ci0tLSBhL2FyY2gveDg2L2Jvb3QvY29tcHJlc3NlZC9oZWFkXzY0LlMKKysrIGIvYXJjaC94ODYv
Ym9vdC9jb21wcmVzc2VkL2hlYWRfNjQuUwpAQCAtMTg0LDI4ICsxODQsOSBAQCBub19sb25nbW9k
ZToKIAogI2luY2x1ZGUgIi4uLy4uL2tlcm5lbC92ZXJpZnlfY3B1LlMiCiAKLQkvKgotCSAqIEJl
IGNhcmVmdWwgaGVyZSBzdGFydHVwXzY0IG5lZWRzIHRvIGJlIGF0IGEgcHJlZGljdGFibGUKLQkg
KiBhZGRyZXNzIHNvIEkgY2FuIGV4cG9ydCBpdCBpbiBhbiBFTEYgaGVhZGVyLiAgQm9vdGxvYWRl
cnMKLQkgKiBzaG91bGQgbG9vayBhdCB0aGUgRUxGIGhlYWRlciB0byBmaW5kIHRoaXMgYWRkcmVz
cywgYXMKLQkgKiBpdCBtYXkgY2hhbmdlIGluIHRoZSBmdXR1cmUuCi0JICovCiAJLmNvZGU2NAot
CS5vcmcgMHgyMDAKLUVOVFJZKHN0YXJ0dXBfNjQpCi0JLyoKLQkgKiBXZSBjb21lIGhlcmUgZWl0
aGVyIGZyb20gc3RhcnR1cF8zMiBvciBkaXJlY3RseSBmcm9tIGEKLQkgKiA2NGJpdCBib290bG9h
ZGVyLiAgSWYgd2UgY29tZSBoZXJlIGZyb20gYSBib290bG9hZGVyIHdlIGRlcGVuZCBvbgotCSAq
IGFuIGlkZW50aXR5IG1hcHBlZCBwYWdlIHRhYmxlIGJlaW5nIHByb3ZpZWQgdGhhdCBtYXBzIG91
cgotCSAqIGVudGlyZSB0ZXh0K2RhdGErYnNzIGFuZCBob3BlZnVsbHkgYWxsIG9mIG1lbW9yeS4K
LQkgKi8KICNpZmRlZiBDT05GSUdfRUZJX1NUVUIKLQkvKgotCSAqIFRoZSBlbnRyeSBwb2ludCBm
b3IgdGhlIFBFL0NPRkYgZXhlY3V0YWJsZSBpcyAweDIxMCwgc28gb25seQotCSAqIGxlZ2FjeSBi
b290IGxvYWRlcnMgd2lsbCBleGVjdXRlIHRoaXMgam1wLgotCSAqLwotCWptcAlwcmVmZXJyZWRf
YWRkcgotCisJLyogVGhlIGVudHJ5IHBvaW50IGZvciB0aGUgUEUvQ09GRiBleGVjdXRhYmxlIGlz
IDB4MjEwICovCiAJLm9yZyAweDIxMAogCW1vdgklcmN4LCAlcmRpCiAJbW92CSVyZHgsICVyc2kK
QEAgLTIzNCwxMiArMjE1LDI2IEBAIEVOVFJZKHN0YXJ0dXBfNjQpCiAJc3VicQkkM2IsICVyYXgK
IAlzdWJxCUJQX3ByZWZfYWRkcmVzcyglcnNpKSwgJXJheAogCWFkZAlCUF9jb2RlMzJfc3RhcnQo
JWVzaSksICVlYXgKLQlsZWFxCXByZWZlcnJlZF9hZGRyKCVyYXgpLCAlcmF4CisJbGVhcQlzdGFy
dHVwXzY0KCVyYXgpLCAlcmF4CiAJam1wCSolcmF4CiAKLXByZWZlcnJlZF9hZGRyOgogI2VuZGlm
CiAKKwkvKgorCSAqIEJlIGNhcmVmdWwgaGVyZSBzdGFydHVwXzY0IG5lZWRzIHRvIGJlIGF0IGEg
cHJlZGljdGFibGUKKwkgKiBhZGRyZXNzIHNvIEkgY2FuIGV4cG9ydCBpdCBpbiBhbiBFTEYgaGVh
ZGVyLiAgQm9vdGxvYWRlcnMKKwkgKiBzaG91bGQgbG9vayBhdCB0aGUgRUxGIGhlYWRlciB0byBm
aW5kIHRoaXMgYWRkcmVzcywgYXMKKwkgKiBpdCBtYXkgY2hhbmdlIGluIHRoZSBmdXR1cmUuCisJ
ICovCisJLm9yZyAweDQwMAorRU5UUlkoc3RhcnR1cF82NCkKKwkvKgorCSAqIFdlIGNvbWUgaGVy
ZSBlaXRoZXIgZnJvbSBzdGFydHVwXzMyIG9yIGRpcmVjdGx5IGZyb20gYQorCSAqIDY0Yml0IGJv
b3Rsb2FkZXIuICBJZiB3ZSBjb21lIGhlcmUgZnJvbSBhIGJvb3Rsb2FkZXIgd2UgZGVwZW5kIG9u
CisJICogYW4gaWRlbnRpdHkgbWFwcGVkIHBhZ2UgdGFibGUgYmVpbmcgcHJvdmllZCB0aGF0IG1h
cHMgb3VyCisJICogZW50aXJlIHRleHQrZGF0YStic3MgYW5kIGhvcGVmdWxseSBhbGwgb2YgbWVt
b3J5LgorCSAqLworCiAJLyogU2V0dXAgZGF0YSBzZWdtZW50cy4gKi8KIAl4b3JsCSVlYXgsICVl
YXgKIAltb3ZsCSVlYXgsICVkcwo=
--000e0ce0452cd5bfb704cf069811--
