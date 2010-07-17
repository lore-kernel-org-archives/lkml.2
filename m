Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142Ab0GQUCS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 16:02:18 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61534 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab0GQUCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 16:02:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Lnhkb7RpVtvTmjyILkGC9kZSgxgW7S4ix+MH6736BeZ1pZYxd6Qc+KbnBAE+5my8vp
         OYv2afmrLEuRYgDWi/fWyO6M3sMtWLvFH2x0HIKffRjKSynbfCpwQd1UZN+fgNd5+Sef
         GEpbk6ZiMNVVwLGvHMxrYbOPiw+6xGGaiq7tw=
MIME-Version: 1.0
In-Reply-To: <AANLkTinbj4ScYca7WlnUiIKgsVkVbQwEO4ypgxFe5Zbo@mail.gmail.com>
References: <AANLkTimhqRAMjaVNwo50GJO9B6kTzySWVtK04gEdu0rg@mail.gmail.com>
	<4C37C365.6090508@gmail.com>
	<AANLkTilH9Hn0MHvfOEOyEeRmDcPTrRXIFB3K8pq31yIH@mail.gmail.com>
	<AANLkTikZCBrZwROGgGTj-JREywN3fUnvaANtTGgkok--@mail.gmail.com>
	<AANLkTinbj4ScYca7WlnUiIKgsVkVbQwEO4ypgxFe5Zbo@mail.gmail.com>
Date: Sat, 17 Jul 2010 13:02:16 -0700
Message-ID: <AANLkTinSjNHPyariuoUuYZCRcbTf8nQALma81I4CPdsv@mail.gmail.com>
Subject: Re: Interrupt Affinity in SMP
From: Bryan Hundven <bryanhundven@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org, mchehab@redhat.com
Content-Type: multipart/mixed; boundary=000e0cd18116e7f49a048b9acfdb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd18116e7f49a048b9acfdb
Content-Type: text/plain; charset=UTF-8

On Sat, Jul 10, 2010 at 6:20 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
> On Sat, Jul 10, 2010 at 1:46 PM, Bryan Hundven <bryanhundven@gmail.com> wrote:
>> I was able to set eth0 and it's TxRx queues to cpu1, but it is my
>> understanding that 0xFFFFFFFF should distribute the interrupts across all
>> cpus, much like LOC in my output of /proc/interrupts.
>>
>> I don't have access to the computer this weekend, but I will provide more
>> info on Monday.
>
> That may be chipset dependent, I don't think all chipsets have the
> ability to distribute the interrupts like that. Round-robin interrupt
> distribution for a given handler isn't optimal for performance anyway
> since it causes the relevant cache lines for the interrupt handler to
> be ping-ponged between the different CPUs.
>
>>
>> -bryan
>>
>> On Jul 9, 2010 5:48 PM, "Robert Hancock" <hancockrwd@gmail.com> wrote:
>>
>> On 07/09/2010 04:59 PM, Bryan Hundven wrote:
>>>
>>> Mauro, list,
>>>
>>> (please CC me in replies, I am not...
>>
>> Tried changing these files to exclude CPU0?
>>
>> Have you tried running the irqbalance daemon? That's what you likely want to
>> be doing anyway..
>>
>>> =====8<=====8<=====8<=====8<=====8<=====8<=====8<=====8<=====8<=====
>>>
>>> =====8<=====8<=====8<==...
>

Please see the two attached examples.

Notice on the 5410 example how we start with the affinity set to 0xff,
and change it to 0xf0.
This should spread the interrupts over the last 4 cores of this quad
core - dual processor system.

Also notice on the 5645 example, with the same commands we start with
0xffffff and change to 0xfff000 to spread the interrupts over the last
12 cores, but only the first of the last twelve cores receive
interrupts.

This is the inconsistency I was trying to explain before.

--Bryan

--000e0cd18116e7f49a048b9acfdb
Content-Type: text/plain; charset=US-ASCII; name="xeon5410-2.6.32.txt"
Content-Disposition: attachment; filename="xeon5410-2.6.32.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gbqvoj010

IyB1bmFtZSAtYSAKTGludXggaHVzdGxlIDIuNi4zMi0zLWFtZDY0ICMxIFNNUCBXZWQgRmViIDI0
IDE4OjA3OjQyIFVUQyAyMDEwIHg4Nl82NCBHTlUvTGludXgKCiMgY2F0IC9wcm9jL2NwdWluZm8K
Li4uCnByb2Nlc3NvciAgICAgICA6IDcKdmVuZG9yX2lkICAgICAgIDogR2VudWluZUludGVsCmNw
dSBmYW1pbHkgICAgICA6IDYKbW9kZWwgICAgICAgICAgIDogMjMKbW9kZWwgbmFtZSAgICAgIDog
SW50ZWwoUikgWGVvbihSKSBDUFUgICAgICAgICAgIEU1NDEwICBAIDIuMzNHSHoKc3RlcHBpbmcg
ICAgICAgIDogNgpjcHUgTUh6ICAgICAgICAgOiAyMzI3LjU3NwpjYWNoZSBzaXplICAgICAgOiA2
MTQ0IEtCCnBoeXNpY2FsIGlkICAgICA6IDEKc2libGluZ3MgICAgICAgIDogNApjb3JlIGlkICAg
ICAgICAgOiAzCmNwdSBjb3JlcyAgICAgICA6IDQKYXBpY2lkICAgICAgICAgIDogNwppbml0aWFs
IGFwaWNpZCAgOiA3CmZwdSAgICAgICAgICAgICA6IHllcwpmcHVfZXhjZXB0aW9uICAgOiB5ZXMK
Y3B1aWQgbGV2ZWwgICAgIDogMTAKd3AgICAgICAgICAgICAgIDogeWVzCmZsYWdzICAgICAgICAg
ICA6IGZwdSB2bWUgZGUgcHNlIHRzYyBtc3IgcGFlIG1jZSBjeDggYXBpYyBzZXAgbXRyciBwZ2Ug
bWNhIGNtb3YgcGF0IHBzZTM2IGNsZmx1c2ggZHRzIGFjcGkgbW14IGZ4c3Igc3NlIHNzZTIgc3Mg
aHQgdG0gcGJlIHN5c2NhbGwgbnggbG0gY29uc3RhbnRfdHNjIGFyY2hfcGVyZm1vbiBwZWJzIGJ0
cyByZXBfZ29vZCBhcGVyZm1wZXJmIHBuaSBkdGVzNjQgbW9uaXRvciBkc19jcGwgdm14IGVzdCB0
bTIgc3NzZTMgY3gxNiB4dHByIHBkY20gZGNhIHNzZTRfMSBsYWhmX2xtIHRwcl9zaGFkb3cgdm5t
aSBmbGV4cHJpb3JpdHkKYm9nb21pcHMgICAgICAgIDogNDY1NS4zMwpjbGZsdXNoIHNpemUgICAg
OiA2NApjYWNoZV9hbGlnbm1lbnQgOiA2NAphZGRyZXNzIHNpemVzICAgOiAzOCBiaXRzIHBoeXNp
Y2FsLCA0OCBiaXRzIHZpcnR1YWwKcG93ZXIgbWFuYWdlbWVudDoKCiMgSGVhZGVyIGZvciAvcHJv
Yy9pbnRlcnJ1cHRzIGZvciByZWZlcmVuY2UuLi4KIyAgICAgICAgICBDUFUwICAgICAgIENQVTEg
ICAgICAgQ1BVMiAgICAgICBDUFUzICAgICAgIENQVTQgICAgICAgQ1BVNSAgICAgICBDUFU2ICAg
ICAgIENQVTcKCiMgZ3JlcCAnXiA2NCcgL3Byb2MvaW50ZXJydXB0cyAmJiBzbGVlcCAxNSAmJiBn
cmVwICdeIDY0JyAvcHJvYy9pbnRlcnJ1cHRzIAogNjQ6ICAgIDgyMDE0MTcgICAgODIwMTUyOSAg
ICA4MjAwMjc2ICAgIDgxOTc0MjEgICAgODIwMDI1MCAgICA4MjAwMzA0ICAgIDgyMDEyMzIgICAg
ODIwMTA5MiAgIFBDSS1NU0ktZWRnZSAgICAgIGV0aDAKIDY0OiAgICA4MjAxNDMwICAgIDgyMDE1
NDIgICAgODIwMDI4OCAgICA4MTk3NDMyICAgIDgyMDAyNjIgICAgODIwMDMxNiAgICA4MjAxMjQz
ICAgIDgyMDExMDYgICBQQ0ktTVNJLWVkZ2UgICAgICBldGgwCgojIGVjaG8gImYwIiA+IC9wcm9j
L2lycS82NC9zbXBfYWZmaW5pdHkKIyBncmVwICdeIDY0JyAvcHJvYy9pbnRlcnJ1cHRzICYmIHNs
ZWVwIDE1ICYmIGdyZXAgJ14gNjQnIC9wcm9jL2ludGVycnVwdHMgCiA2NDogICAgODIwMTQ3NiAg
ICA4MjAxNTk1ICAgIDgyMDAzMzIgICAgODE5NzQ3NCAgICA4MjAwMzExICAgIDgyMDAzNjQgICAg
ODIwMTI5MiAgICA4MjAxMTU5ICAgUENJLU1TSS1lZGdlICAgICAgZXRoMAogNjQ6ICAgIDgyMDE0
NzYgICAgODIwMTU5NSAgICA4MjAwMzMyICAgIDgxOTc0NzQgICAgODIwMDMyNyAgICA4MjAwMzgx
ICAgIDgyMDEzMDggICAgODIwMTE3NSAgIFBDSS1NU0ktZWRnZSAgICAgIGV0aDAKCiMgTm90ZSB0
aGF0IG5vdyBpbnRlcnJ1cHRzIGFyZSBvbmx5IG9jdXJyaW5nIG9uIHRoZSBsYXN0IGZvdXIgcHJv
Y2Vzc29ycwo=
--000e0cd18116e7f49a048b9acfdb
Content-Type: text/plain; charset=US-ASCII; name="xeon5645-2.6.35-rc4.txt"
Content-Disposition: attachment; filename="xeon5645-2.6.35-rc4.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gbqvorg71

IyB1bmFtZSAtYSAKTGludXggKG5vbmUpIDIuNi4zNS1yYzQgIzEgU01QIEZyaSBKdWwgOSAxNjox
NToxNSBQRFQgMjAxMCBpNjg2IHVua25vd24KCiMgY2F0IC9wcm9jL2NwdWluZm8KLi4uCnByb2Nl
c3NvciAgICAgICA6IDIzCnZlbmRvcl9pZCAgICAgICA6IEdlbnVpbmVJbnRlbApjcHUgZmFtaWx5
ICAgICAgOiA2Cm1vZGVsICAgICAgICAgICA6IDQ0Cm1vZGVsIG5hbWUgICAgICA6IEludGVsKFIp
IFhlb24oUikgQ1BVICAgICAgICAgICBFNTY0NSAgQCAyLjQwR0h6CnN0ZXBwaW5nICAgICAgICA6
IDIKY3B1IE1IeiAgICAgICAgIDogMjM5OS44NzAKY2FjaGUgc2l6ZSAgICAgIDogMTIyODggS0IK
cGh5c2ljYWwgaWQgICAgIDogMQpzaWJsaW5ncyAgICAgICAgOiAxMgpjb3JlIGlkICAgICAgICAg
OiAxMApjcHUgY29yZXMgICAgICAgOiA2CmFwaWNpZCAgICAgICAgICA6IDUzCmluaXRpYWwgYXBp
Y2lkICA6IDUzCmZkaXZfYnVnICAgICAgICA6IG5vCmhsdF9idWcgICAgICAgICA6IG5vCmYwMGZf
YnVnICAgICAgICA6IG5vCmNvbWFfYnVnICAgICAgICA6IG5vCmZwdSAgICAgICAgICAgICA6IHll
cwpmcHVfZXhjZXB0aW9uICAgOiB5ZXMKY3B1aWQgbGV2ZWwgICAgIDogMTEKd3AgICAgICAgICAg
ICAgIDogeWVzCmZsYWdzICAgICAgICAgICA6IGZwdSB2bWUgZGUgcHNlIHRzYyBtc3IgcGFlIG1j
ZSBjeDggYXBpYyBzZXAgbXRyciBwZ2UgbWNhIGNtb3YgcGF0IHBzZTM2IGNsZmx1c2ggZHRzIGFj
cGkgbW14IGZ4c3Igc3NlIHNzZTIgc3MgaHQgdG0gcGJlIG54IHBkcGUxZ2IgcmR0c2NwIGxtIGNv
bnN0YW50X3RzYyBhcmNoX3BlcmZtb24gcGVicyBidHMgeHRvcG9sb2d5IG5vbnN0b3BfdHNjIGFw
ZXJmbXBlcmYgcG5pIHBjbG11bHFkcSBkdGVzNjQgbW9uaXRvciBkc19jcGwgdm14IHNteCBlc3Qg
dG0yIHNzc2UzIGN4MTYgeHRwciBwZGNtIGRjYSBzc2U0XzEgc3NlNF8yIHBvcGNudCBhZXMgbGFo
Zl9sbSBhcmF0IHRwcl9zaGFkb3cgdm5taSBmbGV4cHJpb3JpdHkgZXB0IHZwaWQKYm9nb21pcHMg
ICAgICAgIDogNDgwMS45MwpjbGZsdXNoIHNpemUgICAgOiA2NApjYWNoZV9hbGlnbm1lbnQgOiA2
NAphZGRyZXNzIHNpemVzICAgOiA0MCBiaXRzIHBoeXNpY2FsLCA0OCBiaXRzIHZpcnR1YWwKcG93
ZXIgbWFuYWdlbWVudDoKCiMgY2F0IC9wcm9jL2lycS84Ni9zbXBfYWZmaW5pdHkgCmZmZmZmZgoK
IyBIZWFkZXIgZm9yIC9wcm9jL2ludGVycnVwdHMgZm9yIHJlZmVyZW5jZS4uLgojICAgICAgICAg
ICBDUFUwICAgICAgIENQVTEgICAgICAgQ1BVMiAgICAgICBDUFUzICAgICAgIENQVTQgICAgICAg
Q1BVNSAgICAgICBDUFU2ICAgICAgIENQVTcgICAgICAgQ1BVOCAgICAgICBDUFU5ICAgICAgIENQ
VTEwICAgICAgQ1BVMTEgICAgICBDUFUxMiAgICAgIENQVTEzICAgICAgQ1BVMTQgICAgICBDUFUx
NSAgICAgIENQVTE2ICAgICAgQ1BVMTcgICAgICBDUFUxOCAgICAgIENQVTE5ICAgICAgQ1BVMjAg
ICAgICBDUFUyMSAgICAgIENQVTIyICAgICAgQ1BVMjMKCiMgZ3JlcCAnXiAgODYnIC9wcm9jL2lu
dGVycnVwdHMgJiYgc2xlZXAgMTUgJiYgZ3JlcCAnXiAgODYnIC9wcm9jL2ludGVycnVwdHMKICA4
NjogICAgICA4NzU3MCAgICAgICAgICAwICAgICAgICAgIDAgICAgICAgICAgMCAgICAgICAgICAw
ICAgICAgICAgIDAgICAgICAgICAgMCAgICAgICAgICAwICAgICAgICAgIDAgICAgICAgICAgMCAg
ICAgICAgICAwICAgICAgICAgIDAgICAgICAgICAgMCAgICAgICAgICAwICAgICAgICAgIDAgICAg
ICAgICAgMCAgICAgICAgICAwICAgICAgICAgIDAgICAgICAgICAgMCAgICAgICAgICAwICAgICAg
ICAgIDAgICAgICAgICAgMCAgICAgICAgICAwICAgICAgICAgIDAgICBQQ0ktTVNJLWVkZ2UgICAg
ICBldGgwLVR4UngtMAogIDg2OiAgICAgIDg3NTc3ICAgICAgICAgIDAgICAgICAgICAgMCAgICAg
ICAgICAwICAgICAgICAgIDAgICAgICAgICAgMCAgICAgICAgICAwICAgICAgICAgIDAgICAgICAg
ICAgMCAgICAgICAgICAwICAgICAgICAgIDAgICAgICAgICAgMCAgICAgICAgICAwICAgICAgICAg
IDAgICAgICAgICAgMCAgICAgICAgICAwICAgICAgICAgIDAgICAgICAgICAgMCAgICAgICAgICAw
ICAgICAgICAgIDAgICAgICAgICAgMCAgICAgICAgICAwICAgICAgICAgIDAgICAgICAgICAgMCAg
IFBDSS1NU0ktZWRnZSAgICAgIGV0aDAtVHhSeC0wCgojIGVjaG8gImZmZjAwMCIgPiAvcHJvYy9p
cnEvODYvc21wX2FmZmluaXR5CiMgZ3JlcCAnXiAgODYnIC9wcm9jL2ludGVycnVwdHMgJiYgc2xl
ZXAgMTUgJiYgZ3JlcCAnXiAgODYnIC9wcm9jL2ludGVycnVwdHMKICA4NjogICAgICA4NzYyNyAg
ICAgICAgICAwICAgICAgICAgIDAgICAgICAgICAgMCAgICAgICAgICAwICAgICAgICAgIDAgICAg
ICAgICAgMCAgICAgICAgICAwICAgICAgICAgIDAgICAgICAgICAgMCAgICAgICAgICAwICAgICAg
ICAgIDAgICAgICAgICAgMiAgICAgICAgICAwICAgICAgICAgIDAgICAgICAgICAgMCAgICAgICAg
ICAwICAgICAgICAgIDAgICAgICAgICAgMCAgICAgICAgICAwICAgICAgICAgIDAgICAgICAgICAg
MCAgICAgICAgICAwICAgICAgICAgIDAgICBQQ0ktTVNJLWVkZ2UgICAgICBldGgwLVR4UngtMAog
IDg2OiAgICAgIDg3NjI3ICAgICAgICAgIDAgICAgICAgICAgMCAgICAgICAgICAwICAgICAgICAg
IDAgICAgICAgICAgMCAgICAgICAgICAwICAgICAgICAgIDAgICAgICAgICAgMCAgICAgICAgICAw
ICAgICAgICAgIDAgICAgICAgICAgMCAgICAgICAgICA5ICAgICAgICAgIDAgICAgICAgICAgMCAg
ICAgICAgICAwICAgICAgICAgIDAgICAgICAgICAgMCAgICAgICAgICAwICAgICAgICAgIDAgICAg
ICAgICAgMCAgICAgICAgICAwICAgICAgICAgIDAgICAgICAgICAgMCAgIFBDSS1NU0ktZWRnZSAg
ICAgIGV0aDAtVHhSeC0wCgojIE5vdGljZSB0aGUgZGlmZmVyZW5jZSBiZXR3ZWVuIHRoZSA1NDEw
IGFuZCB0aGUgNTY0NQo=
--000e0cd18116e7f49a048b9acfdb--
