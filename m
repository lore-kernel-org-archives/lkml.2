Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab2JUHgr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 03:36:47 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:49511 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab2JUHgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 03:36:45 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <CAKgNAkib2RZaHWP9bM0hC62=Nm5sBisQf_D9BAKNomjEPvCWbA@mail.gmail.com>
References: <CAKgNAkgp1er3-3nvge9_aVObuuxBatGRur8DtiTzyWK4w+4hrA@mail.gmail.com>
 <87txu17lss.fsf@rustcorp.com.au> <CAKgNAkib2RZaHWP9bM0hC62=Nm5sBisQf_D9BAKNomjEPvCWbA@mail.gmail.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Sun, 21 Oct 2012 09:36:23 +0200
Message-ID: <CAKgNAkghLrh61FvxcuQ3xKfX7=o-PhV390RN+9Ni+3fgJzMFJA@mail.gmail.com>
Subject: Re: [Request for review] Revised delete_module(2) manual page
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        linux-man <linux-man@vger.kernel.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Jon Masters <jonathan@jonmasters.org>
Content-Type: multipart/mixed; boundary=14dae9340e357a362c04cc8ccccc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--14dae9340e357a362c04cc8ccccc
Content-Type: text/plain; charset=ISO-8859-1

Ping!

Rusty (et al.) I'm pretty sure the new page text is okay, but I would
like someone knowledgeable to confirm.

Thanks,

Michael

---------- Forwarded message ----------
From: Michael Kerrisk (man-pages) <mtk.manpages@gmail.com>
Date: Fri, Oct 12, 2012 at 10:47 AM
Subject: Re: [Request for review] Revised delete_module(2) manual page


Hi Rusty,

Thanks for taking a look at this page. In the light of your comments,
I've substantially reworked the page, and further review would not go
amiss, in case I made a misstep along the way.

On Thu, Oct 11, 2012 at 5:02 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>
>> Hello Kees, Rusty,
>>
>> The current delete_module(2) page is severely out of date (basically,
>> its content corresponds to 2.4 days, and was even pretty thin in
>> covering that). So, I took a shot at revising the page to Linux 2.6+
>> reality. Would it be possible that you could review it?
>
> OK.  Main suggestion is that I discussed with Lucas removing the
> !O_NONBLOCK case.  It's not supported by modprobe -r, and almost
> unheard-of for rmmod (it's --wait).
>
> In practice, people want the unload-or-fail semantics, or the
> force-unload semantics.

Okay -- I've substantially reworked the page to reflect these idea.

>> Otherwise, by default,
>> .BR delete_module ()
>> marks a module so that no new references are permitted.
>> If the module's reference count
>> (i.e., the number of processes currently using the module) is nonzero,
>> it then places the caller in an uninterruptible sleep
>> state until all reference count is zero,
>> at which point the call unblocks.
>> When the reference count reaches zero, the module is unloaded.
>
> So this should be inverted:
>
>         Otherwise (assuming O_NONBLOCK, see flags below), if the
>         module's reference count (i.e., the number of processes
>         currently using the module) is nonzero, the call fails.

Got it. See my reworked text.

[...]

> NOTES:
>
> If O_NONBLOCK is not set, then the kernel may enter uninterruptible
> sleep until the module reference count reaches zero.  This is not
> generally desirable, so this flag may be compulsory in future kernel
> configurations.

I've added some text under NOTES.

Okay, below (and attached) is the new version of the page. Let me know
of any concerns.

Cheers,

Michael


.\" Copyright (C) 2012 Michael Kerrisk <mtk.manpages@gmail.com>
.\"
.\" Permission is granted to make and distribute verbatim copies of this
.\" manual provided the copyright notice and this permission notice are
.\" preserved on all copies.
.\"
.\" Permission is granted to copy and distribute modified versions of this
.\" manual under the conditions for verbatim copying, provided that the
.\" entire resulting derived work is distributed under the terms of a
.\" permission notice identical to this one.
.\"
.\" Since the Linux kernel and libraries are constantly changing, this
.\" manual page may be incorrect or out-of-date.  The author(s) assume no
.\" responsibility for errors or omissions, or for damages resulting from
.\" the use of the information contained herein.  The author(s) may not
.\" have taken the same level of care in the production of this manual,
.\" which is licensed free of charge, as they might when working
.\" professionally.
.\"
.\" Formatted or processed versions of this manual, if unaccompanied by
.\" the source, must acknowledge the copyright and authors of this work.
.\"
.TH DELETE_MODULE 2 2012-10-12 "Linux" "Linux Programmer's Manual"
.SH NAME
delete_module \- unload a kernel module
.SH SYNOPSIS
.nf
.BI "int delete_module(const char *" name ", int " flags );
.fi

.IR Note :
There is no glibc wrapper for this system call; see NOTES.
.SH DESCRIPTION
The
.BR delete_module ()
system call attempts to remove the unused loadable module entry
identified by
.IR name .
If the module has an
.I exit
function, then that function is executed before unloading the module.
The
.IR flags
argument is used to modify the behavior of the system call,
as described below.
This system call requires privilege.

Module removal is attempted according to the following rules:
.IP 1. 4
If there are other loaded modules that depend on
(i.e., refer to symbols defined in) this module,
then the call fails.
.IP 2.
Otherwise, if the reference count for the module
(i.e., the  number  of processes currently using the module)
is zero, then the module is immediately unloaded.
.IP 3.
If a module has a nonzero reference count,
then the behavior depends on the bits set in
.IR flags .
In normal usage (see NOTES), the
.BR O_NONBLOCK
flag is always specified, and the
.BR O_TRUNC
flag may additionally be specified.
.\"     O_TRUNC == KMOD_REMOVE_FORCE in kmod library
.\"     O_NONBLOCK == KMOD_REMOVE_NOWAIT in kmod library
The various combinations for
.I flags
have the following effect:
.RS 4
.TP
.B flags == O_NONBLOCK
The call returns immediately, with an error.
.TP
.B flags == (O_NONBLOCK | O_TRUNC)
The module is unloaded immediately,
regardless of whether it has a nonzero reference count.
.TP
.B flags == 0
If
.I flags
does not specify
.BR O_NONBLOCK ,
the following steps occur:
.RS
.IP * 3
The module is marked so that no new references are permitted.
.IP *
If the module's reference count is nonzero,
the caller is placed in an uninterruptible sleep state
.RB ( TASK_UNINTERRUPTIBLE )
until the reference count is zero, at which point the call unblocks.
.IP *
The module is unloaded in the usual way.
.RE
.RE
.PP
The
.B O_TRUNC
flag has one further effect on the rules described above.
By default,
attempting to remove a module that has an
.I init
function but no
.I exit
function fails.
However, if
.BR O_TRUNC
was specified, this requirement is bypassed.
.PP
Using the
.B O_TRUNC
flag is dangerous!
If the kernel was not built with
.BR CONFIG_MODULE_FORCE_UNLOAD ,
this flag is silently ignored.
(Normally ,
.BR CONFIG_MODULE_FORCE_UNLOAD
is enabled.)
Using this flag taints the kernel (TAINT_FORCED_RMMOD).
.SH "RETURN VALUE"
On success, zero is returned.
On error, \-1 is returned and
.I errno
is set appropriately.
.SH ERRORS
.TP
.B EBUSY
The module is not "live"
(i.e., it is still being initialized or is already marked for removal);
or, the module has
an
.I init
function but has no
.I exit
function, and
.B O_TRUNC
was not specified in
.IR flags .

.TP
.B EFAULT
.I name
refers to a location outside the process's accessible address space.
.TP
.B ENOENT
No module by that name exists.
.TP
.B EPERM
The caller was not privileged
(did not have the
.B CAP_SYS_MODULE
capability),
or module unloading is disabled
(see
.IR /proc/sys/kernel/modules_disabled
in
.BR proc (5)).
.TP
.B EWOULDBLOCK
Other modules depend on this module;
or,
.BR O_NONBLOCK
was specified in
.IR flags ,
but the reference count of this module is nonzero and
.B O_TRUNC
was not specified in
.IR flags .
.SH "CONFORMING TO"
.BR delete_module ()
is Linux-specific.
.SH NOTES
Glibc does not provide a wrapper for this system call; call it using
.BR syscall (2).

The unininterruptible sleep that may occur if
.BR O_NONBLOCK
is omitted from
.IR flags
is considered undesirable, because the sleeping process is left
in an unkillable state.
As at Linux 3.7, specifying
.BR O_NONBLOCK
is optional, but in future kernels it is likely to become mandatory.
.SS Linux 2.4 and earlier
In Linux 2.4 and earlier, the system call took only one argument:

.BI "   int delete_module(const char *" name );

If
.I name
is NULL, all unused modules marked auto-clean are removed.

Some further details of differences in the behavior of
.BR delete_module ()
in Linux 2.4 and earlier are
.I not
currently explained in this manual page.
.SH "SEE ALSO"
.BR create_module (2),
.BR init_module (2),
.BR query_module (2),
.BR lsmod (8),
.BR rmmod (8)

--14dae9340e357a362c04cc8ccccc
Content-Type: application/octet-stream; name="delete_module.2"
Content-Disposition: attachment; filename="delete_module.2"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h8ju9pto1

LlwiIENvcHlyaWdodCAoQykgMjAxMiBNaWNoYWVsIEtlcnJpc2sgPG10ay5tYW5wYWdlc0BnbWFp
bC5jb20+Ci5cIgouXCIgUGVybWlzc2lvbiBpcyBncmFudGVkIHRvIG1ha2UgYW5kIGRpc3RyaWJ1
dGUgdmVyYmF0aW0gY29waWVzIG9mIHRoaXMKLlwiIG1hbnVhbCBwcm92aWRlZCB0aGUgY29weXJp
Z2h0IG5vdGljZSBhbmQgdGhpcyBwZXJtaXNzaW9uIG5vdGljZSBhcmUKLlwiIHByZXNlcnZlZCBv
biBhbGwgY29waWVzLgouXCIKLlwiIFBlcm1pc3Npb24gaXMgZ3JhbnRlZCB0byBjb3B5IGFuZCBk
aXN0cmlidXRlIG1vZGlmaWVkIHZlcnNpb25zIG9mIHRoaXMKLlwiIG1hbnVhbCB1bmRlciB0aGUg
Y29uZGl0aW9ucyBmb3IgdmVyYmF0aW0gY29weWluZywgcHJvdmlkZWQgdGhhdCB0aGUKLlwiIGVu
dGlyZSByZXN1bHRpbmcgZGVyaXZlZCB3b3JrIGlzIGRpc3RyaWJ1dGVkIHVuZGVyIHRoZSB0ZXJt
cyBvZiBhCi5cIiBwZXJtaXNzaW9uIG5vdGljZSBpZGVudGljYWwgdG8gdGhpcyBvbmUuCi5cIgou
XCIgU2luY2UgdGhlIExpbnV4IGtlcm5lbCBhbmQgbGlicmFyaWVzIGFyZSBjb25zdGFudGx5IGNo
YW5naW5nLCB0aGlzCi5cIiBtYW51YWwgcGFnZSBtYXkgYmUgaW5jb3JyZWN0IG9yIG91dC1vZi1k
YXRlLiAgVGhlIGF1dGhvcihzKSBhc3N1bWUgbm8KLlwiIHJlc3BvbnNpYmlsaXR5IGZvciBlcnJv
cnMgb3Igb21pc3Npb25zLCBvciBmb3IgZGFtYWdlcyByZXN1bHRpbmcgZnJvbQouXCIgdGhlIHVz
ZSBvZiB0aGUgaW5mb3JtYXRpb24gY29udGFpbmVkIGhlcmVpbi4gIFRoZSBhdXRob3IocykgbWF5
IG5vdAouXCIgaGF2ZSB0YWtlbiB0aGUgc2FtZSBsZXZlbCBvZiBjYXJlIGluIHRoZSBwcm9kdWN0
aW9uIG9mIHRoaXMgbWFudWFsLAouXCIgd2hpY2ggaXMgbGljZW5zZWQgZnJlZSBvZiBjaGFyZ2Us
IGFzIHRoZXkgbWlnaHQgd2hlbiB3b3JraW5nCi5cIiBwcm9mZXNzaW9uYWxseS4KLlwiCi5cIiBG
b3JtYXR0ZWQgb3IgcHJvY2Vzc2VkIHZlcnNpb25zIG9mIHRoaXMgbWFudWFsLCBpZiB1bmFjY29t
cGFuaWVkIGJ5Ci5cIiB0aGUgc291cmNlLCBtdXN0IGFja25vd2xlZGdlIHRoZSBjb3B5cmlnaHQg
YW5kIGF1dGhvcnMgb2YgdGhpcyB3b3JrLgouXCIKLlRIIERFTEVURV9NT0RVTEUgMiAyMDEyLTEw
LTE4ICJMaW51eCIgIkxpbnV4IFByb2dyYW1tZXIncyBNYW51YWwiCi5TSCBOQU1FCmRlbGV0ZV9t
b2R1bGUgXC0gdW5sb2FkIGEga2VybmVsIG1vZHVsZQouU0ggU1lOT1BTSVMKLm5mCi5CSSAiaW50
IGRlbGV0ZV9tb2R1bGUoY29uc3QgY2hhciAqIiBuYW1lICIsIGludCAiIGZsYWdzICk7Ci5maQoK
LklSIE5vdGUgOgpUaGVyZSBpcyBubyBnbGliYyB3cmFwcGVyIGZvciB0aGlzIHN5c3RlbSBjYWxs
OyBzZWUgTk9URVMuCi5TSCBERVNDUklQVElPTgpUaGUKLkJSIGRlbGV0ZV9tb2R1bGUgKCkKc3lz
dGVtIGNhbGwgYXR0ZW1wdHMgdG8gcmVtb3ZlIHRoZSB1bnVzZWQgbG9hZGFibGUgbW9kdWxlIGVu
dHJ5CmlkZW50aWZpZWQgYnkKLklSIG5hbWUgLgpJZiB0aGUgbW9kdWxlIGhhcyBhbgouSSBleGl0
CmZ1bmN0aW9uLCB0aGVuIHRoYXQgZnVuY3Rpb24gaXMgZXhlY3V0ZWQgYmVmb3JlIHVubG9hZGlu
ZyB0aGUgbW9kdWxlLgpUaGUKLklSIGZsYWdzCmFyZ3VtZW50IGlzIHVzZWQgdG8gbW9kaWZ5IHRo
ZSBiZWhhdmlvciBvZiB0aGUgc3lzdGVtIGNhbGwsCmFzIGRlc2NyaWJlZCBiZWxvdy4KVGhpcyBz
eXN0ZW0gY2FsbCByZXF1aXJlcyBwcml2aWxlZ2UuCgpNb2R1bGUgcmVtb3ZhbCBpcyBhdHRlbXB0
ZWQgYWNjb3JkaW5nIHRvIHRoZSBmb2xsb3dpbmcgcnVsZXM6Ci5JUCAxLiA0CklmIHRoZXJlIGFy
ZSBvdGhlciBsb2FkZWQgbW9kdWxlcyB0aGF0IGRlcGVuZCBvbgooaS5lLiwgcmVmZXIgdG8gc3lt
Ym9scyBkZWZpbmVkIGluKSB0aGlzIG1vZHVsZSwKdGhlbiB0aGUgY2FsbCBmYWlscy4KLklQIDIu
Ck90aGVyd2lzZSwgaWYgdGhlIHJlZmVyZW5jZSBjb3VudCBmb3IgdGhlIG1vZHVsZQooaS5lLiwg
dGhlICBudW1iZXIgIG9mIHByb2Nlc3NlcyBjdXJyZW50bHkgdXNpbmcgdGhlIG1vZHVsZSkKaXMg
emVybywgdGhlbiB0aGUgbW9kdWxlIGlzIGltbWVkaWF0ZWx5IHVubG9hZGVkLgouSVAgMy4KSWYg
YSBtb2R1bGUgaGFzIGEgbm9uemVybyByZWZlcmVuY2UgY291bnQsCnRoZW4gdGhlIGJlaGF2aW9y
IGRlcGVuZHMgb24gdGhlIGJpdHMgc2V0IGluCi5JUiBmbGFncyAuCkluIG5vcm1hbCB1c2FnZSAo
c2VlIE5PVEVTKSwgdGhlCi5CUiBPX05PTkJMT0NLCmZsYWcgaXMgYWx3YXlzIHNwZWNpZmllZCwg
YW5kIHRoZQouQlIgT19UUlVOQwpmbGFnIG1heSBhZGRpdGlvbmFsbHkgYmUgc3BlY2lmaWVkLgou
XCIgIAlPX1RSVU5DID09IEtNT0RfUkVNT1ZFX0ZPUkNFIGluIGttb2QgbGlicmFyeQouXCIgIAlP
X05PTkJMT0NLID09IEtNT0RfUkVNT1ZFX05PV0FJVCBpbiBrbW9kIGxpYnJhcnkKClRoZSB2YXJp
b3VzIGNvbWJpbmF0aW9ucyBmb3IKLkkgZmxhZ3MKaGF2ZSB0aGUgZm9sbG93aW5nIGVmZmVjdDoK
LlJTIDQKLlRQCi5CIGZsYWdzID09IE9fTk9OQkxPQ0sKVGhlIGNhbGwgcmV0dXJucyBpbW1lZGlh
dGVseSwgd2l0aCBhbiBlcnJvci4KLlRQCi5CIGZsYWdzID09IChPX05PTkJMT0NLIHwgT19UUlVO
QykKVGhlIG1vZHVsZSBpcyB1bmxvYWRlZCBpbW1lZGlhdGVseSwKcmVnYXJkbGVzcyBvZiB3aGV0
aGVyIGl0IGhhcyBhIG5vbnplcm8gcmVmZXJlbmNlIGNvdW50LgouVFAKLkIgKGZsYWdzICYgT19O
T05CTE9DSykgPT0gMApJZgouSSBmbGFncwpkb2VzIG5vdCBzcGVjaWZ5Ci5CUiBPX05PTkJMT0NL
ICwKdGhlIGZvbGxvd2luZyBzdGVwcyBvY2N1cjoKLlJTCi5JUCAqIDMKVGhlIG1vZHVsZSBpcyBt
YXJrZWQgc28gdGhhdCBubyBuZXcgcmVmZXJlbmNlcyBhcmUgcGVybWl0dGVkLgouSVAgKgpJZiB0
aGUgbW9kdWxlJ3MgcmVmZXJlbmNlIGNvdW50IGlzIG5vbnplcm8sCnRoZSBjYWxsZXIgaXMgcGxh
Y2VkIGluIGFuIHVuaW50ZXJydXB0aWJsZSBzbGVlcCBzdGF0ZQouUkIgKCBUQVNLX1VOSU5URVJS
VVBUSUJMRSApCnVudGlsIHRoZSByZWZlcmVuY2UgY291bnQgaXMgemVybywgYXQgd2hpY2ggcG9p
bnQgdGhlIGNhbGwgdW5ibG9ja3MuCi5JUCAqClRoZSBtb2R1bGUgaXMgdW5sb2FkZWQgaW4gdGhl
IHVzdWFsIHdheS4KLlJFCi5SRQouUFAKVGhlCi5CIE9fVFJVTkMKZmxhZyBoYXMgb25lIGZ1cnRo
ZXIgZWZmZWN0IG9uIHRoZSBydWxlcyBkZXNjcmliZWQgYWJvdmUuCkJ5IGRlZmF1bHQsCmF0dGVt
cHRpbmcgdG8gcmVtb3ZlIGEgbW9kdWxlIHRoYXQgaGFzIGFuCi5JIGluaXQKZnVuY3Rpb24gYnV0
IG5vCi5JIGV4aXQgCmZ1bmN0aW9uIGZhaWxzLgpIb3dldmVyLCBpZgouQlIgT19UUlVOQwp3YXMg
c3BlY2lmaWVkLCB0aGlzIHJlcXVpcmVtZW50IGlzIGJ5cGFzc2VkLgouUFAKVXNpbmcgdGhlIAou
QiBPX1RSVU5DCmZsYWcgaXMgZGFuZ2Vyb3VzIQpJZiB0aGUga2VybmVsIHdhcyBub3QgYnVpbHQg
d2l0aAouQlIgQ09ORklHX01PRFVMRV9GT1JDRV9VTkxPQUQgLAp0aGlzIGZsYWcgaXMgc2lsZW50
bHkgaWdub3JlZC4KKE5vcm1hbGx5ICwKLkJSIENPTkZJR19NT0RVTEVfRk9SQ0VfVU5MT0FECmlz
IGVuYWJsZWQuKQpVc2luZyB0aGlzIGZsYWcgdGFpbnRzIHRoZSBrZXJuZWwgKFRBSU5UX0ZPUkNF
RF9STU1PRCkuCi5TSCAiUkVUVVJOIFZBTFVFIgpPbiBzdWNjZXNzLCB6ZXJvIGlzIHJldHVybmVk
LgpPbiBlcnJvciwgXC0xIGlzIHJldHVybmVkIGFuZAouSSBlcnJubwppcyBzZXQgYXBwcm9wcmlh
dGVseS4KLlNIIEVSUk9SUwouVFAKLkIgRUJVU1kKVGhlIG1vZHVsZSBpcyBub3QgImxpdmUiCihp
LmUuLCBpdCBpcyBzdGlsbCBiZWluZyBpbml0aWFsaXplZCBvciBpcyBhbHJlYWR5IG1hcmtlZCBm
b3IgcmVtb3ZhbCk7Cm9yLCB0aGUgbW9kdWxlIGhhcwphbgouSSBpbml0CmZ1bmN0aW9uIGJ1dCBo
YXMgbm8KLkkgZXhpdApmdW5jdGlvbiwgYW5kCi5CIE9fVFJVTkMKd2FzIG5vdCBzcGVjaWZpZWQg
aW4KLklSIGZsYWdzIC4KCi5UUAouQiBFRkFVTFQKLkkgbmFtZQpyZWZlcnMgdG8gYSBsb2NhdGlv
biBvdXRzaWRlIHRoZSBwcm9jZXNzJ3MgYWNjZXNzaWJsZSBhZGRyZXNzIHNwYWNlLgouVFAKLkIg
RU5PRU5UCk5vIG1vZHVsZSBieSB0aGF0IG5hbWUgZXhpc3RzLgouVFAKLkIgRVBFUk0KVGhlIGNh
bGxlciB3YXMgbm90IHByaXZpbGVnZWQKKGRpZCBub3QgaGF2ZSB0aGUKLkIgQ0FQX1NZU19NT0RV
TEUKY2FwYWJpbGl0eSksCm9yIG1vZHVsZSB1bmxvYWRpbmcgaXMgZGlzYWJsZWQKKHNlZQouSVIg
L3Byb2Mvc3lzL2tlcm5lbC9tb2R1bGVzX2Rpc2FibGVkCmluCi5CUiBwcm9jICg1KSkuCi5UUAou
QiBFV09VTERCTE9DSwpPdGhlciBtb2R1bGVzIGRlcGVuZCBvbiB0aGlzIG1vZHVsZTsKb3IsCi5C
UiBPX05PTkJMT0NLCndhcyBzcGVjaWZpZWQgaW4KLklSIGZsYWdzICwKYnV0IHRoZSByZWZlcmVu
Y2UgY291bnQgb2YgdGhpcyBtb2R1bGUgaXMgbm9uemVybyBhbmQgCi5CIE9fVFJVTkMKd2FzIG5v
dCBzcGVjaWZpZWQgaW4KLklSIGZsYWdzIC4KLlNIICJDT05GT1JNSU5HIFRPIgouQlIgZGVsZXRl
X21vZHVsZSAoKQppcyBMaW51eC1zcGVjaWZpYy4KLlNIIE5PVEVTCkdsaWJjIGRvZXMgbm90IHBy
b3ZpZGUgYSB3cmFwcGVyIGZvciB0aGlzIHN5c3RlbSBjYWxsOyBjYWxsIGl0IHVzaW5nCi5CUiBz
eXNjYWxsICgyKS4KClRoZSB1bmluaW50ZXJydXB0aWJsZSBzbGVlcCB0aGF0IG1heSBvY2N1ciBp
ZgouQlIgT19OT05CTE9DSwppcyBvbWl0dGVkIGZyb20KLklSIGZsYWdzCmlzIGNvbnNpZGVyZWQg
dW5kZXNpcmFibGUsIGJlY2F1c2UgdGhlIHNsZWVwaW5nIHByb2Nlc3MgaXMgbGVmdAppbiBhbiB1
bmtpbGxhYmxlIHN0YXRlLgpBcyBhdCBMaW51eCAzLjcsIHNwZWNpZnlpbmcKLkJSIE9fTk9OQkxP
Q0sKaXMgb3B0aW9uYWwsIGJ1dCBpbiBmdXR1cmUga2VybmVscyBpdCBpcyBsaWtlbHkgdG8gYmVj
b21lIG1hbmRhdG9yeS4KLlNTIExpbnV4IDIuNCBhbmQgZWFybGllcgpJbiBMaW51eCAyLjQgYW5k
IGVhcmxpZXIsIHRoZSBzeXN0ZW0gY2FsbCB0b29rIG9ubHkgb25lIGFyZ3VtZW50OgoKLkJJICIg
ICBpbnQgZGVsZXRlX21vZHVsZShjb25zdCBjaGFyICoiIG5hbWUgKTsKCklmCi5JIG5hbWUKaXMg
TlVMTCwgYWxsIHVudXNlZCBtb2R1bGVzIG1hcmtlZCBhdXRvLWNsZWFuIGFyZSByZW1vdmVkLgoK
U29tZSBmdXJ0aGVyIGRldGFpbHMgb2YgZGlmZmVyZW5jZXMgaW4gdGhlIGJlaGF2aW9yIG9mCi5C
UiBkZWxldGVfbW9kdWxlICgpCmluIExpbnV4IDIuNCBhbmQgZWFybGllciBhcmUKLkkgbm90CmN1
cnJlbnRseSBleHBsYWluZWQgaW4gdGhpcyBtYW51YWwgcGFnZS4KLlNIICJTRUUgQUxTTyIKLkJS
IGNyZWF0ZV9tb2R1bGUgKDIpLAouQlIgaW5pdF9tb2R1bGUgKDIpLAouQlIgcXVlcnlfbW9kdWxl
ICgyKSwKLkJSIGxzbW9kICg4KSwKLkJSIHJtbW9kICg4KQo=
--14dae9340e357a362c04cc8ccccc--
