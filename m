Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab0EQTFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:05:41 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34771 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab0EQTFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:05:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KTwl6ub7JPoBcbJse6LxBEiwE4H4It/52UXoHLNkPGSlAogJzN1GNjFjdpmSmJAYAi
         0FrtmoAyQDF7Gb/T4r0jxrUxtgKtRe3TCjQ6DJ/mO+sjXKdXKJjD8xA/JUgv/4Pp7Aub
         h2amZqMSh60CIda3vBFjIjLwNcyocTrhryYpM=
MIME-Version: 1.0
In-Reply-To: <AANLkTil5NSYTF0e0DRWteyIkymSf1YErPKp25ty9eMAM@mail.gmail.com>
References: <1271945222-5283-1-git-send-email-bp@amd64.org>
	 <1271945222-5283-3-git-send-email-bp@amd64.org>
	 <AANLkTil5NSYTF0e0DRWteyIkymSf1YErPKp25ty9eMAM@mail.gmail.com>
Date: Tue, 18 May 2010 00:35:35 +0530
Message-ID: <AANLkTimIyt22QuQLJJuj4ZhleyVGdDZC8HdwgrP0kfOW@mail.gmail.com>
Subject: Re: [PATCH 2/5] x86, cacheinfo: Turn off L3 cache index disable 
	feature in virtualized environments
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Borislav Petkov <bp@amd64.org>
Cc: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, Frank Arnold <frank.arnold@amd.com>,
       Greg KH <greg@kroah.com>
Content-Type: multipart/mixed; boundary=000e0cd254d4ea2ad50486cee8b1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd254d4ea2ad50486cee8b1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello Frank and Borislav,

On Sun, May 16, 2010 at 12:59 AM, Jaswinder Singh Rajput
<jaswinderlinux@gmail.com> wrote:
> Hello Frank and Borislav,
>
> On Thu, Apr 22, 2010 at 7:36 PM, Borislav Petkov <bp@amd64.org> wrote:
>> From: Frank Arnold <frank.arnold@amd.com>
>>
>> When running a quest kernel on xen we get:
>>
>> BUG: unable to handle kernel NULL pointer dereference at 000000000000003=
8
>> IP: [<ffffffff8142f2fb>] cpuid4_cache_lookup_regs+0x2ca/0x3df
>> PGD 0
>> Oops: 0000 [#1] SMP
>> last sysfs file:
>> CPU 0
>> Modules linked in:
>>
>> Pid: 0, comm: swapper Tainted: G =A0 =A0 =A0 =A0W =A02.6.34-rc3 #1 /HVM =
domU
>> RIP: 0010:[<ffffffff8142f2fb>] =A0[<ffffffff8142f2fb>] cpuid4_cache_look=
up_regs+0x
>> 2ca/0x3df
>> RSP: 0018:ffff880002203e08 =A0EFLAGS: 00010046
>> RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000060
>> RDX: 0000000000000000 RSI: 0000000000000040 RDI: 0000000000000000
>> RBP: ffff880002203ed8 R08: 00000000000017c0 R09: ffff880002203e38
>> R10: ffff8800023d5d40 R11: ffffffff81a01e28 R12: ffff880187e6f5c0
>> R13: ffff880002203e34 R14: ffff880002203e58 R15: ffff880002203e68
>> FS: =A00000000000000000(0000) GS:ffff880002200000(0000) knlGS:0000000000=
000000
>> CS: =A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> CR2: 0000000000000038 CR3: 0000000001a3c000 CR4: 00000000000006f0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Process swapper (pid: 0, threadinfo ffffffff81a00000, task ffffffff81a44=
020)
>> Stack:
>> =A0ffffffff810d7ecb ffff880002203e20 ffffffff81059140 ffff880002203e30
>> <0> ffffffff810d7ec9 0000000002203e40 000000000050d140 ffff880002203e70
>> <0> 0000000002008140 0000000000000086 ffff880040020140 ffffffff81068b8b
>> Call Trace:
>> =A0<IRQ>
>> =A0[<ffffffff810d7ecb>] ? sync_supers_timer_fn+0x0/0x1c
>> =A0[<ffffffff81059140>] ? mod_timer+0x23/0x25
>> =A0[<ffffffff810d7ec9>] ? arm_supers_timer+0x34/0x36
>> =A0[<ffffffff81068b8b>] ? hrtimer_get_next_event+0xa7/0xc3
>> =A0[<ffffffff81058e85>] ? get_next_timer_interrupt+0x19a/0x20d
>> =A0[<ffffffff8142fa23>] get_cpu_leaves+0x5c/0x232
>> =A0[<ffffffff8106a7b1>] ? sched_clock_local+0x1c/0x82
>> =A0[<ffffffff8106a9a0>] ? sched_clock_tick+0x75/0x7a
>> =A0[<ffffffff8107748c>] generic_smp_call_function_single_interrupt+0xae/=
0xd0
>> =A0[<ffffffff8101f6ef>] smp_call_function_single_interrupt+0x18/0x27
>> =A0[<ffffffff8100a773>] call_function_single_interrupt+0x13/0x20
>> =A0<EOI>
>> =A0[<ffffffff8143c468>] ? notifier_call_chain+0x14/0x63
>> =A0[<ffffffff810295c6>] ? native_safe_halt+0xc/0xd
>> =A0[<ffffffff810114eb>] ? default_idle+0x36/0x53
>> =A0[<ffffffff81008c22>] cpu_idle+0xaa/0xe4
>> =A0[<ffffffff81423a9a>] rest_init+0x7e/0x80
>> =A0[<ffffffff81b10dd2>] start_kernel+0x40e/0x419
>> =A0[<ffffffff81b102c8>] x86_64_start_reservations+0xb3/0xb7
>> =A0[<ffffffff81b103c4>] x86_64_start_kernel+0xf8/0x107
>> Code: 14 d5 40 ff ae 81 8b 14 02 31 c0 3b 15 47 1c 8b 00 7d 0e 48 8b 05 =
36 1c 8b
>> =A000 48 63 d2 48 8b 04 d0 c7 85 5c ff ff ff 00 00 00 00 <8b> 70 38 48 8=
d 8d 5c ff
>> =A0ff ff 48 8b 78 10 ba c4 01 00 00 e8 eb
>> RIP =A0[<ffffffff8142f2fb>] cpuid4_cache_lookup_regs+0x2ca/0x3df
>> =A0RSP <ffff880002203e08>
>> CR2: 0000000000000038
>> ---[ end trace a7919e7f17c0a726 ]---
>>
>> The L3 cache index disable feature of AMD CPUs has to be disabled if the
>> kernel is running as guest on top of a hypervisor because northbridge
>> devices are not available to the guest. Currently, this fixes a boot
>> crash on top of Xen. In the future this will become an issue on KVM as
>> well.
>>
>> Check if northbridge devices are present and do not enable the feature
>> if there are none.
>>
>> Signed-off-by: Frank Arnold <frank.arnold@amd.com>
>> Acked-by: Borislav Petkov <borislav.petkov@amd.com>
>> ---
>> =A0arch/x86/kernel/cpu/intel_cacheinfo.c | =A0 =A04 ++++
>> =A01 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu=
/intel_cacheinfo.c
>> index acfb083..5ab14c8 100644
>> --- a/arch/x86/kernel/cpu/intel_cacheinfo.c
>> +++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
>> @@ -344,6 +344,10 @@ amd_check_l3_disable(int index, struct _cpuid4_info=
_regs *this_leaf)
>> =A0 =A0 =A0 =A0 =A0 =A0 boot_cpu_data.x86_mask < 0x1)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
>>
>> + =A0 =A0 =A0 /* not in virtualized environments */
>> + =A0 =A0 =A0 if (num_k8_northbridges =3D=3D 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
>> +
>> =A0 =A0 =A0 =A0this_leaf->can_disable =3D true;
>> =A0 =A0 =A0 =A0this_leaf->l3_indices =A0=3D amd_calc_l3_indices();
>> =A0}
>
> I think :
>
> 1. checking num_k8_northbridges is not sufficient as
> node_to_k8_nb_misc() of amd_calc_l3_indices() is almost doing the same
> thing.
>
> 2. num_k8_northbridges is CONFIG_K8_NB specific
>
> Can you try this :
>
> If you return from amd_calc_l3_indices() if dev =3D=3D NULL.
>

In the amd_calc_l3_indices(), we are using dev without testing for
NULL, it seems like a BUG to me.

In amd_check_l3_disable(), we are doing following checks :

1. boot_cpu_data.x86 =3D=3D 0x11
2. errata #382 and #388
3. num_k8_northbridges =3D=3D 0

I am wondering do we really need all three checking or it is the
workaround of the amd_calc_l3_indices() BUG.

Unfortunately, I do not have access to hardware to test the changes.
Do you mind testing this where I remove all the 3 checking conditions,
can you also test individual case if this does not work.

Thanks.


diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c
b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 95962a9..514692c 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -302,17 +302,20 @@ struct _cache_attr {
 };

 #ifdef CONFIG_CPU_SUP_AMD
-static unsigned int __cpuinit amd_calc_l3_indices(void)
+static int __cpuinit amd_calc_l3_indices(void)
 {
        /*
         * We're called over smp_call_function_single() and therefore
         * are on the correct cpu.
         */
+       unsigned int sc0, sc1, sc2, sc3;
+       u32 val =3D 0;
        int cpu =3D smp_processor_id();
        int node =3D cpu_to_node(cpu);
        struct pci_dev *dev =3D node_to_k8_nb_misc(node);
-       unsigned int sc0, sc1, sc2, sc3;
-       u32 val =3D 0;
+
+       if (!dev)
+               return -1;

        pci_read_config_dword(dev, 0x1C4, &val);

@@ -328,24 +331,17 @@ static unsigned int __cpuinit amd_calc_l3_indices(voi=
d)
 static void __cpuinit
 amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
 {
-       if (index < 3)
-               return;
+       int indices;

-       if (boot_cpu_data.x86 =3D=3D 0x11)
-               return;
-
-       /* see errata #382 and #388 */
-       if ((boot_cpu_data.x86 =3D=3D 0x10) &&
-           ((boot_cpu_data.x86_model < 0x8) ||
-            (boot_cpu_data.x86_mask  < 0x1)))
+       if (index < 3)
                return;

-       /* not in virtualized environments */
-       if (num_k8_northbridges =3D=3D 0)
+       indices =3D amd_calc_l3_indices();
+       if (indices < 0)
                return;

        this_leaf->can_disable =3D true;
-       this_leaf->l3_indices  =3D amd_calc_l3_indices();
+       this_leaf->l3_indices  =3D indices;
 }

 static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *bu=
f,

--000e0cd254d4ea2ad50486cee8b1
Content-Type: application/octet-stream; name="indices.patch"
Content-Disposition: attachment; filename="indices.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g9bnzcgu0

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9jcHUvaW50ZWxfY2FjaGVpbmZvLmMgYi9hcmNo
L3g4Ni9rZXJuZWwvY3B1L2ludGVsX2NhY2hlaW5mby5jCmluZGV4IDk1OTYyYTkuLjUxNDY5MmMg
MTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2tlcm5lbC9jcHUvaW50ZWxfY2FjaGVpbmZvLmMKKysrIGIv
YXJjaC94ODYva2VybmVsL2NwdS9pbnRlbF9jYWNoZWluZm8uYwpAQCAtMzAyLDE3ICszMDIsMjAg
QEAgc3RydWN0IF9jYWNoZV9hdHRyIHsKIH07CiAKICNpZmRlZiBDT05GSUdfQ1BVX1NVUF9BTUQK
LXN0YXRpYyB1bnNpZ25lZCBpbnQgX19jcHVpbml0IGFtZF9jYWxjX2wzX2luZGljZXModm9pZCkK
K3N0YXRpYyBpbnQgX19jcHVpbml0IGFtZF9jYWxjX2wzX2luZGljZXModm9pZCkKIHsKIAkvKgog
CSAqIFdlJ3JlIGNhbGxlZCBvdmVyIHNtcF9jYWxsX2Z1bmN0aW9uX3NpbmdsZSgpIGFuZCB0aGVy
ZWZvcmUKIAkgKiBhcmUgb24gdGhlIGNvcnJlY3QgY3B1LgogCSAqLworCXVuc2lnbmVkIGludCBz
YzAsIHNjMSwgc2MyLCBzYzM7CisJdTMyIHZhbCA9IDA7CiAJaW50IGNwdSA9IHNtcF9wcm9jZXNz
b3JfaWQoKTsKIAlpbnQgbm9kZSA9IGNwdV90b19ub2RlKGNwdSk7CiAJc3RydWN0IHBjaV9kZXYg
KmRldiA9IG5vZGVfdG9fazhfbmJfbWlzYyhub2RlKTsKLQl1bnNpZ25lZCBpbnQgc2MwLCBzYzEs
IHNjMiwgc2MzOwotCXUzMiB2YWwgPSAwOworCisJaWYgKCFkZXYpCisJCXJldHVybiAtMTsKIAog
CXBjaV9yZWFkX2NvbmZpZ19kd29yZChkZXYsIDB4MUM0LCAmdmFsKTsKIApAQCAtMzI4LDI0ICsz
MzEsMTcgQEAgc3RhdGljIHVuc2lnbmVkIGludCBfX2NwdWluaXQgYW1kX2NhbGNfbDNfaW5kaWNl
cyh2b2lkKQogc3RhdGljIHZvaWQgX19jcHVpbml0CiBhbWRfY2hlY2tfbDNfZGlzYWJsZShpbnQg
aW5kZXgsIHN0cnVjdCBfY3B1aWQ0X2luZm9fcmVncyAqdGhpc19sZWFmKQogewotCWlmIChpbmRl
eCA8IDMpCi0JCXJldHVybjsKKwlpbnQgaW5kaWNlczsKIAotCWlmIChib290X2NwdV9kYXRhLng4
NiA9PSAweDExKQotCQlyZXR1cm47Ci0KLQkvKiBzZWUgZXJyYXRhICMzODIgYW5kICMzODggKi8K
LQlpZiAoKGJvb3RfY3B1X2RhdGEueDg2ID09IDB4MTApICYmCi0JICAgICgoYm9vdF9jcHVfZGF0
YS54ODZfbW9kZWwgPCAweDgpIHx8Ci0JICAgICAoYm9vdF9jcHVfZGF0YS54ODZfbWFzayAgPCAw
eDEpKSkKKwlpZiAoaW5kZXggPCAzKQogCQlyZXR1cm47CiAKLQkvKiBub3QgaW4gdmlydHVhbGl6
ZWQgZW52aXJvbm1lbnRzICovCi0JaWYgKG51bV9rOF9ub3J0aGJyaWRnZXMgPT0gMCkKKwlpbmRp
Y2VzID0gYW1kX2NhbGNfbDNfaW5kaWNlcygpOworCWlmIChpbmRpY2VzIDwgMCkKIAkJcmV0dXJu
OwogCiAJdGhpc19sZWFmLT5jYW5fZGlzYWJsZSA9IHRydWU7Ci0JdGhpc19sZWFmLT5sM19pbmRp
Y2VzICA9IGFtZF9jYWxjX2wzX2luZGljZXMoKTsKKwl0aGlzX2xlYWYtPmwzX2luZGljZXMgID0g
aW5kaWNlczsKIH0KIAogc3RhdGljIHNzaXplX3Qgc2hvd19jYWNoZV9kaXNhYmxlKHN0cnVjdCBf
Y3B1aWQ0X2luZm8gKnRoaXNfbGVhZiwgY2hhciAqYnVmLAo=
--000e0cd254d4ea2ad50486cee8b1--
